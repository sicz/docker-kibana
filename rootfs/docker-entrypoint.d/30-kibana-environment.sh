#!/bin/bash -e

### KB_PATH ####################################################################

# Path to settings directory
: ${KB_PATH_CONF:=${KB_HOME}/config}

# Path do data and log directories
: ${KB_PATH_DATA:=${KB_HOME}/data}
: ${KB_PATH_OPTIMIZE:=${KB_HOME}/optimize}
# Swarm service in replicated mode might use one volume for multiple nodes
if [ -n "${DOCKER_HOST_NAME}" ]; then
  KB_PATH_DATA=${KB_PATH_DATA}/${DOCKER_CONTAINER_NAME}
  if [ -n "${KB_PATH_LOGS}" ]; then
    KB_PATH_LOGS=${KB_PATH_LOGS}/${DOCKER_CONTAINER_NAME}
  fi
fi

# Create missing directories
mkdir -p ${KB_PATH_CONF} ${KB_PATH_DATA} ${KB_PATH_LOGS} KB_PATH_OPTIMIZE

# Populate Elasticsearch settings directory
if [ "$(readlink -f ${KB_HOME}/config)" != "$(readlink -f ${KB_PATH_CONF})" ]; then
  cp -rp ${KB_HOME}/config/* ${KB_PATH_CONF}
fi

### KB_NODE ####################################################################

# Elasticsearch node name
if [ -n "${DOCKER_HOST_NAME}" ]; then
  KB_NODE_NAME="${DOCKER_CONTAINER_NAME}@${DOCKER_HOST_NAME}"
else
  KB_NODE_NAME="${DOCKER_CONTAINER_NAME}"
fi

# TODO: ssl/tls

### KB_ELASTICSEARCH ###########################################################

# Elasticsearch URL
: ${KB_ELASTICSEARCH_URL:=${ELASTICSEARCH_URL}}

# Default Elasticsearch user name and password
: ${KB_ELASTICSEARCH_USERNAME:=kibana}
if [ -e /run/secrets/es_${KB_ELASTICSEARCH_USERNAME}_pwd ]; then
  : ${KB_ELASTICSEARCH_PASSWORD_FILE:=/run/secrets/es_${KB_ELASTICSEARCH_USERNAME}.pwd}
else
  : ${KB_ELASTICSEARCH_PASSWORD_FILE:=${KB_PATH_CONF}/es_${KB_ELASTICSEARCH_USERNAME}.pwd}
fi
if [ -e ${KB_ELASTICSEARCH_PASSWORD_FILE} ]; then
  KB_ELASTICSEARCH_PASSWORD=$(cat ${KB_ELASTICSEARCH_PASSWORD_FILE})
fi

# TODO: ssl/tls

### CERTS ######################################################################

# Default certificate and key directories
SERVER_CRT_DIR=${KB_PATH_CONF}
SERVER_KEY_DIR=${KB_PATH_CONF}

################################################################################
