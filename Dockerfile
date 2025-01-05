FROM openjdk:11-slim AS BUILD_IMAGE
RUN apt update && apt install maven -y
WORKDIR /app
COPY pom.xml .
RUN mvn dependency:go-offline
COPY ./ .
RUN mvn install

FROM tomcat:9-jre11-slim
LABEL "Project"="profileapp"
LABEL "Author"="GodblessBiekro"
RUN rm -rf /usr/local/tomcat/webapps/*
COPY --from=BUILD_IMAGE /app/target/vprofile-v2.war /usr/local/tomcat/webapps/ROOT.war
EXPOSE 8080
CMD ["catalina.sh", "run"]