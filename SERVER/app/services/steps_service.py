from datetime import datetime, date
from bson import ObjectId

from app.db import db
from app.schemas import UserDocument


class StepsService:
    @staticmethod
    def update_steps(user_id: ObjectId, steps: int) -> UserDocument:
        """
        Update the number of steps for a user for the current day.

        Parameters:
            user_id (ObjectId): The ID of the user.
            steps (int): The number of steps to update.
        """
        current_date = datetime.combine(date.today(), datetime.min.time())
        db.STEPS_USERS.update_one(
        filter={"userId": user_id, "day": current_date},
            update={"$set": {"steps": steps}},
            upsert=True,
        )

        user = db.USER.find_one(filter={"_id": user_id})

        return UserDocument(id=str(user["_id"]), steps=steps, **user)

    @staticmethod
    def retrieve_steps(user_id: ObjectId) -> int:
        """
        Retrieves the number of steps for a given user.

        Parameters:
            user_id (ObjectId): The ID of the user.

        Returns:
            int: The number of steps for the user. Returns 0 if no steps are found.
        """
        current_date = datetime.combine(date.today(), datetime.min.time())
        user_steps = db.STEPS_USERS.find_one(
            filter={
                "userId": user_id,
                "day": current_date,
            }
        )

        if user_steps is None:
            return 0

        return user_steps.get("steps", 0)

    @staticmethod
    def retrieve_users_steps(ids: list) -> dict:
        """
        Retrieve the number of steps for a list of users for the current day
        """
        current_date = datetime.combine(date.today(), datetime.min.time())
        data = db.STEPS_USERS.find(
            filter={
                "userId": {"$in": ids},
                "day": current_date,
            },
            projection={"userId": 1, "steps": 1}
        )

        data_dict = {steps["userId"]: steps["steps"] for steps in data}
        return {id: data_dict.get(id, 0) for id in ids}
