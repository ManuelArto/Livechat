from typing import Annotated
from bson import ObjectId
from fastapi import APIRouter, Depends, HTTPException, status
from pymongo.errors import DuplicateKeyError

from app.helpers import jwt_helper
from app.services.friends_service import FriendsService
from app.services.requests_service import RequestsService
from app.services.user_service import UserService
from app.routers.ws.chat import sio_server

router = APIRouter()

@router.get("/list")
async def list_requests(
    user_data: Annotated[dict, Depends(jwt_helper.get_current_user)],
    sended: bool = False,
):
    requests = RequestsService.retrieve_user_requests(ObjectId(user_data["id"]), sended)

    return {"data": requests}

@router.post("/{receiver_id}/send")
async def send_request(
    user_data: Annotated[dict, Depends(jwt_helper.get_current_user)],
    receiver_id: str,
):
    user = UserService.retrieve_user_by("username", user_data["username"])
    if ObjectId(receiver_id) in user.friends:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="You are already friends",
        )
    try:
        RequestsService.add_request(ObjectId(user_data["id"]), ObjectId(receiver_id))
    except DuplicateKeyError as _:
        raise HTTPException(
            status_code=status.HTTP_409_CONFLICT,
            detail="Request already sent",
        )

    return {"message": "Request sent"}


@router.post("/{sender_id}/accept")
async def accept_request(
    user_data: Annotated[dict, Depends(jwt_helper.get_current_user)],
    sender_id: str,
):

    RequestsService.delete(ObjectId(user_data["id"]), ObjectId(sender_id))

    friend = FriendsService.add_friend(ObjectId(user_data["id"]), ObjectId(sender_id))
    user = UserService.retrieve_user_by("username", user_data["username"])

    await sio_server.emit(
        "new_friend", data=dict(UserService.create_user_response(user)), room=friend.username
    )
    await sio_server.emit(
        "new_friend", data=dict(UserService.create_user_response(friend)), room=user.username
    )

    return {"message": "Request accepted"}


@router.delete("/{user_id}")
async def delete_request(
    user_data: Annotated[dict, Depends(jwt_helper.get_current_user)],
    user_id: str,
):
    RequestsService.delete(ObjectId(user_data["id"]), ObjectId(user_id))

    return {"message": "Request deleted"}
