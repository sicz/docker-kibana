ARG BASE_IMAGE
FROM ${BASE_IMAGE}

ARG DOCKER_IMAGE_NAME
ARG DOCKER_IMAGE_TAG
ARG DOCKER_PROJECT_DESC
ARG DOCKER_PROJECT_URL
ARG BUILD_DATE
ARG GITHUB_URL
ARG VCS_REF

LABEL \
  org.label-schema.schema-version="1.0" \
  org.label-schema.name="${DOCKER_IMAGE_NAME}" \
  org.label-schema.version="${DOCKER_IMAGE_TAG}" \
  org.label-schema.description="${DOCKER_PROJECT_DESC}" \
  org.label-schema.url="${DOCKER_PROJECT_URL}" \
  org.label-schema.vcs-url="${GITHUB_URL}" \
  org.label-schema.vcs-ref="${VCS_REF}" \
  org.label-schema.build-date="${BUILD_DATE}"

ARG XPACK_EDITION
ENV XPACK_EDITION=${XPACK_EDITION}

RUN set -exo pipefail; \
  # Add X-Pack Reporting dependencies
  yum update -y && yum install -y fontconfig freetype && yum clean all; \
  # Install X-Pack and optimize bundle for X-Pack edition
  cp config/kibana.${XPACK_EDITION}.yml config/kibana.yml; \
  kibana-plugin install x-pack; \
  rm -f config/kibana.yml
