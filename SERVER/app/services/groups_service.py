from bson import ObjectId
from fastapi import HTTPException, status
from app.schemas import GroupSchema, GroupResponse
from app.services.user_service import UserService # ! To avoid circular import
from app.db import db

class GroupService:
    @staticmethod
    def create(group: GroupSchema, user_id: ObjectId):
        group.partecipants.append(str(user_id))
        document_group = group.dict() | {
            "admin": user_id,
            "created_at": group._created_at,
            "updated_at": group._updated_at,
        }
        group_id = db.GROUP.insert_one(document_group).inserted_id

        # update all user groups
        db.USER.update_many(
            filter={"_id": {"$in": [ObjectId(id) for id in group.partecipants]}},
            update={"$push": {"groups": group_id}}
        )

        return GroupResponse(
            id=str(group_id),
            admin=str(user_id),
            created_at=group._created_at,
            updated_at=group._updated_at,
            **group.dict(),
        )

    @staticmethod
    def delete(group_id: ObjectId, user_id: ObjectId):
        group = GroupService.assert_admin(group_id, user_id)

        db.GROUP.delete_one({"_id": group_id})

        db.USER.update_many(
            filter={"_id": {"$in": [ObjectId(id) for id in group["partecipants"]]}},
            update={"$pull": {"groups": group_id}}
        )

    @staticmethod
    def add_partecipants(
        group_id: ObjectId, user_id: ObjectId, partecipant_ids: list[str]
    ):
        GroupService.assert_admin(group_id, user_id)

        db.GROUP.update_one(
            filter={"_id": group_id},
            update={"$push": {"partecipants": {"$each": partecipant_ids}}},
        )
        db.USER.update_many(
            filter={"_id": {"$in": [ObjectId(id) for id in partecipant_ids]}},
            update={"$push": {"groups": group_id}},
        )

    @staticmethod
    def remove_partecipant(group_id: ObjectId, user_id: ObjectId, partecipant_id: str):
        GroupService.assert_admin(group_id, user_id)

        db.GROUP.update_one(
            filter={"_id": group_id},
            update={"$pull": {"partecipants": partecipant_id}},
        )
        db.USER.update_one(
            filter={"_id": ObjectId(partecipant_id)},
            update={"$pull": {"groups": group_id}},
        )

    @staticmethod
    def leave(group_id: ObjectId, user_id: ObjectId):
        db.GROUP.update_one(
            filter={"_id": group_id},
            update={"$pull": {"partecipants": user_id}},
        )
        db.USER.update_one(
            filter={"_id": user_id},
            update={"$pull": {"groups": group_id}},
        )

    @staticmethod
    def retrieve_user_groups(user_id: ObjectId) -> list[GroupResponse]:
        user = db.USER.find_one({"_id": user_id})

        groups_ids = user["groups"]
        groups = db.GROUP.find({"_id": {"$in": groups_ids}})

        return [
            GroupService.create_group_response(group)
            for group in groups
        ]

    @staticmethod
    def create_group_response(group: GroupSchema) -> GroupResponse:
        group["admin"] = str(group["admin"])

        partecipant_ids = [ObjectId(id) for id in group["partecipants"]]
        group["partecipants"] = [
            UserService.create_user_response(user, is_friend=False)
            for user in UserService.retrieve_users(partecipant_ids)
        ]

        return GroupResponse(
            id=str(group["_id"]),
            **dict(group),
        )

    @staticmethod
    def assert_admin(group_id: ObjectId, user_id: ObjectId):
        group = db.GROUP.find_one({"_id": group_id})
        if group["admin"] != user_id:
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="You are not the admin of this group",
            )
        return group
