from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from app.db import db
from app.config import settings

db.setup()
app = FastAPI()

# CORS Middleware
origins = [
    settings.CLIENT_ORIGIN,
    "*"
]
app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Routers
from app.routers import auth, chat

app.include_router(auth.router, tags=["Auth"], prefix="/api/auth")
app.mount('/', app=chat.sio_app)


# Error handlers
from app.error_handlers import add_exception_handlers
add_exception_handlers(app)