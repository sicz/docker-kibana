#!/bin/bash -e

### X-PACK #####################################################################

# Default Kibana encryption key location
if [ -e /run/secrets/kb_encryption_key ]; then
  : ${XPACK_ENCRYPTION_KEY_FILE:=/run/secrets/kb_encryption_key}
else
  : ${KB_ENCRYPTION_KEY_FILE:=${KB_PATH_CONF}/kb_encryption_key}
fi

### KIBANA_YML #################################################################

KIBANA_YML_FILES="${KIBANA_YML_FILES} kibana.x-pack.${XPACK_EDITION}.yml"

################################################################################
