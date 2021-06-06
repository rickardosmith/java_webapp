FROM tomcat
ADD target/SampleWebApplication.war /usr/local/tomcat/webapps/ROOT.war
EXPOSE 8080
CMD ["catalina.sh", "run"]
