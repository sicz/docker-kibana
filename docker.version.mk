### BASE_IMAGE #################################################################

BASE_IMAGE_NAME		?= $(DOCKER_PROJECT)/baseimage-centos
BASE_IMAGE_TAG		?= 7

### DOCKER_IMAGE ###############################################################

DOCKER_PROJECT		?= sicz
DOCKER_PROJECT_DESC	?= An analytics and search dashboard for Elasticsearch
DOCKER_PROJECT_URL	?= https://www.elastic.co/products/kibana

DOCKER_NAME		?= kibana
DOCKER_IMAGE_TAG	?= $(KIBANA_VERSION)

### BUILD ######################################################################

# Docker image build variables
BUILD_VARS		+= ELASTICSEARCH_IMAGE \
			   ES_DISCOVERY_TYPE \
			   KIBANA_VERSION

ELASTICSEARCH_VERSION	?= $(shell echo $(KIBANA_VERSION) | sed -E "s/-.*//")
ELASTICSEARCH_IMAGE	?= $(DOCKER_PROJECT)/elasticsearch:$(ELASTICSEARCH_VERSION)

# Disable Elasticsearch bootstrap checks
ES_DISCOVERY_TYPE	?= single-node

### DOCKER_EXECUTOR ############################################################

# Use the Docker Compose executor
DOCKER_EXECUTOR		?= compose

# Variables used in the Docker Compose file
COMPOSE_VARS		+= SERVER_CRT_HOST \
			   SERVICE_NAME \
			   SIMPLE_CA_IMAGE

# Use the same service name for all configurations
SERVICE_NAME		?= container

# Certificate subject aletrnative names
SERVER_CRT_HOST		+= $(SERVICE_NAME).local

### SIMPLE_CA ##################################################################

# Docker image dependencies
DOCKER_IMAGE_DEPENDENCIES += $(SIMPLE_CA_IMAGE)

# Simple CA image
SIMPLE_CA_IMAGE_NAME	?= sicz/simple-ca
SIMPLE_CA_IMAGE_TAG	?= latest
SIMPLE_CA_IMAGE		?= $(SIMPLE_CA_IMAGE_NAME):$(SIMPLE_CA_IMAGE_TAG)

# Simple CA service name in the Docker Compose file
SIMPLE_CA_SERVICE_NAME	?= $(shell echo $(SIMPLE_CA_IMAGE_NAME) | sed -E -e "s|^.*/||" -e "s/[^[:alnum:]_]+/_/g")

# Simple CA container name
ifeq ($(DOCKER_EXECUTOR),container)
SIMPLE_CA_CONTAINER_NAME ?= $(DOCKER_EXECUTOR_ID)_$(SIMPLE_CA_SERVICE_NAME)
else ifeq ($(DOCKER_EXECUTOR),compose)
SIMPLE_CA_CONTAINER_NAME ?= $(DOCKER_EXECUTOR_ID)_$(SIMPLE_CA_SERVICE_NAME)_1
else ifeq ($(DOCKER_EXECUTOR),stack)
# TODO: Docker Swarm Stack executor
SIMPLE_CA_CONTAINER_NAME ?= $(DOCKER_EXECUTOR_ID)_$(SIMPLE_CA_SERVICE_NAME)_1
else
$(error Unknown Docker executor "$(DOCKER_EXECUTOR)")
endif

### MAKE_VARS ##################################################################

# Display the make variables
MAKE_VARS		?= GITHUB_MAKE_VARS \
			   BASE_IMAGE_MAKE_VARS \
			   DOCKER_IMAGE_MAKE_VARS \
			   CONFIG_MAKE_VARS \
			   BUILD_MAKE_VARS \
			   EXECUTOR_MAKE_VARS \
			   SHELL_MAKE_VARS \
			   DOCKER_REGISTRY_MAKE_VARS


define CONFIG_MAKE_VARS
KIBANA_VERSION:	$(LOGSTAH_VERSION)

ELASTICSEARCH_VERSION:	$(ELASTICSEARCH_VERSION)
ELASTICSEARCH_IMAGE:	$(ELASTICSEARCH_IMAGE)
ES_DISCOVERY_TYPE:	$(ES_DISCOVERY_TYPE)

SIMPLE_CA_IMAGE_NAME:	$(SIMPLE_CA_IMAGE_NAME)
SIMPLE_CA_IMAGE_TAG:	$(SIMPLE_CA_IMAGE_TAG)
SIMPLE_CA_IMAGE:	$(SIMPLE_CA_IMAGE)

SERVER_CRT_HOST:	$(SERVER_CRT_HOST)
endef
export CONFIG_MAKE_VARS

### MAKE_TARGETS ###############################################################

# Build a new image and run the tests
.PHONY: all
all: clean build start wait logs test

# Build a new image and run the tests
.PHONY: ci
ci: all
	@$(MAKE) clean

### BUILD_TARGETS ##############################################################

# Build a new image with using the Docker layer caching
.PHONY: build
build: docker-build

# Build a new image without using the Docker layer caching
.PHONY: rebuild
rebuild: docker-rebuild

### EXECUTOR_TARGETS ###########################################################

# Display the configuration file
.PHONY: config-file
config-file: display-config-file

# Display the make variables
.PHONY: vars
vars: display-makevars

# Remove the containers and then run them fresh
.PHONY: run up
run up: docker-up

# Create the containers
.PHONY: create
create: docker-create

# Start the containers
.PHONY: start
start: create docker-start

# Wait for the start of the containers
.PHONY: wait
wait: start docker-wait

# Display running containers
.PHONY: ps
ps: docker-ps

# Display the container logs
.PHONY: logs
logs: docker-logs

# Follow the container logs
.PHONY: logs-tail tail
logs-tail tail: docker-logs-tail

# Run shell in the container
.PHONY: shell sh
shell sh: start docker-shell

# Run the tests
.PHONY: test
test: start docker-test

# Run the shell in the test container
.PHONY: test-shell tsh
test-shell tsh:
	@$(MAKE) test TEST_CMD=/bin/bash

# Stop the containers
.PHONY: stop
stop: docker-stop

# Restart the containers
.PHONY: restart
restart: stop start

# Remove the containers
.PHONY: down rm
down rm: docker-rm

# Remove all containers and work files
.PHONY: clean
clean: docker-clean

### MK_DOCKER_IMAGE ############################################################

MK_DIR			?= $(PROJECT_DIR)/../Mk
include $(MK_DIR)/docker.image.mk

################################################################################