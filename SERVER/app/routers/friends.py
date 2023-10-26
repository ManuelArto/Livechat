from typing import Annotated
from bson import ObjectId
from fastapi import APIRouter, Depends, Query

from app.services.friends_service import FriendsService
from app.schemas import FriendResponse
from app.helpers import jwt_helper
from app.services.user_service import UserService
from app.routers.ws.chat import sio_server

router = APIRouter()


@router.get("/list")
async def list_friends(
    user_data: Annotated[dict, Depends(jwt_helper.get_current_user)],
) -> dict[str, list[FriendResponse]]:
    friends = FriendsService.retrieve_user_friends(ObjectId(user_data["id"]))

    return {"data": [UserService.create_user_response(friend) for friend in friends]}


@router.delete("/{friend_id}")
async def remove_friend(
    user_data: Annotated[dict, Depends(jwt_helper.get_current_user)],
    friend_id: str,
):
    friend = FriendsService.delete_friendship(
        ObjectId(user_data["id"]), ObjectId(friend_id)
    )

    data = {"id": user_data["id"], "username": user_data["username"]}
    await sio_server.emit(
        "friend_deleted", data=data, room=friend.username
    )

    return {"message": f"Friend {friend.username} removed from your friends list"}


@router.get("/suggested")
async def retrieve_suggested(
    user_data: Annotated[dict, Depends(jwt_helper.get_current_user)],
    page: int = 1,
    per_page: int = 10,
) -> dict[str, list[FriendResponse]]:
    user = UserService.retrieve_user_by("_id", ObjectId(user_data["id"]))

    users = FriendsService.suggested_friends(user, page=page, per_page=per_page)

    return {"data": [UserService.create_user_response(user) for user in users]}

@router.get("/searchNewFriends")
async def search(
    user_data: Annotated[dict, Depends(jwt_helper.get_current_user)],
    query: str,
) -> dict[str, list[FriendResponse]]:
    user = UserService.retrieve_user_by("_id", ObjectId(user_data["id"]))

    users = FriendsService.search_friends(user, query=query)

    return {"data": [UserService.create_user_response(user) for user in users]}

@router.get("/contacts")
async def retrieve_contacts(
    user_data: Annotated[dict, Depends(jwt_helper.get_current_user)],
    numbers: list[str] = Query(None, description="List of phone numbers")
) -> dict[str, list[FriendResponse]]:
    user = UserService.retrieve_user_by("_id", ObjectId(user_data["id"]))

    users = FriendsService.retrieve_contacts(user, numbers=numbers)

    return {"data": [UserService.create_user_response(user) for user in users]}
