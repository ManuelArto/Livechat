from app.config import settings
from app.schemas import (
    UserCreateSchema,
    UserDocument,
    AuthUserResponse,
    UserResponse,
)
from app.helpers import hashing, jwt_helper
from app.db import db


class UserService:
    @staticmethod
    def save(user: UserCreateSchema) -> AuthUserResponse:
        # STORE USER
        user.password = hashing.hash_password(user.password)

        document_user = user.dict() | {
            "created_at": user._created_at,
            "updated_at": user._updated_at,
            "friends": [],
        }

        user_id = db.USER.insert_one(document_user).inserted_id

        return UserService.create_auth_user_response(
            UserDocument(id=str(user_id), friends=[], **user.dict())
        )

    @staticmethod
    def retrieve_user_by(key: str, value: any) -> UserDocument:
        user = db.USER.find_one(filter={key: value})
        if not user:
            return None

        return UserDocument(id=str(user["_id"]), **user)

    @staticmethod
    def retrieve_users(ids: list) -> UserDocument:
        users = db.USER.find(filter={"_id": {"$in": ids}})

        return [UserDocument(id=str(user["_id"]), **user) for user in users]

    # DOCUMENT -> RESPONSE

    @staticmethod
    def create_user_response(user: UserDocument) -> UserResponse:
        return UserResponse(
            **dict(user),
            imageUrl=settings.FIREBASE_IMAGE_URL.format(user.id),
        )

    @staticmethod
    def create_auth_user_response(user: UserDocument) -> AuthUserResponse:
        # GENERATE TOKENS
        token, exp_in_token = jwt_helper.generate_token(user.id, user.username)
        refresh_token, exp_in_refresh_token = jwt_helper.generate_refresh_token(user.id)

        # Convert friends to UserResponse
        user.friends = [
            UserService.create_user_response(user)
            for user in UserService.retrieve_users(user.friends)
        ]

        return AuthUserResponse(
            **dict(user),
            imageUrl=settings.FIREBASE_IMAGE_URL.format(user.id),
            token=token,
            expInToken=exp_in_token,
            refreshToken=refresh_token,
            expInRefreshToken=exp_in_refresh_token,
        )
