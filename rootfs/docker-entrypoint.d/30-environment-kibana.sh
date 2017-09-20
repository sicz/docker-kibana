#!/bin/bash -e

### KB_PATH ####################################################################

# Path to settings directory
: ${KB_PATH_SETTINGS:=${KIBANA_HOME}/config}

# Path do data and log directories
: ${KB_PATH_DATA:=${KIBANA_HOME}/data}
: ${KB_PATH_LOGS:=${KIBANA_HOME}/logs}
: ${KB_PATH_OPTIMIZE:=${KIBANA_HOME}/optimize}
# Swarm service in replicated mode might use one volume for multiple nodes
if [ -n "${DOCKER_HOST_NAME}" ]; then
  KB_PATH_DATA=${KB_PATH_DATA}/${DOCKER_CONTAINER_NAME}
  KB_PATH_LOGS=${KB_PATH_LOGS}/${DOCKER_CONTAINER_NAME}
fi

### SERVER #####################################################################

# Elasticsearch node name
if [ -n "${DOCKER_HOST_NAME}" ]; then
  KB_SERVER_NAME="${DOCKER_CONTAINER_NAME}@${DOCKER_HOST_NAME}"
else
  KB_SERVER_NAME="${DOCKER_CONTAINER_NAME}"
fi

# TODO: ssl/tls

### ELASTICSEARCH ##############################################################

# Elasticsearch URL
: ${KB_ELASTICSEARCH_URL:=${ELASTICSEARCH_URL}}

# Default Elasticsearch user name and password
: ${KB_ELASTICSEARCH_USERNAME:=kibana}
if [ -e /run/secrets/es_${KB_ELASTICSEARCH_URL}_pwd ]; then
  : ${KB_ELASTICSEARCH_PASSWORD_FILE:=/run/secrets/es_${KB_ELASTICSEARCH_USERNAME}.pwd}
else
  : ${KB_ELASTICSEARCH_PASSWORD_FILE:=${LS_SETTINGS_DIR}/es_${KB_ELASTICSEARCH_USERNAME}.pwd}
fi
if [ -e ${KB_ELASTICSEARCH_PASSWORD_FILE} ]; then
  KB_ELASTICSEARCH_PASSWORD=$(cat ${KB_ELASTICSEARCH_PASSWORD_FILE})
elif [ -n "${KB_ELASTICSEARCH_PASSWORD}" ]; then
  unset KB_ELASTICSEARCH_USERNAME
  unset KB_ELASTICSEARCH_PASSWORD
fi
unset KB_ELASTICSEARCH_PASSWORD_FILE

# TODO: ssl/tls

### CERTS ######################################################################

# Default truststore and keystore directories
SERVER_CRT_DIR=${KB_PATH_SETTINGS}
SERVER_KEY_DIR=${KB_PATH_SETTINGS}

### XPACK_CONFIG ###############################################################

if [ -n "${XPACK_EDITION}" ]; then
  KB_SETTINGS_FILES="${KB_SETTINGS_FILES} kibana.${XPACK_EDITION}.yml"
  unset XPACK_EDITION
fi

################################################################################
