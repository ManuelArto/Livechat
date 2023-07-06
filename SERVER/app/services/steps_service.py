from datetime import datetime, date, timedelta
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
        db.USERS_STEPS.update_one(
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
        user_steps = db.USERS_STEPS.find_one(
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
        data = db.USERS_STEPS.find(
            filter={
                "userId": {"$in": ids},
                "day": current_date,
            },
            projection={"userId": 1, "steps": 1},
        )

        data_dict = {steps["userId"]: steps["steps"] for steps in data}
        return {id: data_dict.get(id, 0) for id in ids}

    @staticmethod
    def retrieve_weekly_users_steps(ids: list) -> dict:
        """
        Retrieve the number of steps for a list of users for the current week
        """
        current_date = datetime.combine(date.today(), datetime.min.time())
        last_week = current_date - timedelta(days=6)

        # group by userId and sum all steps
        data = db.USERS_STEPS.aggregate(
            [
                {
                    "$match": {
                        "userId": {"$in": ids},
                        "day": {"$gte": last_week, "$lte": current_date},
                    }
                },
                {
                    "$group": {
                        "_id": "$userId",
                        "steps": {"$sum": "$steps"},
                    },
                },
            ]
        )

        data_dict = {steps["_id"]: steps["steps"] for steps in data}
        return {id: data_dict.get(id, 0) for id in ids}

    @staticmethod
    def get_user_weekly_charts(user_id: ObjectId):
        current_date = datetime.combine(date.today(), datetime.min.time())
        last_week = current_date - timedelta(days=6)
        data = db.USERS_STEPS.find(
            filter={
                "userId": user_id,
                "day": {"$gte": last_week, "$lte": current_date},
            },
            projection={"day": 1, "steps": 1},
        )

        step_days = {steps["day"].day: steps["steps"] for steps in data}

        weekly_charts = []
        for i in range(7):
            day = (current_date - timedelta(days=i)).day
            steps = step_days.get(day, 0)
            weekly_charts.append({"day": day, "steps": steps})

        return weekly_charts
