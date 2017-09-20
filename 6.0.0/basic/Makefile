### BASE_IMAGE #################################################################

BASE_IMAGE_NAME		?= $(DOCKER_IMAGE_NAME)
BASE_IMAGE_TAG		?= $(shell echo $(KIBANA_VERSION) | sed -E "s/-.*//")

### DOCKER_IMAGE ###############################################################

XPACK_EDITION		?= basic

DOCKER_IMAGE_TAG	?= $(BASE_IMAGE_TAG)-$(XPACK_EDITION)
DOCKER_IMAGE_TAGS	?= 6.0-$(XPACK_EDITION) 6-$(XPACK_EDITION)

### BUILD ######################################################################

VARIANT_DIR		?= $(PROJECT_DIR)/x-pack

BUILD_VARS		+= XPACK_EDITION

### MK_DOCKER_IMAGE ############################################################

PROJECT_DIR		?= $(abspath ../..)
include ../Makefile

################################################################################
