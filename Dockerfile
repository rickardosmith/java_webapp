FROM tomcat:jdk8-corretto
WORKDIR webapps
COPY target/SampleWebApplication.war .
RUN rm -rf ROOT && mv SampleWebApplication.war ROOT.war
EXPOSE 8080
CMD [“catalina.sh”, “run”]