FROM python:3.7-alpine

RUN apk add --update --no-cache \
  g++ gcc python3-dev musl-dev \
  postgresql-dev libxml2 libxml2-dev libxslt-dev

COPY requirements.txt /

RUN pip install --no-cache-dir -r /requirements.txt

COPY lmldbx/ /lmldbx

ENV FLASK_ENV="docker"
ENV FLASK_APP="/lmldbx/app.py"

WORKDIR /lmldbx

EXPOSE 5000


CMD ["flask", "run", "--host=0.0.0.0"]
