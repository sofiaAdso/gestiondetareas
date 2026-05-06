# ===== Etapa 1: Build con Maven (Java 17) =====
FROM maven:3.9.8-eclipse-temurin-17 AS build
WORKDIR /app

# Cachear dependencias
COPY pom.xml .
RUN mvn -B -q dependency:go-offline || true

# Copiar fuentes y empaquetar
COPY src ./src
RUN mvn -B -q clean package -DskipTests

# ===== Etapa 2: Runtime Tomcat 9 + Java 17 =====
FROM tomcat:9.0.115-jdk17-temurin

ENV CATALINA_HOME=/usr/local/tomcat
ENV CATALINA_OPTS="-Dfile.encoding=UTF-8"

# Desplegar como ROOT (raíz del dominio)
RUN rm -rf /usr/local/tomcat/webapps/*
COPY --from=build /app/target/SistemaGestionTareas.war /usr/local/tomcat/webapps/ROOT.war

# Railway inyecta $PORT en runtime; localmente usamos 8080 por defecto
ENV PORT=8080
EXPOSE 8080

# Sustituir el puerto del Connector HTTP de Tomcat por $PORT al iniciar
CMD ["sh", "-c", "sed -i \"s/port=\\\"8080\\\"/port=\\\"${PORT}\\\"/\" ${CATALINA_HOME}/conf/server.xml && exec catalina.sh run"]