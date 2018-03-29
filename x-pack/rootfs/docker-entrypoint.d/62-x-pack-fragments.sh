### KIBANA_XPACK_YML ##########################################################

if [ ! -e ${KB_PATH_CONF}/kibana.x-pack.yml ]; then
  info "Creating ${KB_PATH_CONF}/kibana.x-pack.yml"
  (
    if [ -e ${KB_ENCRYPTION_KEY_FILE} ]; then
      KB_ENCRYPTION_KEY="$(cat ${KB_ENCRYPTION_KEY_FILE})"
    fi
    if [ -n "${KB_ENCRYPTION_KEY}" ]; then
      echo "xpack.security.encryptionKey: ${KB_ENCRYPTION_KEY}"
      echo "xpack.reporting.encryptionKey: ${KB_ENCRYPTION_KEY}"
    fi
  ) > ${KB_PATH_CONF}/kibana.x-pack.yml
fi

KIBANA_YML_FILES="${KIBANA_YML_FILES} kibana.x-pack.yml"

################################################################################
