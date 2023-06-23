import datetime
from typing import Annotated
from fastapi import HTTPException, Header
import jwt

from app.config import settings

EXP_TOKEN = datetime.timedelta(weeks=100)
EXP_REFRESH_TOKEN = datetime.timedelta(hours=4)


def get_current_user(x_access_token: Annotated[str | None, Header()] = None) -> dict:
    try:
        if not x_access_token:
            raise HTTPException(status_code=401, detail="A valid token is missing")

        data = jwt.decode(
            x_access_token, settings.SECRET_KEY, verify=True, algorithms=["HS256"]
        )

        return data

    except jwt.ExpiredSignatureError:
        raise HTTPException(status_code=401, detail="Token expired")
    except jwt.DecodeError:
        raise HTTPException(status_code=401, detail="Token is invalid")


def generate_token(user_id, username) -> tuple[str, int]:
    return (
        jwt.encode(
            {
                "id": user_id,
                "username": username,
                "iat": datetime.datetime.utcnow(),
            },
            # 'exp': datetime.datetime.utcnow() + EXP_TOKEN},
            settings.SECRET_KEY,
        ),
        EXP_TOKEN.seconds,
    )


def generate_refresh_token(user_id) -> tuple[str, int]:
    return (
        jwt.encode(
            {
                "id": user_id,
                "iat": datetime.datetime.utcnow(),
                "exp": datetime.datetime.utcnow() + EXP_REFRESH_TOKEN,
            },
            settings.SECRET_KEY,
            algorithm="HS256",
        ),
        EXP_REFRESH_TOKEN.seconds,
    )
