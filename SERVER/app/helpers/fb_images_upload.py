from os import path
import os
import firebase_admin
from firebase_admin import credentials
from firebase_admin import storage

from app.config import settings

cred = credentials.Certificate(
    path.join(path.dirname(__file__), "credentials.json")
    if settings.DEBUG_MODE
    else os.getenv("credentials_path")
)
firebase_admin.initialize_app(cred, {"storageBucket": "livechat-e7db8.appspot.com"})

bucket = storage.bucket()


def upload_image(uid: str, image: bytes):
    bucket.blob(f"profileIcons/{uid}.jpg").upload_from_string(
        image, content_type="image/jpeg"
    )
