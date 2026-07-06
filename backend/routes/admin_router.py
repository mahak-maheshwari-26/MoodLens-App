import auth_utils
import models
from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from datetime import datetime, timedelta
from database import get_db
from models import UserAuth, UserDetails, Feedback
from pydantic import BaseModel
from sqlalchemy import func, extract


router = APIRouter(prefix="/admin")

class AdminLoginRequest(BaseModel):
    username: str
    password: str

@router.post("/login")
def admin_login(request: AdminLoginRequest, db: Session = Depends(get_db)):
    admin = db.query(models.AdminUser).filter(models.AdminUser.username == request.username).first()
    
    if not admin or not auth_utils.verify_password(request.password, admin.hashed_password):
        raise HTTPException(status_code=401, detail="Invalid admin credentials")
    
    admin.last_login = datetime.now()
    db.commit()
    # db.refresh(admin)

    # Using your existing JWT logic
    access_token = auth_utils.create_access_token(data={"sub": admin.username, "role": "admin"})
    return {"access_token": access_token, "token_type": "bearer"}



@router.get("/users")
def get_admin_users(db: Session = Depends(get_db)):
    one_week_ago = datetime.now() - timedelta(days=7)
    
    # 1. Calculate users joined in last week
    new_users_count = db.query(UserAuth).filter(UserAuth.created_at >= one_week_ago).count()
    
    # 2. Fetch Users with Journal Counts
    # We join UserAuth with UserDetails and count their JournalEntry records
    users = db.query(UserAuth).all()
    
    user_list = []
    for u in users:
        # Calculate Age
        age = (datetime.now().date() - u.details.birthdate).days // 365 if u.details.birthdate else 0
        
        # Get Journal Count 
        journal_count = db.query(models.JournalEntry).filter(models.JournalEntry.owner_id == u.id).count()

        user_list.append({
            "full_name": u.details.full_name,
            "email": u.email,
            "age": age,
            "journal_count": journal_count,
            "created_at": u.created_at,
            "is_new": u.created_at >= one_week_ago
        })

    return {
        "new_users_last_week": new_users_count,
        "users": user_list
    }

@router.get("/dashboard-stats")
def get_stats(db: Session = Depends(get_db)):

    one_week_ago = datetime.now() - timedelta(days=7)

    # 1. Basic Stats
    total_users = db.query(UserAuth).count()
    total_feedback = db.query(Feedback).count()
    total_journals = db.query(models.JournalEntry).count()
    

    new_users_last_week = db.query(UserAuth).filter(UserAuth.created_at >= one_week_ago).count()

    # 2. Age Group Logic
    age_groups = {"18-25": 0, "26-35": 0, "36-50": 0, "50+": 0}
    details = db.query(UserDetails).all()
    for d in details:
        age = (datetime.now().date() - d.birthdate).days // 365 if d.birthdate else 0
        if age <= 25: age_groups["18-25"] += 1
        elif age <= 35: age_groups["26-35"] += 1
        elif age <= 50: age_groups["36-50"] += 1
        else: age_groups["50+"] += 1

    # 3. User Table Data
    # users = db.query(UserAuth).join(UserDetails).all()
    # user_list = [{
    #     "full_name": u.details.full_name,
    #     "email": u.email,
    #     "age": (datetime.now().date() - u.details.birthdate).days // 365,
    #     "created_at": u.created_at
    # } for u in users]

    users = db.query(UserAuth).all()
    user_list = []
    for u in users:
        age = (datetime.now().date() - u.details.birthdate).days // 365 if u.details.birthdate else 0
        # Count journals per user
        user_journal_count = db.query(models.JournalEntry).filter(models.JournalEntry.owner_id == u.id).count()
        
        user_list.append({
            "full_name": u.details.full_name,
            "email": u.email,
            "age": age,
            "journal_count": user_journal_count,
            "created_at": u.created_at
        })

    # 4. Feedback List
    feedbacks = db.query(Feedback).join(UserAuth).all()
    feedback_list = [{
        "user": f.owner.email,
        "rating": f.rating,
        "comment": f.comment,
        "date": f.created_at
    } for f in feedbacks]

    return {
        "stats": {
            "total_users": total_users,
            "total_feedback": total_feedback,
            "total_journals": total_journals,
            "new_users_last_week": new_users_last_week,
        },
        "age_dist": age_groups,
        "users": user_list,
        "feedbacks": feedback_list
    }


@router.get("/feedback-analytics")
def get_feedback_analytics(db: Session = Depends(get_db)):
    # 1. Monthly Trend Data (Last 6 Months)
    six_months_ago = datetime.now() - timedelta(days=180)
    monthly_stats = db.query(
        extract('month', Feedback.created_at).label('month'),
        func.count(Feedback.id).label('count')
    ).filter(Feedback.created_at >= six_months_ago)\
     .group_by('month').all()
    
    all_f = db.query(Feedback).all()
    feedback_list = [{
        "user": f.owner.email if f.owner else "Anonymous",
        "rating": f.rating,
        "comment": f.comment,
        "date": f.created_at.isoformat() if f.created_at else None
    } for f in all_f]

    return {
        "monthly_trend": [{"month": m[0], "count": m[1]} for m in monthly_stats],
        "all_feedbacks":  feedback_list
    }