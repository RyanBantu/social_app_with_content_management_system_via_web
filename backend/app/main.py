from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from app.config import CORS_ORIGINS
from app.routers import devotion, events, health, ministries, sermons, uploads

app = FastAPI(title="MHC CMS API", version="1.0.0")

app.add_middleware(
    CORSMiddleware,
    allow_origins=CORS_ORIGINS or ["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(health.router)
app.include_router(uploads.router)
app.include_router(uploads.config_router)
app.include_router(devotion.router)
app.include_router(events.router)
app.include_router(ministries.router)
app.include_router(sermons.router)
