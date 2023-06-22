from bson import ObjectId
from app.schemas import (
    UserDocument,
)
from app.db import db


class FriendsService:
    @staticmethod
    def retrieve_user_friends(user_id: ObjectId) -> list[UserDocument]:
        user = db.User.find_one(filter={"_id": user_id})
        if not user:
            return []

        friends = db.User.find(filter={"_id": {"$in": user["friends"]}})

        return [UserDocument(id=str(friend["_id"]), **friend) for friend in friends]

    @staticmethod
    def delete_friendship(
        user_id: ObjectId, friend_id: ObjectId
    ) -> UserDocument | None:
        db.User.update_one(
            filter={"_id": user_id}, update={"$pull": {"friends": friend_id}}
        )

        db.User.update_one(
            filter={"_id": friend_id}, update={"$pull": {"friends": user_id}}
        )
        friend = db.User.find_one(filter={"_id": friend_id})
        if not friend:
            return None

        return UserDocument(id=str(friend["_id"]), **friend)

    @staticmethod
    def add_friend(user_id: ObjectId, friend_id: ObjectId) -> UserDocument | None:
        db.User.update_one(
            filter={"_id": user_id}, update={"$push": {"friends": friend_id}}
        )

        db.User.update_one(
            filter={"_id": friend_id}, update={"$push": {"friends": user_id}}
        )
        friend = db.User.find_one(filter={"_id": friend_id})
        if not friend:
            return None

        return UserDocument(id=str(friend["_id"]), **friend)
