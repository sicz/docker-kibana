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
  # Use larger heap size during plugin installation to circumvent
  # https://github.com/elastic/kibana/issues/15683
  NODE_OPTIONS="--max-old-space-size=4096" kibana-plugin install x-pack; \
  # Remove temporary files
  rm -f config/kibana.yml
