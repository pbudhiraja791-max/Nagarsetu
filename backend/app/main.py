import os
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from fastapi.staticfiles import StaticFiles

from app.core.config import settings
from app.core.database import engine, Base
from app.api.v1.router import api_router

# --------------------------------------------------
# Create Database Tables & Run Schema Migrations
# --------------------------------------------------
from app.core.migrations import run_migrations
run_migrations()

# --------------------------------------------------
# Create NagarSetu FastAPI Application
# --------------------------------------------------
app = FastAPI(
    title=settings.PROJECT_NAME,
    version=settings.VERSION,
    description="NagarSetu — AI-Powered Civic Intelligence, Public Infrastructure Monitoring, and Departmental Accountability Platform (नागरिकों और प्रशासन के बीच एक सेतु)",
    openapi_url=f"{settings.API_V1_STR}/openapi.json",
    docs_url=f"{settings.API_V1_STR}/docs",
    redoc_url=f"{settings.API_V1_STR}/redoc",
)

# --------------------------------------------------
# CORS Configuration
# --------------------------------------------------
app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.CORS_ORIGINS,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# --------------------------------------------------
# Uploads Directory Mounting
# --------------------------------------------------
os.makedirs(settings.UPLOAD_DIR, exist_ok=True)
os.makedirs(settings.ORIGINAL_IMG_DIR, exist_ok=True)
os.makedirs(settings.ANNOTATED_IMG_DIR, exist_ok=True)
os.makedirs(settings.RESOLUTION_IMG_DIR, exist_ok=True)
os.makedirs(settings.VOICE_DIR, exist_ok=True)

app.mount(
    "/uploads",
    StaticFiles(directory=settings.UPLOAD_DIR),
    name="uploads",
)

# --------------------------------------------------
# Mount API v1 Router
# --------------------------------------------------
app.include_router(
    api_router,
    prefix=settings.API_V1_STR,
)

# --------------------------------------------------
# Root & Health Endpoints
# --------------------------------------------------
@app.get("/", tags=["Root"])
def root():
    return {
        "platform": "NagarSetu",
        "tagline": settings.TAGLINE,
        "hindi_tagline": settings.HINDI_TAGLINE,
        "version": settings.VERSION,
        "status": "operational",
        "api_documentation": f"{settings.API_V1_STR}/docs",
    }

@app.get("/health", tags=["Health"])
def health_check():
    return {
        "status": "online",
        "service": "NagarSetu Civic Intelligence Engine",
        "version": settings.VERSION,
        "database": "connected",
        "vision_engine": "active",
        "nlp_engine": "active",
        "predictive_analytics": "active"
    }

@app.get(f"{settings.API_V1_STR}/health", tags=["Health"])
def api_health_check():
    return {
        "status": "online",
        "service": "NagarSetu Civic Intelligence Engine",
        "version": settings.VERSION,
        "database": "connected",
    }

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(
        "app.main:app",
        host="0.0.0.0",
        port=8000,
        reload=True,
    )
