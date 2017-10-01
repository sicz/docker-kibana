### DOCKER_IMAGE ###############################################################

KIBANA_VERSION		?= 6.0.0-rc1
KIBANA_TAG		?= 6.0.0

### TEST #######################################################################

# Skip Elasticsearch X-Pack tests
SPEC_OPTS		?= --tag ~x_pack

### MK_DOCKER_IMAGE ############################################################

PROJECT_DIR		?= $(abspath ..)
include $(PROJECT_DIR)/docker.version.mk

################################################################################
