from pydantic import BaseModel, ConfigDict , EmailStr
from datetime import datetime
from typing import Optional

class TokenResponse(BaseModel):
    access_token : str
    token_type : str = "bearer"
    email : EmailStr
    last_login : Optional[datetime] = None
    message: Optional[str] = None

    # model_config = ConfigDict(from_attributes=True)
    class Config:
        from_attributes : True