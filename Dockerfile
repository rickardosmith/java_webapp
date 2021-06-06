FROM tomcat:jdk8-corretto
WORKDIR webapps
COPY ./target/SampleWebApplication.war .
RUN rm -rf ROOT && mv SampleWebApplication.war ROOT.war
ENTRYPOINT ["bash", "/usr/local/tomcat/bin/startup.sh"]