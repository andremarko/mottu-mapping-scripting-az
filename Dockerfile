#criar usuário 
#outros detalhes descritos no trello

FROM eclipse-temurin:21-jdk

RUN adduser -h /home/menk -s /bin/bash -D mappingadmin

# cria diretório /app
WORKDIR /app

# copia diretorio atual para /app (caminho relativo)
COPY . .

# expondo porta 8080
EXPOSE 8080
                            #nome do aplicativo
CMD ["java", "-jar", "/app/my-app.jar"]
