FROM tomcat:jdk8-corretto
WORKDIR webapps
COPY /tmp/target/SampleWebApplication.war .
RUN rm -rf ROOT && mv SampleWebApplication.war ROOT.war
ENTRYPOINT ["sh", "/usr/local/tomcat/bin/startup.sh"]