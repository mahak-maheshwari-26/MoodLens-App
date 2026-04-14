from pydantic import BaseModel
from datetime import datetime
from typing import List

class AdminDashboardStats(BaseModel):
    total_users: int
    active_last_week: int
    age_distribution: dict # e.g., {"18-25": 10, "26-35": 5}
    recent_journals_count: int

class UserAdminView(BaseModel):
    id: str
    full_name: str
    email: str
    age: int
    created_at: datetime