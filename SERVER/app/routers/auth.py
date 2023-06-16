import base64
from typing import Annotated
from fastapi import APIRouter, HTTPException, Request, Response, status, Depends
from pymongo.errors import DuplicateKeyError

from app.services.user_service import UserService
from app.schemas import AuthUserResponse, UserLoginSchema, UserCreateSchema
from app.helpers import fb_images_upload, hashing, jwt


router = APIRouter()


@router.post("/register", status_code=status.HTTP_201_CREATED)
async def register(body: UserCreateSchema, request: Request) -> AuthUserResponse:
	try:
		user = UserService.save(body)

		fb_images_upload.upload_image(
		    user.id, base64.decodebytes(body.imageFile.encode())
		)
	except DuplicateKeyError as e:
		duplicate_fields = e.details['keyPattern'].keys()
		raise HTTPException(
			status_code=status.HTTP_409_CONFLICT, 
			detail=f"User already exists, duplicate {', '.join(duplicate_fields)}"
		)

	return user


@router.post("/login")
def login(body: UserLoginSchema, response: Response) -> AuthUserResponse:
	user = UserService.retrieveUser(body)

	if not user:
		raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="No user with that email")
	
	if not hashing.verify_password(body.password, user.password):
		raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="Invalid password")
	
	userResponse = UserService.createAuthUserResponse(user)

	return userResponse


@router.get("/refreshToken")
def refresh_token(data: Annotated[str, Depends(jwt.get_current_user)]) -> AuthUserResponse:
	user = UserService.retrieveUserByUsername(data.username)

	if not user:
		raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="No user with that id")
	
	return UserService.createAuthUserResponse(user)