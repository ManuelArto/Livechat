import base64
from typing import Annotated
from bson import ObjectId
from fastapi import APIRouter, HTTPException, Request, Response, status, Depends
from pymongo.errors import DuplicateKeyError

from app.services.user_service import UserService
from app.schemas import AuthUserResponse, UserLoginSchema, UserCreateSchema
from app.helpers import fb_images_upload, hashing, jwt_helper


router = APIRouter()


@router.post("/register", status_code=status.HTTP_201_CREATED)
async def register(body: UserCreateSchema, _: Request) -> AuthUserResponse:
    try:
        user = UserService.save(body)

        fb_images_upload.upload_image(
            user.id, base64.decodebytes(body.imageFile.encode())
        )
    except DuplicateKeyError as error:
        duplicate_fields = error.details["keyPattern"].keys()
        raise HTTPException(
            status_code=status.HTTP_409_CONFLICT,
            detail=f"User already exists, duplicate {', '.join(duplicate_fields)}",
        )
    except Exception as _:
        UserService.remove(ObjectId(user.id))
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Internal server error",
        )

    return user


@router.post("/login")
def login(body: UserLoginSchema, _: Response) -> AuthUserResponse:
    user = UserService.retrieve_user_by("email", body.email)

    if not user:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND, detail="No user with that email"
        )

    if not hashing.verify_password(body.password, user.password):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED, detail="Invalid password"
        )

    user_response = UserService.create_auth_user_response(user)

    return user_response


@router.get("/refreshToken")
def refresh_token(
    user_data: Annotated[dict, Depends(jwt_helper.get_current_user)]
) -> AuthUserResponse:
    user = UserService.retrieve_user_by("username", user_data["username"])

    if not user:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND, detail="No user with that id"
        )

    return UserService.create_auth_user_response(user)
