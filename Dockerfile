FROM tomcat:7.0.85-jre8
ARG version
COPY ./*.war /usr/local/tomcat/webapps/gradleSample.war
