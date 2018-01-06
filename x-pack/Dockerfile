ARG BASE_IMAGE
FROM ${BASE_IMAGE}

ARG XPACK_EDITION
ENV XPACK_EDITION=${XPACK_EDITION}

COPY x-pack/rootfs /

RUN set -exo pipefail; \
  # Add X-Pack Reporting dependencies
  yum update -y && yum install -y fontconfig freetype && yum clean all; \
  # Install X-Pack and optimize bundle for X-Pack edition
  cp config/kibana.x-pack.${XPACK_EDITION}.yml config/kibana.yml; \
  kibana-plugin install x-pack; \
  rm -f config/kibana.yml
