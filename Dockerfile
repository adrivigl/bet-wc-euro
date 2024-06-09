# syntax = docker/dockerfile:1.2
#
# Build stage
#
FROM maven:3.6.0-jdk-11-slim AS build
COPY src /home/bet-wc-euro/src
COPY pom.xml /home/bet-wc-euro
RUN mvn -DskipTests -f /home/bet-wc-euro/pom.xml clean package

#
# Package stage
#
FROM openjdk:8-jre-slim
RUN --mount=type=secret,id=application-pro.properties,dst=/src/main/resources/application-pro.properties
COPY --from=build /home/bet-wc-euro/target/bet-wc-euro-1.0.0.jar /usr/local/lib/bet-wc-euro.jar
EXPOSE 8080
ENTRYPOINT ["java","-Dspring.profiles.active=pro", "-jar","/usr/local/lib/bet-wc-euro.jar"]