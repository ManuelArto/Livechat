from datetime import datetime
from pydantic import BaseModel, EmailStr, constr, Field

# HTTP SCHEMAS

class UserSchema(BaseModel):
    username: constr(min_length=6, max_length=15)
    email: EmailStr
    phoneNumber: constr(min_length=10, max_length=10)
    _created_at: datetime = datetime.utcnow()
    _updated_at: datetime = datetime.utcnow()


class UserCreateSchema(UserSchema):
    password: constr(min_length=8)
    imageFile: str = Field(exclude=True)

    class Config:
        exclude = {"imageFile"}


class UserLoginSchema(BaseModel):
    email: EmailStr
    password: constr(min_length=8)


class UserResponse(UserSchema):
    id: str
    imageUrl: str
    location: dict  # {"lat": 0.0, "long": 0.0}
    steps: int


class AuthUserResponse(UserResponse):
    token: str
    expInToken: int
    refreshToken: str
    expInRefreshToken: int
    friends: list[UserResponse]


class FriendRequestSendedResponse(BaseModel):
    sender: str
    receiver: UserResponse


class FriendRequestReceivedResponse(BaseModel):
    sender: UserResponse
    receiver: str


# MONGO SCHEMAS


class UserDocument(UserSchema):
    id: str
    password: str
    steps: int
    location: dict  # {"lat": 0.0, "long": 0.0}
    friends: list  # ObjectId | UserDocument


class FriendRequest(BaseModel):
    sender: str
    receiver: str


class UsersSteps(BaseModel):
    steps: int
    day: datetime
    user: str
