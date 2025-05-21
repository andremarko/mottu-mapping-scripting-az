#!/bin/bash
set -e

APP_DIR="/home/mappingadmin/app"
REPO_URL="https://github.com/andremarko/mottu-mapping-api-java.git"
PROJECT_NAME="mottu-mapping"

mkdir -p "$APP_DIR"
cd "$APP_DIR"

git clone "$REPO_URL"

cd mottu-mapping-api-java

mv $HOME/env.properties $HOME/app/mottu-mapping-api-java/

mvn clean package

mv "$APP_DIR/Dockerfile" ./target/
cd target

docker build -t "${PROJECT_NAME}-backend-image" .

if docker images -q "${PROJECT_NAME}-backend-image"; then
    echo "IMAGE CREATED"
else
    echo "IMAGE DOES NOT EXIST"
    exit 1
fi

# mostrar operação executada no banco
docker run -d --name "${PROJECT_NAME}-backend" -p 8080:80 "${PROJECT_NAME}-backend-image"
