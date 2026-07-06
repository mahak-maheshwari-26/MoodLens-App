from datetime import datetime
from typing import List, Optional
from pydantic import BaseModel, ConfigDict


# What frontend sends to the fastapi

class JournalCreate(BaseModel):
    title : str
    content : str

class JournalUpdate(BaseModel):
    title : Optional[str] = None
    content : Optional[str] = None


# Response schemas , what fastapi send to frontend


class JournalResponse(BaseModel):
    """Used for list/dashboard view"""

    id : int
    title : str
    primary_emotion : str
    secondary_emotion : Optional[str] = None
    confidence_score : float
    created_at : datetime
    updated_at : Optional[datetime] = None

    model_config = ConfigDict(from_attributes = True)

class JournalDetailResponse(JournalResponse):
    """Includes full content, used when opening a specific journal entry"""
    content : str # only used when opening the full entry


class JournalListResponse(BaseModel):
    """Specifically for Dashboar/Calender view"""
    entries : List[JournalResponse]
    total_count : int

    model_config = ConfigDict(from_attributes = True)
    

# for heatmap in stats page
class HeatmapItem(BaseModel):
    date : str
    count : int


# for donut chart in stats page
class MoodDistributionEntry(BaseModel):
    emotion : str
    count : int

class JournalStatsResponse(BaseModel):
    total_journal_count : int
    heatmap : List[HeatmapItem]
    mood_distribution : List[MoodDistributionEntry]