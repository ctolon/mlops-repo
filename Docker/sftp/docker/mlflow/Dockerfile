FROM python:3.7.8
RUN apt-get update

# BASIC PACKAGES
RUN python -m pip install --upgrade setuptools pip
RUN apt-get install git

ARG SERVER_DIR=/server


# python c deps
#RUN apk add --no-cache alpine-sdk postgresql-dev postgresql-client openssh openssl-dev 

# PERFORMANCE PROVIDERS (BEST PRACTICE)
#RUN apt-get install libyaml-cpp-dev libyaml-dev

# MLflow main package
RUN python -m pip install mlflow==1.29.0

# If python version >= 3.7
RUN python -m pip install protobuf==3.20.*

# Postgres Binary driver for dev
#RUN python -m pip install psycopg2-binary

# Postgres main driver for production
RUN python -m pip install psycopg2

RUN python -m pip install pysftp==0.2.8

# test
RUN pip install paramiko==2.8.1

# FOR JUST DEMO 
#RUN python -m pip install numpy pandas seaborn matplotlib nltk scikit-learn


COPY run_server.sh .
#RUN chmod +x ./run_server.sh


COPY ./scripts/wait-for-it.sh ${SERVER_DIR}/
RUN chmod +x ${SERVER_DIR}/wait-for-it.sh

WORKDIR ${SERVER_DIR}

# GLOBAL ARGS
ARG MLFLOW_ARTIFACT_DIR
ENV MLFLOW_ARTIFACT_URI=$MLFLOW_ARTIFACT_DIR

ARG MLFLOW_TRACKING_URI
ENV MLFLOW_TRACKING_URI=$MLFLOW_TRACKING_URI

ARG MLFLOW_TRACKING_INSECURE_TLS 
ENV MLFLOW_TRACKING_INSECURE_TLS=$MLFLOW_TRACKING_INSECURE_TLS

# TODO: Check wheather we really need
#RUN mkdir -p ${MLFLOW_ARTIFACT_URI}
RUN mkdir -p /artifacts
RUN chmod 777 -R /artifacts

EXPOSE 5000/tcp



EXPOSE $MLFLOW_TRACKING_SERVER_PORT
