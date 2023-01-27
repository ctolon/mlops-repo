# Docker - Data Science Using Spark and MLFlow Tracking

### Tech Stacks

* [PostgreSQL](https://www.postgresql.org/)
* [MLflow](https://mlflow.org/docs/latest/index.html)
* SFTP Server

This repo is combines several reference repos
* Postgres is uniquely prepared.
* MLFlow from https://github.com/crmne/mlflow-tracking 
* Docker Pure ftpd server from https://github.com/stilliard/docker-pure-ftpd

### Overview

**Files**
  * [docker-compose.yml](docker-compose.yml) - Docker compose file
  * Dockerfile.* - per different container
  * All Environment variables defined in `.env`
  * `run.sh` bash-script for run ftpd server
  * [run_server.sh](conf/mlflow/run_server.sh) - MLflow manage run server script
  * [create_db.sql](conf/postgresql/init/create_db.sql) SQL query for create initial db (as postgres)
  * [requirements_list](requirements_list/.gitkeep) you can define all requirements for per docker file in this folder

**Persisting Data**

In order to save data between container runs, we use Docker's volume feature to persist data to the host disk in the directory 'container_data'.
 * container_data/postgresql - MySQL data from /var/lib/mysql
 * containder_data/artifacts...
 
### Build the containers

```
docker-compose -f docker-compose.yml build
```

```
docker-compose build --no-cache
```

### Launch the containers

```
docker-compose -f docker-compose.yml up -d
```

or

```
docker compose up
```

### Partially Compile per image

```
docker compose build <server_name> (ex. spark_hive)
```

### Project Structure

├── conf
│   ├── mlflow
│   │   └── run_server.sh
│   └── postgresql
│       └── init
│           └── create_db.sql
├── container_data
│   ├── mlflow
│   │   ├── artifacts
│   │   └── runs
│   └── postgresql
│       └── data
├── docker-compose.yml
├── Dockerfile.ftpd_server
├── Dockerfile.mlflow
├── Dockerfile.postgres
├── README.md
├── requirements_list
└── run.sh


### .env Config File Template

```bash
# ENV CONFIG FILE

# Postgres
POSTGRES_PASSWORD=mysecret
POSTGRESQL_VERSION=14.6
POSTGRESQL_CONNECTOR_VERSION=42.5.1
POSTGRES_HOST_AUTH_METHOD=md5

# MLFlow Tracking Server
MLFLOW_ARTIFACT_DIR=/mlartifacts
MLFLOW_TRACKING_URI=postgresql+psycopg2://postgres:mysecret@postgresql/mlflow
```

### Usernames and passwords

**Postgresql**: postgres - mysecret

**FTPD Server**: user - pass

SSHD CONFİG FİLE İN ETC/SSH/

# Secure defaults
# See: https://stribika.github.io/2015/01/04/secure-secure-shell.html
Protocol 2
HostKey /etc/ssh/ssh_host_ed25519_key
HostKey /etc/ssh/ssh_host_rsa_key
HostKey /etc/ssh/ssh_host_ecdsa_key

# Faster connection
# See: https://github.com/atmoz/sftp/issues/11
UseDNS no

# Limited access
PermitRootLogin yes
X11Forwarding yes
AllowTcpForwarding yes

# Force sftp and chroot jail
Subsystem sftp internal-sftp
ForceCommand internal-sftp
ChrootDirectory %h

# Enable this for more logs
LogLevel VERBOSE
PubkeyAcceptedAlgorithms=+ssh-rsa
HostKeyAlgorithms +ssh-rsa,ssh-dss 


Host * 
HostkeyAlgorithms +ssh-rsa 
PubkeyAcceptedKeyTypes +ssh-rsa




  mlflow:
    build:
      context: ./docker/mlflow
      dockerfile: Dockerfile
      args:
        - MLFLOW_ARTIFACT_DIR=$MLFLOW_ARTIFACT_DIR
        - MLFLOW_TRACKING_URI=$MLFLOW_TRACKING_URI
    container_name: mlflow-tracking_postgres
    image: mlflow-tracking:1.12.1
    restart: on-failure
    hostname: mlflow-tracking
    environment:
      MLFLOW_TRACKING_SERVER_HOST: ${MLFLOW_TRACKING_SERVER_HOST}
      MLFLOW_TRACKING_SERVER_PORT: ${MLFLOW_TRACKING_SERVER_PORT}
      MLFLOW_ARTIFACT_STORE: ${MLFLOW_ARTIFACT_STORE}
      MLFLOW_BACKEND_STORE: ${MLFLOW_BACKEND_STORE}
      POSTGRES_USER: ${POSTGRES_USER}
      POSTGRES_PASSWORD: ${POSTGRES_PASSWORD}
      POSTGRES_DATABASE: ${POSTGRES_DATABASE}
      POSTGRES_PORT: 3307:3306
      WAIT_FOR_IT_TIMEOUT: ${WAIT_FOR_IT_TIMEOUT}
      SFTP_USERNAME: ${SFTP_USERNAME}
      SFTP_PASSWORD: ${SFTP_PASSWORD}
      SFTP_HOST: ${SFTP_HOST}
    depends_on:
      - postgresql
      - sftp
    links:
      - "postgresql:postgresql"
      - "sftp:sftp"
    ports:
      - "5000:5000"
    volumes:
      - ./${MLFLOW_ARTIFACT_STORE}:/${MLFLOW_ARTIFACT_STORE}
      - ./keys/ssh_host_rsa_key:/root/.ssh/ssh_host_rsa_key:ro
      - ./keys/ssh_host_ed25519_key:/root/.ssh/ssh_host_ed25519_key:ro
      - ./keys/config:/root/.ssh/config:ro
    command: >
      /bin/bash -c "sleep 3
      && cd /root/.ssh
      && ssh-keyscan ${SFTP_HOST} >> known_hosts
      && cd /server
      && mlflow server
      --backend-store-uri postgresql://postgres2:${POSTGRES_PASSWORD}@${MLFLOW_BACKEND_STORE}:${POSTGRES_PORT}/${POSTGRES_DATABASE}
      --default-artifact-root sftp://${SFTP_USERNAME}:${SFTP_PASSWORD}@${SFTP_HOST}/${MLFLOW_ARTIFACT_STORE}
      --host ${MLFLOW_TRACKING_SERVER_HOST}
      --port ${MLFLOW_TRACKING_SERVER_PORT}"

docker exec -it sftp bin/bash










# Secure defaults
# See: https://stribika.github.io/2015/01/04/secure-secure-shell.html
Protocol 2
HostKey /etc/ssh/ssh_host_ed25519_key
HostKey /etc/ssh/ssh_host_rsa_key
HostKey /etc/ssh/ssh_host_ecdsa_key

# Faster connection
# See: https://github.com/atmoz/sftp/issues/11
UseDNS no

# Limited access
PermitRootLogin yes
X11Forwarding yes
AllowTcpForwarding yes

# Force sftp and chroot jail
Subsystem sftp internal-sftp
ForceCommand internal-sftp
ChrootDirectory %h

# Enable this for more logs
LogLevel VERBOSE
PubkeyAcceptedAlgorithms +ssh-rsa
HostkeyAlgorithms +ssh-rsa

PubkeyAuthentication yes
bash-5.1# cat
^C
bash-5.1# ^C
bash-5.1# ls
ssh_host_ecdsa_key        ssh_host_ed25519_key      ssh_host_rsa_key          sshd_config
ssh_host_ecdsa_key.pub    ssh_host_ed25519_key.pub  ssh_host_rsa_key.pub
bash-5.1# cat sshd_config
# Secure defaults
# See: https://stribika.github.io/2015/01/04/secure-secure-shell.html
Protocol 2
HostKey /etc/ssh/ssh_host_ed25519_key
HostKey /etc/ssh/ssh_host_rsa_key
HostKey /etc/ssh/ssh_host_ecdsa_key

# Faster connection
# See: https://github.com/atmoz/sftp/issues/11
UseDNS no

# Limited access
PermitRootLogin yes
X11Forwarding yes
AllowTcpForwarding yes

# Force sftp and chroot jail
Subsystem sftp internal-sftp
ForceCommand internal-sftp
ChrootDirectory %h

# Enable this for more logs
LogLevel VERBOSE
PubkeyAcceptedAlgorithms +ssh-rsa
HostkeyAlgorithms +ssh-rsa

PubkeyAuthentication yes





















# Secure defaults
# See: https://stribika.github.io/2015/01/04/secure-secure-shell.html
Protocol 2
HostKey /etc/ssh/ssh_host_ed25519_key
HostKey /etc/ssh/ssh_host_rsa_key
HostKey /etc/ssh/ssh_host_ecdsa_key

# Faster connection
# See: https://github.com/atmoz/sftp/issues/11
UseDNS no

# Limited access
PermitRootLogin yes
X11Forwarding yes
AllowTcpForwarding yes

# Force sftp and chroot jail
Subsystem sftp internal-sftp
ForceCommand internal-sftp
ChrootDirectory %h

# Enable this for more logs
PubkeyAcceptedAlgorithms=+ssh-rsa
HostkeyAlgorithms +ssh-rsa
PubkeyAcceptedKeyTypes +ssh-rsa

PubkeyAuthentication yes
SyslogFacility LOCAL0
LogLevel DEBUG3


StrictModes no












FROM python:3.7.8
RUN apt-get update

ARG MLFLOW_VERSION
ARG SERVER_DIR=/server

# BASIC PACKAGES
RUN python -m pip install --upgrade setuptools pip
RUN apt-get install git

# python c deps
#RUN apk add --no-cache alpine-sdk postgresql-dev postgresql-client openssh openssl-dev 

# PERFORMANCE PROVIDERS (BEST PRACTICE)
#RUN apt-get install libyaml-cpp-dev libyaml-dev

# MLflow main package
RUN python -m pip install mlflow==1.29.0

RUN mkdir -p ${SERVER_DIR}

# If python version >= 3.7
RUN python -m pip install protobuf==3.20.*

# Postgres Binary driver for dev
#RUN python -m pip install psycopg2-binary

# Postgres main driver for production
RUN python -m pip install psycopg2

# A simple interface to SFTP with python support
RUN python -m pip install pysftp

COPY ./scripts/wait-for-it.sh ${SERVER_DIR}/
RUN chmod +x ${SERVER_DIR}/wait-for-it.sh

WORKDIR ${SERVER_DIR}

ARG MLFLOW_TRACKING_INSECURE_TLS 
ENV MLFLOW_TRACKING_INSECURE_TLS=$MLFLOW_TRACKING_INSECURE_TLS

EXPOSE $MLFLOW_TRACKING_SERVER_PORT



TODO: Config dosyasını fixle keys altındaki




    command: >
      /bin/bash -c "sleep 3
      && cd /root/.ssh
      && ssh-keyscan ${SFTP_HOST} >> known_hosts"




