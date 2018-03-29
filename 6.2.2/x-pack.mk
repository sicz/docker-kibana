### BASE_IMAGE #################################################################

BASE_IMAGE_NAME		?= $(DOCKER_IMAGE_NAME)
BASE_IMAGE_TAG		?= $(KIBANA_TAG)

### DOCKER_IMAGE ###############################################################

DOCKER_IMAGE_TAG	?= $(BASE_IMAGE_TAG)-x-pack-$(XPACK_EDITION)

### BUILD ######################################################################

VARIANT_DIR		?= $(PROJECT_DIR)/x-pack
BUILD_VARS		+= XPACK_EDITION

### EXECUTOR ###################################################################

DOCKER_CONFIG		?= $(XPACK_EDITION)

### TEST #######################################################################

# Do all tests
SPEC_OPTS		?= --tag ~searchguard

### MK_DOCKER_IMAGE ############################################################

include $(VERSION_DIR)/Makefile

################################################################################
