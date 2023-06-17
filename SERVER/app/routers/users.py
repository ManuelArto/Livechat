from typing import Annotated
from fastapi import APIRouter, Depends

from app.services.user_service import UserService
from app.schemas import UserResponse
from app.helpers import jwt

router = APIRouter()


@router.get("/list")
async def retrieve_users(
    data: Annotated[str, Depends(jwt.get_current_user)],
    page: int = 1,
    per_page: int = 10,
) -> dict:
    users = UserService.retrieveUsers(page=page, per_page=per_page)

    return {"data": [UserService.createUserResponse(user) for user in users]}
