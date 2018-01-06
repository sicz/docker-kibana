ARG BASE_IMAGE
FROM ${BASE_IMAGE}

ARG KIBANA_VERSION
ARG KB_TARBALL="kibana-${KIBANA_VERSION}-linux-x86_64.tar.gz"
ARG KB_TARBALL_URL="https://artifacts.elastic.co/downloads/kibana/${KB_TARBALL}"
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
  EXPECTED_CHECKSUM=$(curl -fL ${KB_TARBALL_URL}.sha512 | cut -d " " -f 1); \
  TARBALL_CHECKSUM=$(sha512sum /tmp/${KB_TARBALL} | cut -d " " -f 1); \
  [ "${TARBALL_CHECKSUM}" = "${EXPECTED_CHECKSUM}" ]; \
  tar xz --strip-components=1 -f /tmp/${KB_TARBALL}; \
  rm -f /tmp/${KB_TARBALL}; \
  mkdir -p logs plugins; \
  chown -R root:root .; \
  chmod -R go-w .; \
  mv config/kibana.yml config/kibana.default.yml

COPY rootfs /
