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
from app.routers import auth, friends, friend_requests, location, steps, ranking, groups
from app.routers.ws import chat

app.include_router(auth.router, tags=["Auth"], prefix="/api/auth")
app.include_router(friends.router, tags=["Friends"], prefix="/api/friends")
app.include_router(friend_requests.router, tags=["Friends Requests"], prefix="/api/requests")
app.include_router(location.router, tags=["User Location"], prefix="/api/location")
app.include_router(steps.router, tags=["User Steps"], prefix="/api/steps")
app.include_router(ranking.router, tags=["Users Ranking"], prefix="/api/ranking")
app.include_router(groups.router, tags=["Groups"], prefix="/api/groups")
app.mount('/', app=chat.sio_app)


# Error handlers
from app.error_handlers import add_exception_handlers
add_exception_handlers(app)
