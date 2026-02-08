from .base import Base 
import uuid
from sqlalchemy import Column,String, Date, ForeignKey
from sqlalchemy.orm import relationship

class UserDetails(Base):

    __tablename__ = "User_Details"

    id = Column(String(36), primary_key=True, default= str(uuid.uuid4()))
    full_name = Column(String)
    birthdate = Column(Date)

    # use tablename as string for forign key
    user_id = Column(String(36) , ForeignKey("User.id") , unique=True)

    # Name of class in string
    owner = relationship("UserAuth" , back_populates= "details")