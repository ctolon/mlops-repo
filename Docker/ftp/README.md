# Docker -> MLflow + Postgres + Pure FTPD Server

### Tech Stacks

* [PostgreSQL](https://www.postgresql.org/)
* [MLflow](https://mlflow.org/docs/latest/index.html)
* FTP Server

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
 * home/ftp-user/mlartifacts - model tracking
 * home/ftp-user/mlruns - meta.yaml files (currently not working due to ftp issues)
 * home/ftp-pass/pureftpd.passwd - passwords for ftp server
 
### Build the containers
```
docker-compose -f docker-compose.yml build
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

Note: postgres is root user.

**FTPD Server**: user - pass