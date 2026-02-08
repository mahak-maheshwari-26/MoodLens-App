from pydantic import BaseModel , EmailStr
from datetime import datetime
from typing import Optional

class TokenResponse(BaseModel):
    access_token : str
    token_type : str = "bearer"
    email : EmailStr
    last_login : Optional[datetime] = None

    class Config:
        from_attributes : True