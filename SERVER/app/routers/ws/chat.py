import json
import logging
import socketio

from app.config import settings
from app.helpers import jwt_helper

sio_server = socketio.AsyncServer(
    async_mode="asgi", cors_allowed_origins=[], logger=settings.DEBUG_MODE
)

sio_app = socketio.ASGIApp(socketio_server=sio_server)

socket_clients = set() # Sicuramente non scalabile, ma temporaneo


@sio_server.event
async def connect(sid, _, auth):
    token = auth["x-access-token"] if "x-access-token" in auth else None

    username, user_id = data_from_token(token)
    socket_clients.add(username)

    # Store token data in session
    await sio_server.save_session(sid, {"username": username, "id": user_id})

    # Private room
    sio_server.enter_room(sid, room=username)
    logging.info("WEBSOCKET: [NEW USER] %s", username)

    await sio_server.emit("user_connected", data=list(socket_clients))


@sio_server.on("disconnect")
async def disconnect(sid):
    username = (await sio_server.get_session(sid))["username"]

    socket_clients.discard(username)

    sio_server.leave_room(sid, room=username)
    logging.info("WEBSOCKET: [USER DISCONNECTED] %s", username)

    await sio_server.emit(
        "user_disconnected", data={"username": username}, skip_sid=True
    )


@sio_server.on("send_message")
async def handle_msg(sid, input_data):
    logging.info("WEBSOCKET: [MESSAGE] %s", input_data)
    username = (await sio_server.get_session(sid))["username"]

    body = json.loads(input_data)

    data = {
        "sender": username,
        "receiver": body["receiver"],
        "message": body["message"],
    }

    if data["receiver"] == "GLOBAL":
        await sio_server.emit("receive_message", data=data, skip_sid=True)
    else:
        await sio_server.emit("receive_message", data=data, room=data["receiver"])


def data_from_token(token) -> tuple[str, str]:
    if not token:
        raise ConnectionRefusedError("No token provided")

    data = jwt_helper.get_current_user(x_access_token=token)

    return data["username"], data["id"]
