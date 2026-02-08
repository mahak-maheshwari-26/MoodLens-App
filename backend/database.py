from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
import os
from dotenv import load_dotenv

# load .env file
load_dotenv()

# get database url from .env
DATABASE_URL = os.getenv("database_url")

# create engine : connection to postgresql
engine = create_engine(DATABASE_URL)

# New Database Session Creation each time
SessionLocal = sessionmaker(autocommit = False, autoflush= False,bind= engine)



# Dependency

def get_db():
    db = SessionLocal()

    try:
        yield db
    finally:
        db.close()
