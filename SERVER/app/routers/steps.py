from typing import Annotated
from bson import ObjectId
from fastapi import APIRouter, Depends

from app.helpers import jwt_helper
from app.services.friends_service import FriendsService
from app.services.steps_service import StepsService
from app.routers.ws.chat import sio_server

router = APIRouter()


@router.post("/update")
async def update_steps(
    user_data: Annotated[dict, Depends(jwt_helper.get_current_user)],
    steps: int,
):
    user = StepsService.update_steps(ObjectId(user_data["id"]), steps)

    friends = FriendsService.retrieve_user_friends(ObjectId(user_data["id"]))

    for friend in friends:
        data = {"steps": steps, "username": user.username}
        await sio_server.emit(
            "friend_steps_update", data=data, room=friend.username
        )

    return {"message": "Steps updated"}

@router.get("/weeklyCharts")
async def get_weekly_charts(user_data: Annotated[dict, Depends(jwt_helper.get_current_user)]):
    weekly_charts = StepsService.get_user_weekly_charts(ObjectId(user_data["id"]))

    return {"data": weekly_charts}
