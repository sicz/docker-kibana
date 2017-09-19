#!/bin/bash -e

### KB_PATH ####################################################################

# Create missing directories
mkdir -p ${KB_PATH_SETTINGS} ${KB_PATH_DATA} ${KB_PATH_LOGS} ${KB_PATH_OPTIMIZE}

### KB_HOST ####################################################################

: ${KB_SERVER_HOST:=0.0.0.0}

### XPACK_MONITORING ###########################################################

# TODO: X-Pack monitoring

### KIBANA_YML #################################################################

if [ ! -e ${KB_PATH_SETTINGS}/kibana.yml ]; then
  info "Creating ${KB_PATH_SETTINGS}/kibana.yml"
  (
    for KB_SETTINGS_FILE in ${KB_SETTINGS_FILES}; do
      cat ${KB_PATH_SETTINGS}/${KB_SETTINGS_FILE}
    done
    while IFS="=" read -r KEY VAL; do
      if [ ! -z "${VAL}" ]; then
        echo "${KEY}: ${VAL}"
      fi
    done < <(set | egrep "^(KB|XPACK)_" | egrep -v "^(KB_PATH_(LOGS|OPTIMIZE|SETTINGS)|KB_SETTINGS_)" | sed -E "s/^KB_//" | tr "_[:upper:]" ".[:lower:]" | sed -E "s/\.\./_/g" | sort)
  ) > ${KB_PATH_SETTINGS}/kibana.yml
  if [ -n "${DOCKER_ENTRYPOINT_DEBUG}" ]; then
    cat ${KB_PATH_SETTINGS}/kibana.yml
  fi
fi

### KB_PATH ####################################################################

# Set permissions
chown -R ${DOCKER_USER}:${DOCKER_GROUP} ${KB_PATH_SETTINGS} ${KB_PATH_DATA} ${KB_PATH_LOGS} ${KB_PATH_OPTIMIZE}
chmod -R g-w,o-rwx ${KB_PATH_SETTINGS} ${KB_PATH_DATA} ${KB_PATH_LOGS} ${KB_PATH_OPTIMIZE}

################################################################################
