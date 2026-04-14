from pydantic import BaseModel, Field
from typing import Optional
from datetime import datetime

class FeedbackCreate(BaseModel):
    rating: int = Field(..., ge=1, le=5)
    comment: Optional[str] = None

class FeedbackResponse(FeedbackCreate):
    id: int
    user_id: str
    created_at: datetime

    class Config:
        from_attributes = True