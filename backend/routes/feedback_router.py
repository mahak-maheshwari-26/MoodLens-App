from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from database import get_db
from models import Feedback
import  pydantic_schemas as schemas
from auth_utils import get_current_user 

router = APIRouter(prefix="/feedback", tags=["Feedback"])

@router.post("", response_model=schemas.FeedbackResponse)
def submit_feedback(feedback: schemas.FeedbackCreate, db: Session = Depends(get_db), current_user = Depends(get_current_user)):
    new_feedback = Feedback(
        user_id=current_user.id,
        rating=feedback.rating,
        comment=feedback.comment
    )
    db.add(new_feedback)
    db.commit()
    db.refresh(new_feedback)
    return new_feedback

# Admin-only route to view all feedback
@router.get("/all")
def get_all_feedbacks(db: Session = Depends(get_db)):
    return db.query(Feedback).all()