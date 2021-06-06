FROM tomcat:jdk8-corretto
ADD target/SampleWebApplication.war /usr/local/tomcat/webapps/
RUN rm -rf ROOT && mv SampleWebApplication.war ROOT.war
EXPOSE 8080
CMD [“catalina.sh”, “run”]