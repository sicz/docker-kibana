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

ARG CHECKSUM="sha512"

ARG KIBANA_VERSION
ARG KB_TARBALL="kibana-${KIBANA_VERSION}-linux-x86_64.tar.gz"
ARG KB_TARBALL_URL="https://artifacts.elastic.co/downloads/kibana/${KB_TARBALL}"
ARG KB_TARBALL_CHECKSUM_URL="${KB_TARBALL_URL}.${CHECKSUM}"
ARG KB_HOME="/usr/share/kibana"

ENV \
  DOCKER_USER="kibana" \
  DOCKER_COMMAND="kibana" \
  ELASTIC_CONTAINER="true" \
  KIBANA_VERSION="${KIBANA_VERSION}" \
  KB_HOME="${KB_HOME}" \
  PATH="${KB_HOME}/bin:${PATH}"

WORKDIR ${KB_HOME}

RUN set -exo pipefail; \
  adduser --uid 1000 --user-group --home-dir ${KB_HOME} ${DOCKER_USER}; \
  curl -fLo /tmp/${KB_TARBALL} ${KB_TARBALL_URL}; \
  EXPECTED_CHECKSUM=$(curl -fL ${KB_TARBALL_CHECKSUM_URL} | cut -d " " -f 1); \
  TARBALL_CHECKSUM=$(${CHECKSUM}sum /tmp/${KB_TARBALL} | cut -d " " -f 1); \
  [ "${TARBALL_CHECKSUM}" = "${EXPECTED_CHECKSUM}" ]; \
  tar xz --strip-components=1 -f /tmp/${KB_TARBALL}; \
  rm -f /tmp/${KB_TARBALL}; \
  mkdir -p logs plugins; \
  chown -R root:root .; \
  chmod -R go-w .; \
  mv config/kibana.yml config/kibana.default.yml

COPY rootfs /

EXPOSE \
  5601/tcp
