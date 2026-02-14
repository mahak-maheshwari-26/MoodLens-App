from datetime import datetime, timedelta
from typing import Optional
from fastapi import APIRouter, Depends, HTTPException, Request
from sqlalchemy.orm import Session
from sqlalchemy import extract,func
from database import get_db
from models import JournalEntry, UserAuth
import auth_utils
from security_utils import encrypt_text, decrypt_text
from pydantic_schemas import journal_schema


router = APIRouter(prefix="/journals")

# Emotion categories with their thresholds
EMOTION_THRESHOLDS = {
    "joy" : 0.50,
    "sadness" : 0.25,
    "fear" : 0.25,
    "anger" : 0.35,
    "shame" : 0.30,
    "guilt" : 0.30,
    "disgust" : 0.40
}


@router.post("/",response_model= journal_schema.JournalDetailResponse)
async def create_journal_entry(
    request: Request,
    journal_in : journal_schema.JournalCreate,
    db : Session = Depends(get_db),
    current_user = Depends(auth_utils.get_current_user)
):
    """
    1) Analyze mood using model
    2) Encrypt content
    3) Store in db and return full details to frontend
    """

    model = request.state.mood_predictor

    # Get confidence scores for all labels
    raw_results = model(journal_in.content)[0]

    # Apply thresholds
    detected_emotions = [res for res in raw_results if res['score'] >= EMOTION_THRESHOLDS.get(res['label'],0.5)] 
    detected_emotions.sort(key = lambda x : x['score'], reverse = True)

    primary = "neutral"
    secondary = None
    conf_score = raw_results[0]['score']

    if len(detected_emotions) >=1:
        primary = detected_emotions[0]['label']
        conf_score = detected_emotions[0]['score']

        if len(detected_emotions) >= 2:
            secondary = detected_emotions[1]['label']


    # encrypt content
    encrypted_data = encrypt_text(journal_in.content)

    # store in db
    db_entry = JournalEntry(
        title = journal_in.title,
        encrypted_content = encrypted_data,
        primary_emotion = primary,
        secondary_emotion = secondary,
        confidence_score = conf_score,
        owner_id = current_user.id
    )

    db.add(db_entry)
    db.commit()
    db.refresh(db_entry)

    # Return detailed response model to frontend

    return journal_schema.JournalDetailResponse(
        id = db_entry.id,
        title = db_entry.title,
        content = journal_in.content,
        primary_emotion = db_entry.primary_emotion,
        secondary_emotion = db_entry.secondary_emotion,
        confidence_score = db_entry.confidence_score,
        created_at = db_entry.created_at
    )
 


@router.get("/",response_model = journal_schema.JournalListResponse)
def list_my_journals(
    db : Session = Depends(get_db),
    current_user = Depends(auth_utils.get_current_user),
    month: Optional[int] = None,
    year: Optional[int] = None
):
    """ 
    Returns journal summaries for a specific month/year.
    - Default: Current Month & Current Year
    - If Month passed, Year is Current Year
    - If Year passed, Month is Current Month

    """

    now = datetime.now()

    target_month = month if month is not None else now.month
    target_year = year if year is not None else now.year
    
    entries = (
        db.query(JournalEntry)
        .filter(JournalEntry.owner_id == current_user.id)
        .filter(extract('year', JournalEntry.created_at) == target_year)
        .filter(extract('month', JournalEntry.created_at) == target_month)
        .order_by(JournalEntry.created_at.desc())
        .all()
    )

    # entries = []
    # for entry in db_entries:
    #     entries.append({
    #         "id": entry.id,
    #         "title": entry.title,
    #         "content": decrypt_text(entry.encrypted_content), 
    #         "primary_emotion": entry.primary_emotion,
    #         "secondary_emotion": entry.secondary_emotion,
    #         "confidence_score": entry.confidence_score,
    #         "created_at": entry.created_at
    #     })

    return{
        "entries" : entries,
        "total_count" : len(entries)
    }


@router.get("/recent", response_model=journal_schema.JournalListResponse)
def get_recent_journals(
    db : Session = Depends(get_db),
    current_user = Depends(auth_utils.get_current_user)
):
    """ 
    Returns journals from last 7 days only
    """

    seven_days_ago = datetime.now() - timedelta(days=7)

    entries = (
        db.query(JournalEntry)
        .filter(
            JournalEntry.owner_id == current_user.id,
            JournalEntry.created_at >= seven_days_ago
        ).order_by(JournalEntry.created_at.desc()).all()        
    )

    return {
        "entries" : entries,
        "total_count" : len(entries)
    }
    

@router.get("/stats", response_model = journal_schema.JournalStatsResponse)

def get_journal_stats(
    db : Session = Depends(get_db),
    current_user = Depends(auth_utils.get_current_user)
):
    # Get total count of user's journal entries
    total_entries = db.query(JournalEntry).filter(JournalEntry.owner_id == current_user.id).count()

    # Get heatmap data
    heatmap_data = (
        db.query(
            func.date(JournalEntry.created_at).label("date"),
            func.count(JournalEntry.id).label("count")
        )
        .filter(JournalEntry.owner_id == current_user.id)
        .group_by(func.date(JournalEntry.created_at)).all()
    )

    formatted_heatmap = [{"date" : str(h.date), "count" : h.count} for h in heatmap_data]
     

    mood_data = (
        db.query(
            JournalEntry.primary_emotion.label("emotion"),
            func.count(JournalEntry.id).label("count")
        )
        .filter(JournalEntry.owner_id == current_user.id)
        .group_by(JournalEntry.primary_emotion).all()
    )

    mood_distribution_data = [{ "emotion" : m.emotion,"count":m.count} for m in mood_data]

    return journal_schema.JournalStatsResponse(
        total_journal_count = total_entries,
        heatmap = formatted_heatmap,
        mood_distribution = mood_distribution_data
    )


@router.get("/{journal_id}", response_model=journal_schema.JournalDetailResponse)
def get_journal_entry(
    journal_id : int,
    db: Session = Depends(get_db),
    current_user = Depends(auth_utils.get_current_user)
):
    """Feteches a specificentry and decrypts the content and send to frontend"""

    entry = db.query(JournalEntry).filter(
        JournalEntry.id == journal_id,
        JournalEntry.owner_id == current_user.id
    ).first()

    if not entry:
        raise HTTPException(status_code=404, detail = "Journal Entry not found")
    
    # Decrypt content
    decrypted_content = decrypt_text(entry.encrypted_content)

    return journal_schema.JournalDetailResponse(
        id = entry.id,
        title = entry.title,
        content = decrypted_content,
        primary_emotion = entry.primary_emotion,
        secondary_emotion = entry.secondary_emotion,
        confidence_score = entry.confidence_score,
        created_at = entry.created_at
    )
