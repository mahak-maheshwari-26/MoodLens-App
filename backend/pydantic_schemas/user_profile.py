from pydantic import BaseModel, ConfigDict, EmailStr
from datetime import date
from typing import Optional


class UserProfile(BaseModel):
    full_name : str
    birthdate : Optional[date] = None


class UserProfileDisplay(BaseModel):
    full_name: str
    email : EmailStr

    model_config = ConfigDict(from_attributes = True)

    # class Config:
    #     from_attributes = True