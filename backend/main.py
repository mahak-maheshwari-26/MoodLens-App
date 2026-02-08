from fastapi import FastAPI
from database import engine
from sqlalchemy.orm import Session
import models
from models.base import Base
import models
from routes import auth

app = FastAPI()

Base.metadata.create_all(engine)

app.include_router(auth.router)


