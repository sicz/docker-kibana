#!/bin/bash -e

### KIBANA 4x ##################################################################

# Kibana 4.x does not support encrypted TLS keys
echo -n > ${KB_PATH_CONF}/kibana.server-certs.yml

################################################################################
