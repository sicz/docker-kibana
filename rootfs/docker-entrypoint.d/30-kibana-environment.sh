#!/bin/bash -e

### KB_PATH ####################################################################

# Path to settings directory
: ${KB_PATH_CONF:=${KB_HOME}/config}

# Path do data and log directories
: ${KB_PATH_DATA:=${KB_HOME}/data}
: ${KB_PATH_LOGS:=${KB_HOME}/logs}
: ${KB_PATH_OPTIMIZE:=${KB_HOME}/optimize}
# Swarm service in replicated mode might use one volume for multiple nodes
if [ -n "${DOCKER_HOST_NAME}" ]; then
  KB_PATH_DATA=${KB_PATH_DATA}/${DOCKER_CONTAINER_NAME}
  KB_PATH_LOGS=${KB_PATH_LOGS}/${DOCKER_CONTAINER_NAME}
fi

# Create missing directories
mkdir -p ${KB_PATH_CONF} ${KB_PATH_DATA} ${KB_PATH_LOGS} ${KB_PATH_OPTIMIZE}

# Populate settings directory
if [ "$(readlink -f ${KB_HOME}/config)" != "$(readlink -f ${KB_PATH_CONF})" ]; then
  cp -rp ${KB_HOME}/config/* ${KB_PATH_CONF}
fi

### KB_NODE ####################################################################

# Kibana node name
if [ -n "${DOCKER_HOST_NAME}" ]; then
  KB_NODE_NAME="${DOCKER_CONTAINER_NAME}@${DOCKER_HOST_NAME}"
else
  KB_NODE_NAME="${DOCKER_CONTAINER_NAME}"
fi

# TODO: ssl/tls

### ES_KIBANA_USER #############################################################

# Default Elasticsearch user name and password
: ${ES_KIBANA_USERNAME:=kibana}
if [ -e /run/secrets/es_${ES_KIBANA_USERNAME}_pwd ]; then
  : ${ES_KIBANA_PASSWORD_FILE:=/run/secrets/es_${ES_KIBANA_USERNAME}.pwd}
else
  : ${ES_KIBANA_PASSWORD_FILE:=${KB_PATH_CONF}/es_${ES_KIBANA_USERNAME}.pwd}
fi
if [ -e ${ES_KIBANA_PASSWORD_FILE} ]; then
  ES_KIBANA_PASSWORD=$(cat ${ES_KIBANA_PASSWORD_FILE})
fi
unset ES_KIBANA_PASSWORD_FILE

# TODO: ssl/tls

### CERTS ######################################################################

# Default certificate and key directories
SERVER_CRT_DIR=${KB_PATH_CONF}
SERVER_KEY_DIR=${KB_PATH_CONF}

### WAIT_FOR ###################################################################

WAIT_FOR_DNS="${WAIT_FOR_DNS} ${ELASTICSEARCH_URL}"

################################################################################
