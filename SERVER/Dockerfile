FROM python:latest

WORKDIR /opt

COPY ./requirements.txt /opt/requirements.txt

RUN pip install --no-cache-dir --upgrade -r /opt/requirements.txt

COPY ./app /opt/app
COPY .env /opt/

CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "80", "--use-colors", "--log-level=debug"]