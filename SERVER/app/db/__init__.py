from pymongo import mongo_client, collection
import pymongo
from app.config import settings


class MongoDB:
    User: collection.Collection

    def setup(self):
        client = mongo_client.MongoClient(
            settings.DATABASE_URL, serverSelectionTimeoutMS=5000
        )

        try:
            conn = client.server_info()
            print(f'Connected to MongoDB {conn.get("version")}')
        except Exception:
            print("Unable to connect to the MongoDB server.")

        db = client[settings.MONGO_INITDB_DATABASE]
        self.User = db.users

        self.User.create_index([("email", pymongo.ASCENDING)], unique=True)
        self.User.create_index([("username", pymongo.ASCENDING)], unique=True)
        self.User.create_index([("phoneNumber", pymongo.ASCENDING)], unique=True)


db = MongoDB()
