run() {
  STORE_URI=postgresql+psycopg2://admin:${POSTGRES_PASSWORD}@postgresql/mlflow
  echo "STORE_URI=$STORE_URI"
  echo "MLFLOW_ARTIFACT_URI=$MLFLOW_ARTIFACT_URI"
  mlflow server --host 0.0.0.0 --port 5000 --backend-store-uri $STORE_URI --default-artifact-root sftp://mlflowuser:secret@0.0.0.0/home/mlflowuser/artifacts
}

run $* 2>&1 | tee server.log
echo "hi"