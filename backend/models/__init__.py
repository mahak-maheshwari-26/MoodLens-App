# models/__init__.py 

from .base import Base

# importing all models

from .user_model import UserAuth
from .user_details_model import UserDetails
from .journal_entry_model import JournalEntry
from .admin_model import AdminUser
from .feedback_model import Feedback