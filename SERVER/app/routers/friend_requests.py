from typing import Annotated
from fastapi import APIRouter, Depends

from app.helpers import jwt_helper

router = APIRouter()


@router.post("/{id}/send")
async def send_request(
    user_data: Annotated[dict, Depends(jwt_helper.get_current_user)],
    id: str,
):
    # Add request to requests collection
    return {"message": "Request sent"}


@router.post("/{id}/accept")
async def accept_request(
    user_data: Annotated[dict, Depends(jwt_helper.get_current_user)],
    id: str,
):
    # Add request to requests schema

    return {"message": "Request accepted"}


@router.delete("/{id}")
async def delete_request(
    user_data: Annotated[dict, Depends(jwt_helper.get_current_user)],
    id: str,
):
    # Add request to requests schema
    return {"message": "Request deleted"}
