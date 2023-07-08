FROM python:latest

WORKDIR /opt

COPY ./requirements.txt /opt/requirements.txt

RUN pip install --no-cache-dir --upgrade -r /opt/requirements.txt

COPY ./app /opt/app

ARG ENV_FILE=.env
COPY ${ENV_FILE} /opt/.env

CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "80", "--use-colors"]