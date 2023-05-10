from flask_sqlalchemy import SQLAlchemy
import bcrypt
import uuid
from ..helpers.jwt import generate_refresh_token, generate_token

db = SQLAlchemy()


def init_app(app):
    db.init_app(app)
    with app.app_context():
        db.create_all()


class Users(db.Model):
    __tablename = "USERS"
    id = db.Column(db.Integer, primary_key=True)
    uid = db.Column(db.String(50), unique=True)
    email = db.Column(db.String(50), unique=True)
    imageUrl = db.Column(db.String(200), unique=True)
    username = db.Column(db.String(50), unique=True)
    password = db.Column(db.String(200))

    def __init__(self, email, username, password):
        self.uid = str(uuid.uuid4())
        self.email = email
        self.imageUrl = f"https://firebasestorage.googleapis.com/v0/b/livechat-e7db8.appspot.com/o/profileIcons%2F{self.uid}.jpg?alt=media"
        self.username = username
        self.password = bcrypt.hashpw(password.encode("utf-8"), bcrypt.gensalt()).decode("utf-8")

    def check_password(self, password):
        return bcrypt.checkpw(password.encode(), self.password.encode())

    def __repr__(self):
        return "<id {}>".format(self.uid)

    def serialize(self):
        refreshToken, expInRefreshToken = generate_refresh_token(self)
        token, expInToken = generate_token(self)
        return {
            "uid": self.uid,
            "username": self.username,
            "imageUrl": self.imageUrl,
            "token": token,
            "refreshToken": refreshToken,
            "expInToken": expInToken,
            "expInRefreshToken": expInRefreshToken,
        }
