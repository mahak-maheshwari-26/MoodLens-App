from sqlalchemy import Column, String, DateTime, Boolean, Integer, func
from .base import Base
import uuid


class AdminUser(Base):
    __tablename__ = 'Admins'
    id = Column(String(36), primary_key=True, default=lambda: str(uuid.uuid4()))
    username = Column(String, unique=True, index=True)
    hashed_password = Column(String, nullable=False)
    last_login = Column(DateTime(timezone=True), onupdate=func.now())