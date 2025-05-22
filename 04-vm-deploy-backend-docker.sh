#!/bin/bash
set -e

git clone git@github.com:andremarko/mottu-mapping-api-java.git

cd mottu-mapping-api-java

docker build -t mottu-mapping-backend-image .

docker run -d --name mottu-mapping-backend -p 8080:8080 \
  -e DB_USER=rm555285 \
  -e DB_PASSWORD=270102 \
  mottu-mapping-backend-image