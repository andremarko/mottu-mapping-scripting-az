#criar usuário 
#outros detalhes descritos no trello
# vem com maven

# instalar GIT
FROM eclipse-temurin:21-jdk

ARG DATA_USER
ARG DATA_PASSWORD

#trocar
RUN adduser -h /home/mappingadmin -s /bin/bash -D mapping-backend 

#copiar projeto completo ou apenas target?
# cria diretório /app
WORKDIR /app

ENV DATA_USER=${DATA_USER}
ENV DATA_PASSWORD=${DATA_PASSWORD}

RUN echo "DATA_USER=${DATA_USER}" > /app/env.properties &&
    echo "DATA_USER=${DATA_PASSWORD}" >> /app/env.properties && \

# copia diretorio atual para /app (caminho relativo)
COPY . .
# copia do target para /app no conteiner

# expondo porta 8080
EXPOSE 8080

USER mapping-backend
                            #nome do aplicativo
                            #executa o .jar
CMD ["java", "-jar", "/app/my-app.jar"]

# --link, -l linkando containers
# bash -c ""