#!/bin/bash -e

### KIBANA_DOCKER_YML ##########################################################

if [ ! -e ${KB_PATH_CONF}/kibana.docker.yml ]; then
  info "Creating ${KB_PATH_CONF}/kibana.docker.yml"
  (
    # Kibana 4.x does not support server.name
    if [ -n "${KB_NODE_NAME}" ]; then
      echo "server.name: ${KB_NODE_NAME}"
    fi
    echo "server.host: 0.0.0.0"
    echo "elasticsearch.url: ${ELASTICSEARCH_URL}"
    if [ -n "${ES_KIBANA_USERNAME}" -a -n "${ES_KIBANA_PASSWORD}" ]; then
      echo "elasticsearch.username: ${ES_KIBANA_USERNAME}"
      echo "elasticsearch.password: ${ES_KIBANA_PASSWORD}"
    fi
    echo "path.data: ${KB_PATH_DATA}"
  ) > ${KB_PATH_CONF}/kibana.docker.yml
fi

KIBANA_YML_FILES="kibana.docker.yml ${KIBANA_YML_FILES}"

### KIBANA_SERVER_CERTS_YML ####################################################

if [ -e ${SERVER_CRT_FILE} ]; then
  if [ ! -e ${KB_PATH_CONF}/kibana.server-certs.yml ]; then
    info "Creating ${KB_PATH_CONF}/kibana.server-certs.yml"
    (
      echo "server.ssl.cert: ${SERVER_CRT_FILE}"
      echo "server.ssl.key: ${SERVER_KEY_FILE}"
      echo "server.ssl.keyPassphrase: ${SERVER_KEY_PWD}"
    ) > ${KB_PATH_CONF}/kibana.server-certs.yml
  fi
  KIBANA_YML_FILES="${KIBANA_YML_FILES} kibana.server-certs.yml"
fi

################################################################################
