from app.config import settings
from app.schemas import UserCreateSchema, UserDocument, UserLoginSchema, UserResponse
from app.helpers import hashing, jwt
from app.db import db

class UserService:
    @staticmethod
    def save(user: UserCreateSchema) -> UserResponse:
        # STORE USER
        user.password = hashing.hash_password(user.password)

        document_user = user.dict() | {"created_at": user._created_at, "updated_at": user._updated_at}

        id = db.User.insert_one(document_user).inserted_id

        return UserService.createUserResponse(UserDocument(id = str(id), **user.dict()))

    @staticmethod
    def retrieveUser(user: UserLoginSchema) -> UserDocument:
        user = db.User.find_one(filter={"email":user.email})
        if not user:
            return None
        
        return UserDocument(id = str(user["_id"]), **user)

    @staticmethod
    def retrieveUserByUsername(username: str) -> UserDocument:
        user = db.User.find_one(filter={"username": username})
        if not user:
            return None
        
        return UserDocument(id = str(user["_id"]), **user)
    
    @staticmethod
    def createUserResponse(user: UserDocument) -> UserResponse:
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
        

