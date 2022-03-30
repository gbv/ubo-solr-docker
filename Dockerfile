# Bind paths /var/solr/data
FROM bitnami/git:latest as git
ARG UBO_BRANCH=main
RUN mkdir /opt/ubo
WORKDIR /opt/
RUN git --version && \
    git clone https://github.com/MyCoRe-Org/ubo.git
WORKDIR /opt/ubo
RUN git checkout ${UBO_BRANCH}
FROM solr:8.11
USER root
COPY --from=git --chown=solr:solr /opt/ubo/ubo-webapp/src/main/setup/solr/configsets/ubo_main /opt/solr/server/solr/configsets/ubo_main
COPY --from=git --chown=solr:solr /opt/ubo/ubo-webapp/src/main/setup/solr/configsets/ubo_classification /opt/solr/server/solr/configsets/ubo_classification
COPY --chown=solr:solr docker-entrypoint.sh ./
RUN sed -ri 's/ class="solr.[Fast]*LRUCache"//' /opt/solr/server/solr/configsets/ubo_main/conf/solrconfig.xml && \
    sed -ri 's/ class="solr.[Fast]*LRUCache"//' /opt/solr/server/solr/configsets/ubo_classification/conf/solrconfig.xml && \
    chmod +x docker-entrypoint.sh
CMD ["bash", "docker-entrypoint.sh"]

