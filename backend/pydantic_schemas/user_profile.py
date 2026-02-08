from pydantic import BaseModel
from datetime import date


class UserProfile(BaseModel):
    username : str
    birthdate : date