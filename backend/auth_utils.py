import os
from datetime import datetime, timedelta , timezone
from dotenv import load_dotenv
from jose import JWTError , jwt
from fastapi import Depends , HTTPException
from fastapi.security import OAuth2PasswordBearer
from sqlalchemy.orm import Session
from database import get_db
import models
import bcrypt

load_dotenv()

SECRET_KEY = os.getenv("SECRET_KEY")
ALGORITHM = os.getenv("ALGORITHM")
ACCESS_TOKEN_EXPIRE_MINUTES = int(os.getenv("ACCESS_TOKEN_EXPIRE_MINUTES") or 10080)

oauth2_scheme = OAuth2PasswordBearer(tokenUrl="/login")


# Step 1 : Creating the Token
def create_access_token(data : dict):
    to_encode = data.copy()
    expire = datetime.now(timezone.utc) + timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)

    to_encode.update({"exp" : expire})
    encoded_jwt = jwt.encode(to_encode,SECRET_KEY,algorithm = ALGORITHM)

    return encoded_jwt

# Step 2 : Verify the token
def get_current_user(token: str = Depends(oauth2_scheme) , db : Session = Depends(get_db)):
    
    credentials_exception = HTTPException(
        status_code=401,
        detail="Could Not validate credentials",
        headers={"WWW-Authenticate" : "Bearer"}
    )

    try:
        # Decode the token
        payload = jwt.decode(token, SECRET_KEY,algorithms=[ALGORITHM])
        user_id : str = payload.get("sub") #sub contains user_id

        if user_id is None:
            raise credentials_exception
    except JWTError:
        raise credentials_exception
    
    # find user in database
    user = db.query(models.UserAuth).filter(models.UserAuth.id == user_id).first()

    if user is None:
        raise credentials_exception
    
    return user # it returns the user object from DB

def verify_password(plain_password: str, hashed_password: str):
    return bcrypt.checkpw(plain_password.encode(), hashed_password.encode())

def hash_password(password: str):
    return bcrypt.hashpw(password.encode(), bcrypt.gensalt(12)).decode()