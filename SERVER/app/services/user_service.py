from datetime import datetime

from app.config import settings
from app.schemas import UserCreateSchema, UserDB, UserLoginSchema, UserResponse
from app.helpers import hashing, jwt
from app.db import db

class UserService:
    @staticmethod
    def save(user: UserCreateSchema) -> UserResponse:
        # STORE USER
        user.password = hashing.hash_password(user.password)
        user.created_at = datetime.utcnow()
        user.updated_at = user.created_at

        id = db.User.insert_one(dict(user)).inserted_id

        return UserService.createUserResponse(UserDB(id = str(id), **dict(user)))

    @staticmethod
    def retrieveUser(user: UserLoginSchema) -> UserDB:
        user = db.User.find_one(filter={"email":user.email})
        if not user:
            return None
        
        return UserDB(id = str(user["_id"]), **user)

    @staticmethod
    def retrieveUserByUsername(username: str) -> UserDB:
        user = db.User.find_one(filter={"username": username})
        if not user:
            return None
        
        return UserDB(id = str(user["_id"]), **user)
    
    @staticmethod
    def createUserResponse(user: UserDB) -> UserResponse:
		# GENERATE TOKENS
        token, expInToken = jwt.generate_token(user.id, user.username)
        refreshToken, expInRefreshToken = jwt.generate_refresh_token(user.id)

        return UserResponse(
            **dict(user),
            imageUrl=settings.FIREBASE_IMAGE_URL.format(user.id),
            token=token,
            expInToken=expInToken,
            refreshToken=refreshToken,
            expInRefreshToken=expInRefreshToken
        )
        

