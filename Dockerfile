FROM tomcat:8.0-alpine
ARG version
COPY ./*.war /usr/local/tomcat/webapps/gradleSample.war
