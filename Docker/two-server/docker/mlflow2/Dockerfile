FROM python:3.8.5
RUN apt-get update

# BASIC PACKAGES
RUN python -m pip install --upgrade setuptools pip
RUN apt-get install git

# python c deps
#RUN apk add --no-cache alpine-sdk postgresql-dev postgresql-client openssh openssl-dev 

# PERFORMANCE PROVIDERS (BEST PRACTICE)
#RUN apt-get install libyaml-cpp-dev libyaml-dev

# MLflow main package
#RUN python -m pip install mlflow==1.29.0
RUN python -m pip install mlflow==2.1.1

# If python version >= 3.7
RUN python -m pip install protobuf==3.20.*

# Postgres Binary driver for dev
#RUN python -m pip install psycopg2-binary

# Postgres main driver for production
RUN python -m pip install psycopg2

# FOR JUST DEMO 
#RUN python -m pip install numpy pandas seaborn matplotlib nltk scikit-learn

#RUN mkdir -p /home/mlflow
COPY run_server.sh .
#/home/mlflow
RUN chmod +x ./run_server.sh
#WORKDIR /home/mlflow

# GLOBAL ARGS
#ARG MLFLOW_ARTIFACT_DIR
#ENV MLFLOW_ARTIFACT_URI=$MLFLOW_ARTIFACT_DIR

ARG MLFLOW_TRACKING_URI
ENV MLFLOW_TRACKING_URI=$MLFLOW_TRACKING_URI

ARG MLFLOW_TRACKING_INSECURE_TLS 
ENV MLFLOW_TRACKING_INSECURE_TLS=$MLFLOW_TRACKING_INSECURE_TLS

# TODO: Check wheather we really need
#RUN mkdir -p ${MLFLOW_ARTIFACT_URI}
RUN mkdir -p /mnt/mlruns/
RUN chmod 777 -R /mnt/mlruns/

EXPOSE 8001/tcp

#ENTRYPOINT ["mlflow", "server", "--host", "0.0.0.0", \
#    "--port", "8001", "--backend-store-uri", \
#    "postgresql+psycopg2://postgres:mysecret@postgresql/mlflow", \
#    "--artifacts-destination", "sftp://mlflowuser:secret@0.0.0.0/home/mlflowuser/artifacts", \
#    "--serve-artifacts", "--artifacts-only"]