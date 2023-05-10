import firebase_admin
from firebase_admin import credentials
from firebase_admin import storage
from os import path

cred = credentials.Certificate(path.join(path.dirname(__file__), 'credentials.json'))
firebase_admin.initialize_app(cred, {
    'storageBucket': 'livechat-e7db8.appspot.com'
})

bucket = storage.bucket()

def upload_image(uid: str, image: bytes):
    bucket.blob(f"profileIcons/{uid}.jpg").upload_from_string(image, content_type="image/jpeg")
