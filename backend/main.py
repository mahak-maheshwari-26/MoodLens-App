from fastapi import FastAPI
from database import engine
from sqlalchemy.orm import Session
import models
from models.base import Base
import models
from routes import auth, userProfile
from fastapi.middleware.cors import CORSMiddleware

app = FastAPI()

# To solve 405 options error
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"], # For production, replace "*" with your specific frontend URL
    allow_credentials=True,
    allow_methods=["*"], # Allows OPTIONS, POST, GET, etc.
    allow_headers=["*"], # Allows Authorization and Content-Type headers
)

Base.metadata.create_all(engine)

app.include_router(auth.router)
app.include_router(userProfile.router)



