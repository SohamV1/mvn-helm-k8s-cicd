FROM maven as build
WORKDIR /app
COPY . .
RUN mvn clean install

FROM openjdk:11.0
WORKDIR /app
COPY --from=build /app/target/devops-integration.jar .
EXPOSE 8080
CMD [ "java","-jar","devops-integration.jar" ]