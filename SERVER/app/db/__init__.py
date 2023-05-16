from pymongo import mongo_client, collection
import pymongo
from app.config import settings


class MongoDB():
	User: collection.Collection = None

	def setup(self):
		self.client = mongo_client.MongoClient(settings.DATABASE_URL, serverSelectionTimeoutMS=5000)
	
		try:
			conn = self.client.server_info()
			print(f'Connected to MongoDB {conn.get("version")}')
		except Exception:
			print("Unable to connect to the MongoDB server.")
	
		db = self.client[settings.MONGO_INITDB_DATABASE]
		self.User = db.users
	
		self.User.create_index([('email', pymongo.ASCENDING), ('username', pymongo.ASCENDING)], unique=True)
		self.User.create_index([('username', pymongo.ASCENDING)], unique=True)

db = MongoDB()