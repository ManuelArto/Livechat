from bson import ObjectId

from app.db import db
from app.schemas import (
    FriendRequestReceivedResponse,
    FriendRequestSendedResponse,
)

from app.services.user_service import UserService


class RequestsService:
    @staticmethod
    def retrieve_user_requests(
        user_id: ObjectId, sended: bool = False
    ) -> list[FriendRequestSendedResponse | FriendRequestReceivedResponse]:
        if sended:
            requests = db.REQUEST.find({"sender": user_id})

            receivers = UserService.retrieve_users(
                ids=[ObjectId(request["receiver"]) for request in requests]
            )

            return [
                FriendRequestSendedResponse(
                    sender=str(user_id),
                    receiver=UserService.create_user_response(receiver),
                )
                for receiver in receivers
            ]

        else:
            requests = db.REQUEST.find({"receiver": user_id})

            senders = UserService.retrieve_users(
                ids=[ObjectId(request["sender"]) for request in requests]
            )

            return [
                FriendRequestReceivedResponse(
                    sender=UserService.create_user_response(sender),
                    receiver=str(user_id),
                )
                for sender in senders
            ]

    @staticmethod
    def add_request(user_id: ObjectId, friend_id: ObjectId):
        db.REQUEST.insert_one({"sender": user_id, "receiver": friend_id})

    @staticmethod
    def delete(user_id: ObjectId, friend_id: ObjectId):
        db.REQUEST.delete_many(
            {
                "$or": [
                    {"sender": user_id, "receiver": friend_id},
                    {"sender": friend_id, "receiver": user_id},
                ]
            }
        )
