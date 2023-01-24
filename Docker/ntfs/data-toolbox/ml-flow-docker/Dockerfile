FROM python:3.9.15

RUN pip install mlflow==2.0.1 psycopg2==2.9.5

EXPOSE 5000

RUN mkdir -p /server
WORKDIR /server
COPY . /server

RUN chmod +x wait-for-it.sh

RUN mkdir /mlflow/

RUN chmod -R 777 /mlflow/

#RUN chmod -R 777 ${WORKDIR}

CMD ./wait-for-it.sh postgres:5432 -- mlflow server \
    --backend-store-uri postgresql://admin:secret@postgres:5432/mlflow \
    --default-artifact-root /mlflow \
    --host 0.0.0.0