from flask_socketio import emit, join_room, leave_room
from flask import request
import json

from app import socketio
from app.helpers.jwt import get_data

socket_clients = {}


@socketio.on("connect")
def handle_connect():
    print("connect")
    username, imageUrl = get_data(request.args.get("token"), True)
    if not username:
        return False
    socket_clients[username] = {"imageUrl": imageUrl}
    join_room(username)
    print(f"[NEW USER] {username}")
    emit("user_connected", socket_clients, broadcast=True)


@socketio.on("disconnect")
def handle_disconnect():
    username, _ = get_data(request.args.get("token"), False)
    if username in socket_clients:
        del socket_clients[username]
    leave_room(username)
    print(f"[USER DISCONNECTED] {username}")
    emit("user_disconnected", {"username": username}, broadcast=True, include_self=False)


@socketio.on("send_message")
def handle_msg(json_data):
    print(f"[MESSAGE] {json_data}")
    json_data = json.loads(json_data)
    username, _ = get_data(json_data["token"], True)
    if not username:
        return False
    data = {
        "sender": username,
        "receiver": json_data["receiver"],
        "message": json_data["message"],
    }
    if data["receiver"] == "GLOBAL":
        emit("receive_message", data, broadcast=True, include_self=False)
    else:
        emit("receive_message", data, room=data["receiver"])
