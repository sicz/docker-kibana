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

ARG KIBANA_VERSION
ARG KIBANA_HOME=/usr/share/kibana
ARG KIBANA_TARBALL=kibana-${KIBANA_VERSION}-linux-x86_64.tar.gz
ARG KIBANA_TARBALL_URL=https://download.elastic.co/kibana/kibana/${KIBANA_TARBALL}
ARG KIBANA_TARBALL_SHA1_URL=${KIBANA_TARBALL_URL}.sha1.txt

ENV \
  DOCKER_USER="kibana" \
  DOCKER_COMMAND="kibana" \
  ELASTIC_CONTAINER="true" \
  KIBANA_HOME="${KIBANA_HOME}" \
  KIBANA_VERSION="${KIBANA_VERSION}" \
  PATH="${KIBANA_HOME}/bin:${PATH}"

WORKDIR ${KIBANA_HOME}

RUN set -exo pipefail; \
  adduser --uid 1000 --user-group --home-dir ${KIBANA_HOME} ${DOCKER_USER}; \
  curl -fLo /tmp/${KIBANA_TARBALL} ${KIBANA_TARBALL_URL}; \
  EXPECTED_SHA1=$(curl -fL ${KIBANA_TARBALL_SHA1_URL} | cut -d ' ' -f 1); \
  TARBALL_SHA1=$(sha1sum /tmp/${KIBANA_TARBALL} | cut -d ' ' -f 1); \
  [ "${TARBALL_SHA1}" = "${EXPECTED_SHA1}" ]; \
  tar xz --strip-components=1 -f /tmp/${KIBANA_TARBALL}; \
  rm -f /tmp/${KIBANA_TARBALL}; \
  mkdir -p plugins; \
  chown -R root:root .; \
  chmod -R go-w .; \
  mv config/kibana.yml config/kibana.default.yml

COPY rootfs /
COPY ${KIBANA_VERSION}/rootfs /

EXPOSE \
  5601/tcp
