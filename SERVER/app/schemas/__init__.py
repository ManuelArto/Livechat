# import uuid
from bson import ObjectId
from pydantic import BaseModel, EmailStr, Field, constr
from datetime import datetime

# HTTP SCHEMAS

class UserSchema(BaseModel):
    username: str
    email: EmailStr
    created_at: datetime | None = None
    updated_at: datetime | None = None


class UserCreateSchema(UserSchema):
    password: constr(min_length=8)
    imageFile: str


class UserLoginSchema(BaseModel):
    email: EmailStr
    password: constr(min_length=8)


class UserResponse(UserSchema):
    id: str
    imageUrl: str
    token: str
    expInToken: int
    refreshToken: str
    expInRefreshToken: int

# MONGO SCHEMAS

class UserDB(UserSchema):
    id: str
    password: str