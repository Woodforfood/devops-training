FROM tomcat:8.0-alpine
ARG version
COPY /var/lib/jenkins/workspace/new/build/libs/gradleSample.war /usr/local/tomcat/webapps/gradleSample.war
