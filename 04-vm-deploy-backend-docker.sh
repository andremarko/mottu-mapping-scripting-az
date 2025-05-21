#!/bin/bash
set -e
source ./config.sh

git clone git@github.com:andremarko/mottu-mapping-api-java.git

cd mottu-mapping-api-java

docker build --build-arg DB_USER=rm555285 --build-arg DB_PASSWORD=270102 -t ${projectName}-backend-image .

docker run -d --name "${projectName}-backend" -p 8080:8080 "${projectName}-backend-image"
