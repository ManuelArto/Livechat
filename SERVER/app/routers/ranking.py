from typing import Annotated
from bson import ObjectId
from fastapi import APIRouter, Depends

from app.helpers import jwt_helper
from app.schemas import FriendResponse
from app.services.friends_service import FriendsService
from app.services.steps_service import StepsService
from app.services.user_service import UserService

router = APIRouter()


@router.get("/daily")
async def daily_ranking(
    user_data: Annotated[dict, Depends(jwt_helper.get_current_user)]
) -> dict[str, list[FriendResponse]]:
    user = UserService.retrieve_user_by("username", user_data["username"])
    friends = FriendsService.retrieve_user_friends(ObjectId(user_data["id"]))

    ranking = [user, *friends]
    ranking.sort(key=lambda x: x.steps, reverse=True)

    return {"data": [UserService.create_user_response(user) for user in ranking]}

@router.get("/weekly")
async def weekly_ranking(
    user_data: Annotated[dict, Depends(jwt_helper.get_current_user)]
) -> dict[str, list[FriendResponse]]:
    user = UserService.retrieve_user_by("username", user_data["username"])
    friends = FriendsService.retrieve_user_friends(ObjectId(user_data["id"]))

    ids = [ObjectId(user_data["id"])]
    ids.extend([ObjectId(friend.id) for friend in friends])
    users_steps = StepsService.retrieve_weekly_users_steps(ids)

    ranking = [user, *friends]
    for user in ranking:
        user.steps = users_steps[ObjectId(user.id)]

    ranking.sort(key=lambda x: x.steps, reverse=True)

    return {"data": [UserService.create_user_response(user) for user in ranking]}
