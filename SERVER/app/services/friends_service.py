from bson import ObjectId
from app.schemas import UserDocument
from app.db import db
from app.services.steps_service import StepsService


class FriendsService:
    @staticmethod
    def retrieve_user_friends(user_id: ObjectId) -> list[UserDocument]:
        user = db.USER.find_one(filter={"_id": user_id})
        if not user:
            return []

        friend_ids = user["friends"]
        friends = db.USER.find(filter={"_id": {"$in": friend_ids}})
        users_steps = StepsService.retrieve_users_steps(friend_ids)

        return [
            UserDocument(
                id=str(friend["_id"]),
                steps=users_steps[friend["_id"]],
                **friend,
            )
            for friend in friends
        ]

    @staticmethod
    def delete_friendship(user_id: ObjectId, friend_id: ObjectId) -> UserDocument | None:
        db.USER.update_many(
            filter={"_id": {"$in": [user_id, friend_id]}},
            update={"$pull": {"friends": {"$in": [user_id, friend_id]}}},
        )

        friend = db.USER.find_one(filter={"_id": friend_id})
        if not friend:
            return None

        steps = StepsService.retrieve_steps(str(friend_id))

        return UserDocument(id=str(friend_id), steps=steps, **friend)

    @staticmethod
    def add_friend(user_id: ObjectId, friend_id: ObjectId) -> UserDocument:
        db.USER.update_one(
            filter={"_id": user_id}, update={"$push": {"friends": friend_id}}
        )

        db.USER.update_one(
            filter={"_id": friend_id}, update={"$push": {"friends": user_id}}
        )
        friend = db.USER.find_one(filter={"_id": friend_id})

        steps = StepsService.retrieve_steps(friend["_id"])

        return UserDocument(id=str(friend["_id"]), steps=steps, **friend)

    @staticmethod
    def suggested_friends(
        user: UserDocument, page: int, per_page: int
    ) -> list[UserDocument]:
        users = (
            db.USER.find(filter={"_id": {"$nin": [ObjectId(user.id), *user.friends]}})
            .skip((page - 1) * per_page)
            .limit(per_page)
        )

        users = list(users)
        user_ids = [user["_id"] for user in users]
        users_steps = StepsService.retrieve_users_steps(user_ids)

        return [
            UserDocument(id=str(user["_id"]), steps=users_steps[user["_id"]], **user)
            for user in users
        ]

    @staticmethod
    def search_friends(user: UserDocument, query: str) -> list[UserDocument]:
        users = db.USER.find(
            filter={
                "_id": {"$nin": [ObjectId(user.id), *user.friends]},
                "username": {"$regex": query, "$options": "i"},
            }
        )

        users = list(users)
        users_steps = StepsService.retrieve_users_steps([user["_id"] for user in users])

        return [
            UserDocument(id=str(user["_id"]), steps=users_steps[user["_id"]], **user)
            for user in users
        ]

    @staticmethod
    def retrieve_contacts(user: UserDocument, numbers: list[str]) -> list[UserDocument]:
        users = db.USER.find(
            filter={
                "_id": {"$nin": [ObjectId(user.id), *user.friends]},
                "phoneNumber": {"$in": numbers},
            }
        )

        users = list(users)
        users_steps = StepsService.retrieve_users_steps([user["_id"] for user in users])

        return [
            UserDocument(id=str(user["_id"]), steps=users_steps[user["_id"]], **user)
            for user in users
        ]
