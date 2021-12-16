# Bind paths /var/solr/data
FROM alpine/git as git
ARG UBO_BRANCH=main
RUN mkdir /opt/ubo
WORKDIR /opt/
RUN git --version && \
    git clone https://github.com/MyCoRe-Org/ubo.git
WORKDIR /opt/ubo
RUN git checkout ${UBO_BRANCH}
FROM solr:7
EXPOSE 8983
USER solr
COPY --from=git --chown=solr:solr /opt/ubo/ubo-webapp/src/main/setup/solr/ /opt/solr/server/solr/
WORKDIR /opt/solr
# patch solr manually to mitigate CVE-2021-44228
ADD https://repo1.maven.org/maven2/org/apache/logging/log4j/log4j-core/2.16.0/log4j-core-2.16.0.jar /opt/solr/server/lib/ext/log4j-core-2.16.0.jar
ADD https://repo1.maven.org/maven2/org/apache/logging/log4j/log4j-slf4j-impl/2.16.0/log4j-slf4j-impl-2.16.0.jar /opt/solr/server/lib/ext/log4j-slf4j-impl-2.16.0.jar
ADD https://repo1.maven.org/maven2/org/apache/logging/log4j/log4j-api/2.16.0/log4j-api-2.16.0.jar /opt/solr/server/lib/ext/log4j-api-2.16.0.jar
ADD https://repo1.maven.org/maven2/org/apache/logging/log4j/log4j-1.2-api/2.16.0/log4j-1.2-api-2.16.0.jar /opt/solr/server/lib/ext/log4j-1.2-api-2.16.0.jar
RUN rm /opt/solr/server/lib/ext/log4j-core-2.11.0.jar &&\
    rm /opt/solr/server/lib/ext/log4j-api-2.11.0.jar &&\
    rm /opt/solr/server/lib/ext/log4j-slf4j-impl-2.11.0.jar &&\
    rm /opt/solr/server/lib/ext/log4j-1.2-api-2.11.0.jar
USER root
RUN chown $SOLR_USER -R /opt/solr/server/lib/ext/*
USER $SOLR_USER
ENV INIT_SOLR_HOME "yes"
ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["solr-foreground"]
