from dotenv import load_dotenv
from pathlib import Path

env_path = Path('.') / '.env'
load_dotenv(dotenv_path=env_path)

from app import app, socketio

if __name__ == '__main__':
	socketio.run(app, host="0.0.0.0")