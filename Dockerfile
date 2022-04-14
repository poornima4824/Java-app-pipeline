#FROM tomcat:latest

#ADD ./target/LoginWebApp-1.war /usr/local/tomcat/webapps/

FROM tomcat:latest
COPY target/LoginApp-1.war /usr/local/tomcat/webapps/
CMD ["catalina.sh", "run"]