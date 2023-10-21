from typing import Annotated
from bson import ObjectId
from fastapi import APIRouter, HTTPException, status, Depends
from pymongo.errors import DuplicateKeyError

from app.services.groups_service import GroupService
from app.schemas import GroupSchema, GroupResponse
from app.helpers import jwt_helper
from app.routers.ws.chat import sio_server

router = APIRouter()

@router.post("/new")
async def create_group(
    user_data: Annotated[dict, Depends(jwt_helper.get_current_user)],
    body: GroupSchema
) -> GroupResponse:
    try:
        group_response = GroupService.create(body, ObjectId(user_data["id"]))

    except DuplicateKeyError as _:
        raise HTTPException(
            status_code=status.HTTP_409_CONFLICT,
            detail="Group with the same name already exists",
        )

    return group_response

@router.get("/list")
async def list_groups(
    user_data: Annotated[dict, Depends(jwt_helper.get_current_user)],
) -> list[GroupResponse]:
    pass