#!/bin/bash -e

### XPACK_ELASTICSEARCH_YML ####################################################

# Default Elasticsearch user name and password
: ${KB_ELASTICSEARCH_USERNAME:=kibana}
if [ -e /run/secrets/es_${KB_ELASTICSEARCH_USERNAME}_pwd ]; then
  : ${KB_ELASTICSEARCH_PASSWORD_FILE:=/run/secrets/es_${KB_ELASTICSEARCH_USERNAME}.pwd}
else
  : ${KB_ELASTICSEARCH_PASSWORD_FILE:=${KB_SETTINGS_DIR}/es_${KB_ELASTICSEARCH_USERNAME}.pwd}
fi
if [ -e ${KB_ELASTICSEARCH_PASSWORD_FILE} ]; then
  KB_ELASTICSEARCH_PASSWORD=$(cat ${KB_ELASTICSEARCH_PASSWORD_FILE})
fi
unset KB_ELASTICSEARCH_PASSWORD_FILE

# TODO: ssl/tls

if [ -n "${XPACK_EDITION}" ]; then
  KIBANA_YML_FILES="${KIBANA_YML_FILES} kibana.x-pack.${XPACK_EDITION}.yml"
fi

################################################################################
