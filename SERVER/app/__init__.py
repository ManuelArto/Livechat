from dotenv import load_dotenv
from pathlib import Path
from flask import Flask
from flask_socketio import SocketIO
from flask_cors import CORS

env_path = Path('.') / '.env'
load_dotenv(dotenv_path=env_path)

app = Flask(__name__)
app.config.from_pyfile("config.py")

socketio = SocketIO(app, cors_allowed_origins="*")

from .models import init_app
init_app(app)

from .endpoint import api
from .endpoint import websocket

CORS(app)

if __name__ == "__main__":
    socketio.run(app, host="0.0.0.0", log_output=True)
