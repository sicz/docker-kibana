#!/bin/bash -e

### KB_OPTS ####################################################################

if [ -n "${DOCKER_CONTAINER_START}" ]; then
  declare -a KB_OPTS
  KB_OPTS+=("--config ${KB_PATH_CONF}/kibana.yml")
  while IFS="=" read -r KEY VAL; do
    if [ ! -z "${VAL}" ]; then
      KB_OPTS+=("--${KEY}=${VAL}")
    fi
  done < <(env | egrep "^[a-z_]+\.[a-z_]+" | sort)
  set -- "$@" ${KB_OPTS[@]}
  unset KB_OPTS
fi

### KB_PATH ####################################################################

# Set permissions
chown -R ${DOCKER_USER}:${DOCKER_GROUP} ${KB_PATH_CONF} ${KB_PATH_DATA} ${KB_PATH_LOGS} ${KB_PATH_OPTIMIZE}
chmod -R u=rwX,g=rX,o-rwx ${KB_PATH_CONF} ${KB_PATH_DATA} ${KB_PATH_LOGS} ${KB_PATH_OPTIMIZE}

################################################################################
