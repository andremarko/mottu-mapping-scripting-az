#!/bin/bash
set -e

git clone git@github.com:andremarko/mottu-mapping-api-java.git

cd mottu-mapping-api-java

docker build --build-arg DB_USER=rm555285 --build-arg DB_PASSWORD=270102 -t mottu-mapping-backend-image .

docker run -d --name mottu-mapping-backend -p 8080:8080 mottu-mapping-backend-image
