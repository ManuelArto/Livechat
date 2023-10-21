from bson import ObjectId
from app.schemas import GroupSchema, GroupResponse
from app.db import db


class GroupService:
    @staticmethod
    def create(group: GroupSchema, user_id: ObjectId):
        document_group = group.dict() | {
            "admin": user_id,
            "created_at": group._created_at,
            "updated_at": group._updated_at,
        }

        group_id = db.GROUP.insert_one(document_group).inserted_id

        return GroupResponse(
            id=str(group_id),
            admin=str(user_id),
            created_at=group._created_at,
            updated_at=group._updated_at,
            **group.dict(),
        )

    @staticmethod
    def remove(group_id: ObjectId):
        db.GROUP.delete_one({"_id": group_id})

    @staticmethod
    def add_partecipants(
        group_id: ObjectId, user_id: ObjectId, partecipant_ids: list[str]
    ):
        pass

    @staticmethod
    def remove_partecipant(group_id: ObjectId, user_id: ObjectId, partecipant_id: str):
        pass

    @staticmethod
    def retrieve_groups(user_id: ObjectId):
        pass
