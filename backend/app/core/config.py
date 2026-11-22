import os
from typing import List, Union
from pydantic_settings import BaseSettings

class Settings(BaseSettings):
    PROJECT_NAME: str = "NagarSetu"
    VERSION: str = "2.0.0"
    TAGLINE: str = "Bridging Citizens. Empowering Cities."
    HINDI_TAGLINE: str = "नागरिकों और प्रशासन के बीच एक सेतु"
    API_V1_STR: str = "/api/v1"
    
    # Secret Key & JWT Configuration
    SECRET_KEY: str = "nagarsetu_super_secret_jwt_key_2026_change_in_production"
    ALGORITHM: str = "HS256"
    ACCESS_TOKEN_EXPIRE_MINUTES: int = 60 * 24 * 7  # 7 days
    
    # Database Configuration (SQLite default for seamless portable setup; PostgreSQL ready)
    DATABASE_URL: str = "sqlite:///./civicsense.db"
    
    # Storage Paths
    BASE_DIR: str = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
    UPLOAD_DIR: str = os.path.join(BASE_DIR, "uploads")
    ORIGINAL_IMG_DIR: str = os.path.join(UPLOAD_DIR, "original")
    ANNOTATED_IMG_DIR: str = os.path.join(UPLOAD_DIR, "annotated")
    RESOLUTION_IMG_DIR: str = os.path.join(UPLOAD_DIR, "resolutions")
    VOICE_DIR: str = os.path.join(UPLOAD_DIR, "voice")
    
    # CORS Origins
    CORS_ORIGINS: List[str] = [
        "http://localhost:5173",
        "http://127.0.0.1:5173",
        "http://localhost:3000",
        "http://127.0.0.1:3000",
        "http://localhost:8000",
        "http://127.0.0.1:8000",
    ]
    
    # Priority Scoring Engine Weights (Sum = 1.0)
    WEIGHT_CATEGORY: float = 0.35
    WEIGHT_CONFIDENCE: float = 0.15
    WEIGHT_DEFECT_AREA: float = 0.15
    WEIGHT_DUPLICATES: float = 0.20
    WEIGHT_AGING: float = 0.15
    
    # Duplicate Detection Parameters
    DUPLICATE_RADIUS_METERS: float = 50.0  # 50 meters
    DUPLICATE_TIME_WINDOW_HOURS: float = 72.0  # 72 hours
    
    # Service Level Agreement (SLA) Targets in Hours
    SLA_CRITICAL_HOURS: int = 24    # 24 hours
    SLA_HIGH_HOURS: int = 48        # 48 hours
    SLA_MODERATE_HOURS: int = 120   # 5 days
    SLA_LOW_HOURS: int = 168        # 7 days
    
    class Config:
        env_file = ".env"
        extra = "allow"

settings = Settings()

# Ensure upload directories exist
os.makedirs(settings.ORIGINAL_IMG_DIR, exist_ok=True)
os.makedirs(settings.ANNOTATED_IMG_DIR, exist_ok=True)
os.makedirs(settings.RESOLUTION_IMG_DIR, exist_ok=True)
os.makedirs(settings.VOICE_DIR, exist_ok=True)
