FROM eclipse-temurin:21-jdk

# cria diretório /app
WORKDIR /app

# copia jar para /app (caminho relativo)
COPY . .

# expondo porta 8080
EXPOSE 8080

CMD ["java", "-jar", "/app/my-app.jar"]
