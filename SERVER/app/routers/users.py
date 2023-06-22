from typing import Annotated
from fastapi import APIRouter, Depends

from app.services.user_service import UserService
from app.schemas import UserResponse
from app.helpers import jwt_helper

router = APIRouter()


@router.get("/list")
async def retrieve_users(
    user_data: Annotated[dict, Depends(jwt_helper.get_current_user)],
    page: int = 1,
    per_page: int = 10,
) -> dict[str, list[UserResponse]]:
    users = UserService.retrieve_users(
        user_id=user_data["id"], page=page, per_page=per_page
    )

    return {"data": [UserService.create_user_response(user) for user in users]}
