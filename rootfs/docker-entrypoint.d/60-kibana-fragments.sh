#!/bin/bash -e

### ELASTICSEARCH_DOCKER_YML ###################################################

if [ ! -e ${KB_PATH_CONF}/kibana.docker.yml ]; then
  info "Creating ${KB_PATH_CONF}/kibana.docker.yml"
  (
    # Kibana 4.x does not support server.name
    if [ -n "${KB_NODE_NAME}" ]; then
      echo "server.name: ${KB_NODE_NAME}"
    fi
    echo "server.host: 0.0.0.0"
    echo "elasticsearch.url: ${KB_ELASTICSEARCH_URL}"
    if [ -n "${KB_ELASTICSEARCH_USERNAME}" -a -n "${KB_ELASTICSEARCH_PASSWORD}" ]; then
      echo "elasticsearch.username: ${KB_ELASTICSEARCH_USERNAME}"
      echo "elasticsearch.password: ${KB_ELASTICSEARCH_PASSWORD}"
    fi
    echo "path.data: ${KB_PATH_DATA}"
    if [ -n "${KB_PATH_LOGS}" ]; then
      echo "logging.dest: ${KB_PATH_LOGS}"
    fi
  ) > ${KB_PATH_CONF}/kibana.docker.yml
  if [ -n "${DOCKER_ENTRYPOINT_DEBUG}" ]; then
    cat ${KB_PATH_CONF}/kibana.docker.yml
  fi
fi

KIBANA_YML_FILES="kibana.docker.yml ${KIBANA_YML_FILES}"

### ELASTICSEARCH_SERVER_CERTS_YML #############################################

if [ -e ${SERVER_CRT_FILE} ]; then
  if [ ! -e ${KB_PATH_CONF}/kibana.server-certs.yml ]; then
    info "Creating ${KB_PATH_CONF}/kibana.server-certs.yml"
    (
      echo "server.ssl.cert: ${SERVER_CRT_FILE}"
      echo "server.ssl.key: ${SERVER_KEY_FILE}"
      echo "server.ssl.keyPassphrase: ${SERVER_KEY_PWD}"
    ) > ${KB_PATH_CONF}/kibana.server-certs.yml
    if [ -n "${DOCKER_ENTRYPOINT_DEBUG}" ]; then
      cat ${KB_PATH_CONF}/kibana.server-certs.yml
    fi
  fi

  KIBANA_YML_FILES="${KIBANA_YML_FILES} kibana.server-certs.yml"
fi

################################################################################
