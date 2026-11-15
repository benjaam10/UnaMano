from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from app.core.config import settings
from app.api import auth, locations, tasks, applications, profile, chat, admin

app=FastAPI(title="UnaMano API",version="1.0.0",description="Marketplace de tareas sin ORM")
app.add_middleware(
    CORSMiddleware,
    allow_origins=[settings.frontend_origin, "http://127.0.0.1:5173"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)
app.include_router(auth.router)
app.include_router(locations.router)
app.include_router(tasks.router)
app.include_router(applications.router)
app.include_router(profile.router)
app.include_router(chat.router)
app.include_router(admin.router)

@app.get("/health")
def health(): return {"status":"ok"}
