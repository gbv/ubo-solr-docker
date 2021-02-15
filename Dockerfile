# Bind paths /var/solr/data
FROM alpine/git as git
ARG UBO_BRANCH=master
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
USER $SOLR_USER
ENV INIT_SOLR_HOME "yes"
ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["solr-foreground"]
