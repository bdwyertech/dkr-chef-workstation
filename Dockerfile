FROM chef/chefworkstation:stable
FROM golang:1.20-alpine as helper
WORKDIR /go/src/
COPY fix-permissions/ .
# GOFLAGS=-mod=vendor
RUN CGO_ENABLED=0 go build -ldflags="-s -w" .

FROM chef/chefworkstation:stable

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
      org.label-schema.vcs-url="https://github.com/broadridge/dkr-chef-workstation.git" \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.build-date=$BUILD_DATE \
      org.tooling.user=chef \
      org.tooling.uid=1000 \
      org.tooling.gid=1000

COPY --from=helper /go/src/fix-permissions /usr/local/bin/

# Add support for aws_ssh_key_type (https://github.com/test-kitchen/kitchen-ec2/pull/583)
# COPY kitchen-ec2.patch /tmp/kitchen-ec2.patch
# RUN patch -i /tmp/kitchen-ec2.patch $(ls /opt/chef-workstation/embedded/lib/ruby/gems/*/gems/kitchen-ec2-*/lib/kitchen/driver/ec2.rb) \
#     && rm /tmp/kitchen-ec2.patch

RUN CHEF_LICENSE=accept-no-persist chef gem install kitchen-ansible --no-user-install --no-document
RUN useradd chef --uid 1000 -m -d /home/chef --shell /bin/bash \
    && mkdir /chef \
    && chown chef:chef /chef \
    && chmod 4755 /usr/local/bin/fix-permissions

# YQ
ARG TARGETPLATFORM=linux/amd64
RUN DOCKER_ARCH=$(case ${TARGETPLATFORM} in \
    "linux/amd64")   echo "amd64" ;; \
    "linux/arm64")   echo "arm64" ;; \
    *)               echo "" ;; esac) \
    && (curl -sfL "$(curl -Ls https://api.github.com/repos/mikefarah/yq/releases/latest | grep -o -E "https://.+?_linux_${DOCKER_ARCH}.tar.gz")" | tar zxf - --directory /usr/local/bin)

COPY --chown=chef:chef rubocop.yml /home/chef/.rubocop.yml

COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh

# Ansible
ARG ANSIBLE
RUN if [ "$ANSIBLE" = "true" ] ; then \
    sed -i 's|http://.*.ubuntu.com|https://mirror.us.leaseweb.net|g' /etc/apt/sources.list \
    && apt-get update && apt-get install -y ansible ncdu \
    && apt-get autoremove -y \
    && apt-get autoclean -y \
    && rm -rf /var/lib/apt/lists/* \
    && CHEF_LICENSE=accept-no-persist chef gem install kitchen-ansible kitchen-ansiblepush --no-user-install --no-document; \
    fi

USER chef
WORKDIR /chef
ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["kitchen"]
