from datetime import datetime
from pydantic import BaseModel, EmailStr, constr, Field

# HTTP SCHEMAS

## Base - Input

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


class GroupSchema(BaseModel):
    name: str
    partecipants: list[str]
    _created_at: datetime = datetime.utcnow()
    _updated_at: datetime = datetime.utcnow()


## Response


class UserResponse(UserSchema):
    id: str
    imageUrl: str


class FriendResponse(UserResponse):
    location: dict  # {"lat": 0.0, "long": 0.0}
    steps: int


class GroupResponse(BaseModel):
    id: str
    name: str
    admin: str
    partecipants: list[UserResponse]
    created_at: datetime
    updated_at: datetime


class AuthUserResponse(FriendResponse):
    token: str
    expInToken: int
    refreshToken: str
    expInRefreshToken: int
    friends: list[FriendResponse]
    groups: list[GroupResponse]


class FriendRequestSendedResponse(BaseModel):
    sender: str
    receiver: FriendResponse


class FriendRequestReceivedResponse(BaseModel):
    sender: FriendResponse
    receiver: str


# MONGO SCHEMAS


class UserDocument(UserSchema):
    id: str
    password: str
    steps: int
    location: dict  # {"lat": 0.0, "long": 0.0}
    friends: list  # ObjectId | UserDocument
    groups: list   # ObjectId | GroupSchema


class FriendRequest(BaseModel):
    sender: str
    receiver: str


class UsersSteps(BaseModel):
    steps: int
    day: datetime
    user: str

class GroupDocument(GroupResponse):
    pass
