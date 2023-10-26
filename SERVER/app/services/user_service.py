from bson import ObjectId
from app.config import settings
from app.schemas import UserCreateSchema, UserDocument, AuthUserResponse, FriendResponse, UserResponse
from app.helpers import hashing, jwt_helper
from app.db import db
from app.services.steps_service import StepsService


class UserService:
    @staticmethod
    def save(user: UserCreateSchema) -> AuthUserResponse:
        # STORE USER
        user.password = hashing.hash_password(user.password)

        document_user = user.dict() | {
            "created_at": user._created_at,
            "updated_at": user._updated_at,
            "location": {"lat": 0.0, "long": 0.0},
            "friends": [],
        }

        user_id = db.USER.insert_one(document_user).inserted_id

        return UserService.create_auth_user_response(
            UserDocument(
                id=str(user_id),
                friends=[],
                location={},
                steps=0,
                **user.dict(),
            )
        )

    @staticmethod
    def remove(user_id: ObjectId):
        db.USER.delete_one({"_id": user_id})

    @staticmethod
    def retrieve_user_by(key: str, value: any) -> UserDocument:
        user = db.USER.find_one(filter={key: value})
        if not user:
            return None

        steps = StepsService.retrieve_steps(user_id=user["_id"])

        return UserDocument(id=str(user["_id"]), steps=steps, **user)

    @staticmethod
    def retrieve_users(ids: list) -> UserDocument:
        users = db.USER.find(filter={"_id": {"$in": ids}})

        users_steps = StepsService.retrieve_users_steps(ids)

        return [
            UserDocument(id=str(user["_id"]), steps=users_steps[user["_id"]], **user)
            for user in users
        ]

    @staticmethod
    def update_location(user_id: ObjectId, lat: float, long: float) -> UserDocument:
        db.USER.update_one(
            filter={"_id": user_id},
            update={"$set": {"location": {"lat": lat, "long": long}}},
        )

        user = db.USER.find_one(filter={"_id": user_id})

        return UserDocument(id=str(user["_id"]), steps=0, **user)

    # DOCUMENT -> RESPONSE

    @staticmethod
    def create_user_response(user: UserDocument, is_friend: bool = True) -> FriendResponse:
        image_url = settings.FIREBASE_IMAGE_URL.format(user.id)
        return (
            FriendResponse(**dict(user), imageUrl=image_url)
            if is_friend
            else UserResponse(**dict(user), imageUrl=image_url)
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

        from app.services.groups_service import GroupService
        user.groups = GroupService.retrieve_user_groups(ObjectId(user.id))

        return AuthUserResponse(
            **dict(user),
            imageUrl=settings.FIREBASE_IMAGE_URL.format(user.id),
            token=token,
            expInToken=exp_in_token,
            refreshToken=refresh_token,
            expInRefreshToken=exp_in_refresh_token,
        )
