FROM chef/chefworkstation:21.1.222

ARG BUILD_DATE
ARG VCS_REF

LABEL org.opencontainers.image.title="bfscloud/chef-workstation" \
      org.opencontainers.image.description="Infrastructure as code development & testing via Chef Workstation" \
      org.opencontainers.image.authors="Brian Dwyer <bfscloud@broadridge.com>" \
      org.opencontainers.image.url="https://hub.docker.com/r/bfscloud/chef-workstation" \
      org.opencontainers.image.source="https://github.com/broadridge/dkr-chef-workstation.git" \
      org.opencontainers.image.revision=$VCS_REF \
      org.opencontainers.image.created=$BUILD_DATE \
      org.label-schema.name="bfscloud/chef-workstation" \
      org.label-schema.description="Infrastructure as code development & testing via Chef Workstation" \
      org.label-schema.url="https://hub.docker.com/r/bfscloud/chef-workstation" \
      org.label-schema.vcs-url="https://github.com/broadridge/dkr-chef-workstation.git"\
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.build-date=$BUILD_DATE

RUN useradd chef -r -m -d /home/chef \
    && mkdir /chef \
    && chown chef:chef /chef

COPY --chown=chef:chef rubocop.yml /home/chef/.rubocop.yml

COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh

USER chef
WORKDIR /chef
ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["kitchen"]
