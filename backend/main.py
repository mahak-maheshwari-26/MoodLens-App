from contextlib import asynccontextmanager
import gc
from fastapi import FastAPI
import torch
from transformers import pipeline
from database import engine
from sqlalchemy.orm import Session
import models
from models.base import Base
import models
from routes import auth, userProfile, journal
from fastapi.middleware.cors import CORSMiddleware



# 1. Define a global placeholder
_predictor = None 

@asynccontextmanager
async def lifespan(app: FastAPI):
    global _predictor
    
    # --- STARTUP ---
    if _predictor is None:
        print("🚀 First Load: Initializing MoodLens RoBERTa Model...")
        _predictor = pipeline(
            "text-classification",
            model="mahak-maheshwari-26/moodlens-nlp",
            top_k=None
        )
        print("✅ Model loaded and cached in global memory!")
    else:
        print("♻️ Re-using already loaded model...")

    yield {"mood_predictor": _predictor}

    # --- SHUTDOWN (Triggers on Ctrl+C) ---
    print("🛑 Server stopping. Clearing Model from RAM...")
    
    # Remove the global reference
    _predictor = None
    
    # Force Garbage Collection
    gc.collect()
    
    # Release GPU memory if it was being used
    if torch.cuda.is_available():
        torch.cuda.empty_cache()
        
    print("✨ RAM cleared. Goodbye!")

    
app = FastAPI(lifespan=lifespan)

# To solve 405 options error
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"], # For production, replace "*" with your specific frontend URL
    allow_credentials=True,
    allow_methods=["*"], # Allows OPTIONS, POST, GET, etc.
    allow_headers=["*"], # Allows Authorization and Content-Type headers
)

Base.metadata.create_all(bind = engine)

app.include_router(auth.router)
app.include_router(userProfile.router)
app.include_router(journal.router)



