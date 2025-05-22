FROM maven:3.9.6-eclipse-temurin-21 AS build

WORKDIR /build

ARG DB_USER
ARG DB_PASSWORD

COPY pom.xml .
COPY src ./src

RUN echo "DB_USER=${DB_USER}" >> src/env.properties && \
    echo "DB_PASSWORD=${DB_PASSWORD}" >> src/env.properties

RUN mvn clean package -DskipTests

FROM eclipse-temurin:21-jdk

RUN useradd -m -s /bin/bash mapping-backend

WORKDIR /app

COPY --from=build /build/target/mottu-mapping-api-0.0.1-SNAPSHOT.jar /app/mottu-mapping-api-0.0.1-SNAPSHOT.jar
COPY --from=build /build/src/env.properties /app/env.properties

RUN chown -R mapping-backend:mapping-backend /app

USER mapping-backend

EXPOSE 8080

CMD ["java", "-jar", "/app/mottu-mapping-api-0.0.1-SNAPSHOT.jar"]
