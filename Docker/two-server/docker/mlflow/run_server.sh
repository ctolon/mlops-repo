run() {
  STORE_URI=postgresql+psycopg2://postgres:${POSTGRES_PASSWORD}@postgresql/mlflow?sslmode=disable
  echo "STORE_URI=$STORE_URI"
  echo "MLFLOW_ARTIFACT_URI=$MLFLOW_ARTIFACT_URI"
  mlflow server --host 0.0.0.0 --port 5000 --backend-store-uri $STORE_URI --default-artifact-root ftp://kral:123@127.0.0.1/mlartifacts --no-serve-artifacts
}

run $* 2>&1 | tee server.log