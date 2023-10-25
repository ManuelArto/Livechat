from typing import Annotated
from bson import ObjectId
from fastapi import APIRouter, HTTPException, status, Depends
from pymongo.errors import DuplicateKeyError

from app.services.groups_service import GroupService
from app.schemas import GroupSchema, GroupResponse
from app.helpers import jwt_helper
from app.routers.ws.chat import sio_server

router = APIRouter()

@router.post("/create")
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
    groups = GroupService.retrieve_user_groups(ObjectId(user_data["id"]))
    return groups

@router.delete("/{group_id}")
async def delete(
    user_data: Annotated[dict, Depends(jwt_helper.get_current_user)],
    group_id: str
):
    GroupService.delete(ObjectId(group_id), ObjectId(user_data["id"]))
    return {"message": "Group deleted"}

@router.post("/{group_id}/add")
async def add_partecipants(
    user_data: Annotated[dict, Depends(jwt_helper.get_current_user)],
    group_id: str,
    partecipant_ids: list[str]
):
    GroupService.add_partecipants(
        ObjectId(group_id),
        ObjectId(user_data["id"]),
        partecipant_ids
    )
    return {"message": "Partecipants added"}

@router.post("/{group_id}/remove")
async def remove_partecipant(
    user_data: Annotated[dict, Depends(jwt_helper.get_current_user)],
    group_id: str,
    partecipant_id: str
):
    GroupService.remove_partecipant(
        ObjectId(group_id),
        ObjectId(user_data["id"]),
        partecipant_id
    )
    return {"message": "Partecipant removed"}

@router.post("/{group_id}/leave")
async def leave(
    user_data: Annotated[dict, Depends(jwt_helper.get_current_user)],
    group_id: str
):
    GroupService.leave(ObjectId(group_id), ObjectId(user_data["id"]))
    return {"message": "You left the group"}
