from typing import Annotated
from bson import ObjectId
from fastapi import APIRouter, Depends

from app.helpers import jwt_helper
from app.services.friends_service import FriendsService
from app.services.user_service import UserService
from app.routers.ws.chat import sio_server

router = APIRouter()


@router.post("/update")
async def accept_request(
    user_data: Annotated[dict, Depends(jwt_helper.get_current_user)],
    lat: float,
    long: float,
):
    user = UserService.update_location(user_id=ObjectId(user_data["id"]), lat=lat, long=long)

    friends = FriendsService.retrieve_user_friends(ObjectId(user_data["id"]))

    for friend in friends:
        data = {**user.location, "username": user.username}
        await sio_server.emit(
            "friend_location_update", data=data, room=friend.username
        )

    return {"message": "Location updated"}
