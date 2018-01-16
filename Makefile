### SHELL ######################################################################

# Use bash as a shell
SHELL   		:= /bin/bash

# Exit immediately if a command exits with a non-zero exit status
# TODO: .SHELLFLAGS does not exists on obsoleted macOS X-Code make
# .SHELLFLAGS		= -ec
SHELL			+= -e

### DOCKER_VERSIONS ############################################################

# Docker image versions
DOCKER_VERSIONS		?= 4.6.6 \
			   6.1.2 \
			   6.1.2/basic \
			   6.1.2/gold \
			   6.1.2/platinum

# Make targets propagated to all Docker image versions
DOCKER_VERSION_TARGETS	+= build \
			   rebuild \
			   ci \
			   clean \
			   docker-pull \
			   docker-pull-dependencies \
			   docker-pull-image \
			   docker-pull-testimage \
			   docker-push \
			   docker-load-image \
			   docker-save-image

### MAKE_TARGETS ###############################################################

# Build all images and run all tests
.PHONY: all
all: ci

# Subdir targets
.PHONY: $(DOCKER_VERSION_TARGETS)
$(DOCKER_VERSION_TARGETS):
	@for DOCKER_VERSION in $(DOCKER_VERSIONS); do \
		cd $(CURDIR)/$${DOCKER_VERSION}; \
		$(MAKE) display-version-header $@; \
	done
# Do docker-pull-baseimage only on pure Kibana
docker-pull-baseimage:
	@for DOCKER_VERSION in $(DOCKER_VERSIONS); do \
		if [[ $${DOCKER_VERSION} =~ ^[0-9]+(\.[0-9]+)*$$ ]]; then \
			cd $(CURDIR)/$${DOCKER_VERSION}; \
			$(MAKE) display-version-header $@; \
		fi; \
	done

################################################################################
