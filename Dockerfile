FROM tomcat:7.0.85-jre8
ARG version
RUN wget http://192.168.0.10:8081/nexus/service/local/repositories/snapshots/content/task7/$version/gradleSample.war -P /usr/local/tomcat/webapps/
EXPOSE 8080
