### BASE_IMAGE #################################################################

BASE_IMAGE_NAME		?= $(DOCKER_IMAGE_NAME)
BASE_IMAGE_TAG		?= $(KIBANA_VERSION)

### DOCKER_IMAGE ###############################################################

XPACK_EDITION		?= basic

DOCKER_IMAGE_TAG	?= $(KIBANA_VERSION)-$(XPACK_EDITION)
DOCKER_IMAGE_TAGS	?= 5.6-$(XPACK_EDITION) 5-$(XPACK_EDITION) $(XPACK_EDITION)

### BUILD ######################################################################

VARIANT_DIR		?= $(PROJECT_DIR)/x-pack

BUILD_VARS		+= XPACK_EDITION

### MK_DOCKER_IMAGE ############################################################

PROJECT_DIR		?= $(abspath ../..)
include ../Makefile

################################################################################
