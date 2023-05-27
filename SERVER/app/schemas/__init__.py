from pydantic import BaseModel, EmailStr, constr, Field
from datetime import datetime

# HTTP SCHEMAS

class UserSchema(BaseModel):
    username: constr(min_length=6, max_length=30)
    email: EmailStr
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
    token: str
    expInToken: int
    refreshToken: str
    expInRefreshToken: int

# MONGO SCHEMAS

class UserDocument(UserSchema):
    id: str
    password: str