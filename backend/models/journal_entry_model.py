from sqlalchemy import Column, DateTime, ForeignKey, Integer, String, func, Float
from sqlalchemy.orm import relationship
from .base import Base 


class JournalEntry(Base):
    __tablename__ = "journal_entries"

    id = Column(Integer,primary_key = True,index=True)
    title = Column(String, nullable=False)
    encrypted_content = Column(String, nullable=False)

    primary_emotion = Column(String, nullable=False)
    secondary_emotion = Column(String, nullable=True)
    confidence_score = Column(Float) # Score of primary emotion

    created_at = Column(DateTime(timezone=True), server_default = func.now())
    updated_at = Column(DateTime(timezone=True), onupdate=func.now())

    owner_id = Column(String(36), ForeignKey("User.id"), nullable = False)
    owner = relationship("UserAuth", back_populates="journals")