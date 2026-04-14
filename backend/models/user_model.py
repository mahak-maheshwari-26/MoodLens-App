from .base import Base 
from sqlalchemy import Column,String, DateTime
from sqlalchemy.orm import relationship
import uuid
from sqlalchemy.sql import func


class UserAuth(Base):
    __tablename__ = 'User'

    id = Column(String(36), primary_key= True ,index= True , default= lambda : str(uuid.uuid4()))
    email = Column(String , unique= True , index=True , nullable=False)
    hashed_password = Column(String, nullable=False) # hash the normal string password and store it in Large

    created_at = Column(DateTime(timezone=True) , server_default= func.now())
    last_login = Column(DateTime(timezone=True), server_default=func.now(), onupdate=func.now())

    details = relationship("UserDetails", back_populates="owner", uselist= False)
    journals = relationship("JournalEntry", back_populates="owner")
    feedbacks = relationship("Feedback", back_populates="owner")
    
    @property
    def has_profile(self):
        # if details is not None then it means user has created profile otherwise not
        return self.details is not None
