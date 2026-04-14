from sqlalchemy import Column, Integer, String, DateTime, ForeignKey
from sqlalchemy.sql import func
from .base import Base 
from sqlalchemy.orm import relationship


class Feedback(Base):
    __tablename__ = "Feedbacks"

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(String(36), ForeignKey("User.id"), nullable=False)
    rating = Column(Integer, nullable=False)  # 1 to 5
    comment = Column(String, nullable=True)   # Optional text
    created_at = Column(DateTime(timezone=True), server_default=func.now())

    owner = relationship("UserAuth" , back_populates= "feedbacks")
