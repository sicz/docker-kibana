### BASE_IMAGE #################################################################

BASE_IMAGE_NAME		?= $(DOCKER_IMAGE_NAME)
BASE_IMAGE_TAG		?= $(KIBANA_TAG)

### DOCKER_IMAGE ###############################################################

XPACK_EDITION		?= basic

DOCKER_IMAGE_TAG	?= $(BASE_IMAGE_TAG)-x-pack-$(XPACK_EDITION)
DOCKER_IMAGE_TAGS	?= x-pack-$(XPACK_EDITION) x-pack

### BUILD ######################################################################

VARIANT_DIR		?= $(PROJECT_DIR)/x-pack

BUILD_VARS		?= XPACK_EDITION

### EXECUTOR ###################################################################

DOCKER_CONFIG		?= $(XPACK_EDITION)

### ELASTICSEARCH ##############################################################

ELASTICSEARCH_IMAGE_TAG	?= $(KIBANA_TAG)-x-pack

### TEST #######################################################################

# Do all tests
SPEC_OPTS		?=

### MK_DOCKER_IMAGE ############################################################

PROJECT_DIR		?= $(abspath ../..)
include ../Makefile

################################################################################
