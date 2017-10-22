#!/bin/bash -e

### KIBANA_YML #################################################################

if [ ! -e ${KB_PATH_CONF}/kibana.yml ]; then
  info "Creating ${KB_PATH_CONF}/kibana.yml"
  (
    for KIBANA_YML_FILE in ${KIBANA_YML_FILES}; do
      echo "# ${KIBANA_YML_FILE}"
      cat ${KB_PATH_CONF}/${KIBANA_YML_FILE}
    done
  ) > ${KB_PATH_CONF}/kibana.yml
  if [ -n "${DOCKER_ENTRYPOINT_DEBUG}" ]; then
    cat ${KB_PATH_CONF}/kibana.yml
  fi
fi

################################################################################
