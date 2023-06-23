from bson import ObjectId
from app.schemas import (
    UserDocument,
)
from app.db import db


class FriendsService:
    @staticmethod
    def suggested_friends(
        user: UserDocument, page: int, per_page: int
    ) -> list[UserDocument]:
        users = (
            db.USER.find(filter={"_id": {"$nin": [ObjectId(user.id), *user.friends]}})
            .skip((page - 1) * per_page)
            .limit(per_page)
        )

        return [UserDocument(id=str(user["_id"]), **user) for user in users]

    @staticmethod
    def retrieve_user_friends(user_id: ObjectId) -> list[UserDocument]:
        user = db.USER.find_one(filter={"_id": user_id})
        if not user:
            return []

        friends = db.USER.find(filter={"_id": {"$in": user["friends"]}})

        return [UserDocument(id=str(friend["_id"]), **friend) for friend in friends]

    @staticmethod
    def delete_friendship(
        user_id: ObjectId, friend_id: ObjectId
    ) -> UserDocument | None:
        db.USER.update_one(
            filter={"_id": user_id}, update={"$pull": {"friends": friend_id}}
        )

        db.USER.update_one(
            filter={"_id": friend_id}, update={"$pull": {"friends": user_id}}
        )
        friend = db.USER.find_one(filter={"_id": friend_id})
        if not friend:
            return None

        return UserDocument(id=str(friend["_id"]), **friend)

    @staticmethod
    def add_friend(user_id: ObjectId, friend_id: ObjectId) -> UserDocument | None:
        db.USER.update_one(
            filter={"_id": user_id}, update={"$push": {"friends": friend_id}}
        )

        db.USER.update_one(
            filter={"_id": friend_id}, update={"$push": {"friends": user_id}}
        )
        friend = db.USER.find_one(filter={"_id": friend_id})
        if not friend:
            return None

        return UserDocument(id=str(friend["_id"]), **friend)
