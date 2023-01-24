run() {
  STORE_URI=postgresql+psycopg2://postgres:${POSTGRES_PASSWORD}@postgresql/mlflow
  echo "STORE_URI=$STORE_URI"
  echo "MLFLOW_ARTIFACT_URI=$MLFLOW_ARTIFACT_URI"
  mlflow server --host 0.0.0.0 --port 5000 --backend-store-uri $STORE_URI --default-artifact-root ftp://user:pass@0.0.0.0/mlartifacts
}

run $* 2>&1 | tee server.log

