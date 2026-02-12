from fastapi import APIRouter, Depends, HTTPException 
from models import UserAuth, UserDetails
from database import get_db 
from sqlalchemy.orm import Session
import auth_utils
import pydantic_schemas as schemas

router = APIRouter()

@router.post('/update-profile',status_code=200)
def update_profile(
    profile_data : schemas.UserProfile,
    db : Session = Depends(get_db),
    current_user : UserAuth = Depends(auth_utils.get_current_user)
):
    # If profile already exists
    profile = db.query(UserDetails).filter(UserDetails.user_id == current_user.id).first()

    if profile:
        # update existing
        profile.full_name = profile_data.full_name
        
        db.commit()
        db.refresh(profile)
        message = "Name updated successfully!"

    else:
        if not profile_data.birthdate:
            raise HTTPException(
                status_code = 400,
                detail = "Birthdate required for the first time profile creation"
            )
        # Create a new profile
        new_profile = UserDetails(
            full_name = profile_data.full_name,
            birthdate = profile_data.birthdate,
            user_id = current_user.id
        )
        db.add(new_profile)
        message = "Profile created successfully"
    
        db.commit()
        db.refresh(new_profile)

    return{"status" : "success" , "message": message}

@router.get('/me', response_model = schemas.UserProfileDisplay)
def get_user_profile(
    db : Session = Depends(get_db),
    current_user : UserAuth = Depends(auth_utils.get_current_user)
):
    
    # Current user has email already
    profile = db.query(UserDetails).filter(UserDetails.user_id == current_user.id).first()

    return {
        "full_name" : profile.full_name if profile else "New User",
        "email" : current_user.email
    }