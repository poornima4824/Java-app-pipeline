#FROM tomcat:latest

#ADD ./target/LoginWebApp-1.war /usr/local/tomcat/webapps/

FROM tomcat:latest
COPY target/*.war /usr/local/tomcat/webapps/LoginApp-1.war/
CMD ["catalina.sh", "run"]