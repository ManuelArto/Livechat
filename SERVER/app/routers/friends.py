from typing import Annotated
from bson import ObjectId
from fastapi import APIRouter, Depends

from app.services.friends_service import FriendsService
from app.schemas import UserResponse
from app.helpers import jwt_helper
from app.services.user_service import UserService

router = APIRouter()

# FRIENDS


@router.get("/list")
async def list_friends(
    user_data: Annotated[dict, Depends(jwt_helper.get_current_user)],
) -> dict[str, list[UserResponse]]:
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
    return {"message": f"Friend {friend.username} removed from your friends list"}


@router.get("/suggested")
async def retrieve_users(
    user_data: Annotated[dict, Depends(jwt_helper.get_current_user)],
    page: int = 1,
    per_page: int = 10,
) -> dict[str, list[UserResponse]]:
    user = UserService.retrieve_user_by("_id", ObjectId(user_data["id"]))

    users = FriendsService.suggested_friends(
        user, page=page, per_page=per_page
    )

    return {"data": [UserService.create_user_response(user) for user in users]}
