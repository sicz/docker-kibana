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

ENV ELASTIC_CONTAINER=true

ARG KIBANA_VERSION
ENV KIBANA_HOME=/usr/share/kibana
ARG KIBANA_TARBALL=kibana-${KIBANA_VERSION}-linux-x86_64.tar.gz
ARG KIBANA_TARBALL_URL=https://artifacts.elastic.co/downloads/kibana/${KIBANA_TARBALL}
ARG KIBANA_TARBALL_SHA1_URL=${KIBANA_TARBALL_URL}.sha1

ENV \
  DOCKER_USER=kibana \
  DOCKER_COMMAND=kibana \
  PATH=${KIBANA_HOME}/bin:${PATH}

WORKDIR ${KIBANA_HOME}

RUN set -exo pipefail; \
  adduser --uid 1000 --user-group --home-dir ${KIBANA_HOME} ${DOCKER_USER}; \
  curl -fLo /tmp/${KIBANA_TARBALL} ${KIBANA_TARBALL_URL}; \
  EXPECTED_SHA1=$(curl -fL ${KIBANA_TARBALL_SHA1_URL}); \
  TARBALL_SHA1=$(sha1sum /tmp/${KIBANA_TARBALL} | cut -d ' ' -f 1); \
  [ "${TARBALL_SHA1}" = "${EXPECTED_SHA1}" ]; \
  tar xz --strip-components=1 -f /tmp/${KIBANA_TARBALL}; \
  rm -f /tmp/${KIBANA_TARBALL}; \
  mkdir -p plugins; \
  chown -R root:root .; \
  chmod -R go-w .; \
  mv config/kibana.yml config/kibana.default.yml

RUN set -exo pipefail; \
  # Add X-Pack Reporting dependencies
  yum update -y && yum install -y fontconfig freetype && yum clean all; \
  touch config/kibana.yml; \
  kibana-plugin install x-pack; \
  rm -f config/kibana.yml

COPY config /

EXPOSE \
  5601/tcp
