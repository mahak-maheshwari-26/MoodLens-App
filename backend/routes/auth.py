from fastapi import HTTPException, APIRouter , Depends
from sqlalchemy.orm import Session
import bcrypt 
from models import UserAuth
import pydantic_schemas as schemas
from database import get_db 


router = APIRouter()

@router.post('/signup', status_code=201)
def signup_user(user_data : schemas.UserCreate , db :Session = Depends(get_db)):
    
    # check if user already exists in database
    # UserAuth class in user_model.py
    existing_user = db.query(UserAuth).filter(UserAuth.email == user_data.email).first()

    if existing_user:
        raise HTTPException(
            status_code=400,
            detail="User with this email already exists. Use another email."
        )
    
    # Hash password 
    hashed_pw = bcrypt.hashpw(password = user_data.password.encode(), salt= bcrypt.gensalt(12)) # it is in bytes

    # convert bytes in string to store in PostgreSql
    hashed_pw_str = hashed_pw.decode()

    # Create new User(Database Table) Object
    new_user = UserAuth(
        email =  user_data.email,
        hashed_password = hashed_pw_str
    )

    # save to database
    try:
        db.add(new_user)
        db.commit()
        db.refresh(new_user)
    except Exception as e:
        db.rollback()
        raise HTTPException(
            status_code=500,
            detail="Database error occured."
        )
    return {"message": f"User created successfully! {new_user.email}"}
    # Return JWT Token
    # call create_access_token here



@router.post('/login')
def login_user(user_data : schemas.UserLogin, db : Session = Depends(get_db)):
    
    # check if user with same email already exists then only they can login
    user_exists = db.query(UserAuth).filter(UserAuth.email == user_data.email).first()

    if not user_exists:
        raise HTTPException(
            status_code=400,
            detail="User with this email does not exist."
        )

    # if password matches then return data
    is_match = bcrypt.checkpw(password = user_data.password.encode(),hashed_password= user_exists.hashed_password.encode())

    # if not matches return error
    if not is_match:
        raise HTTPException(
            status_code=400,
            detail="Incorrect Password!"
        )
    
    return {"message": f"Login successful! Welcome {user_exists.email}"}
    # return 