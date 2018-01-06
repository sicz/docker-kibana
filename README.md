# docker-kibana

[![CircleCI Status Badge](https://circleci.com/gh/sicz/docker-kibana.svg?style=shield&circle-token=d977dcd6fffb71817e2fcfb86f79eefa4b74943d)](https://circleci.com/gh/sicz/docker-kibana)

**This project is not aimed at public consumption.
It exists to serve as a single endpoint for SICZ containers.**

[Kibana](https://www.elastic.co/products/kibana) is an analytics and search
dashboard for Elasticsearch.

## Contents

This container only contains essential components:
* [Kibana](https://www.elastic.co/products/) is an analytics and search
  dashboard for Elasticsearch.
* [Kibana X-Pack plugin](https://www.elastic.co/products/x-pack) adds
  many capabilities to Kibana.

## Getting started

These instructions will get you a copy of the project up and running on your
local machine for development and testing purposes. See deployment for notes
on how to deploy the project on a live system.

### Installing

Clone the GitHub repository into your working directory:
```bash
git clone https://github.com/sicz/docker-kibana
```

### Usage

The project contains Docker image version directories:
* `x.y.z` - Kibana
* `x.y.z/x-pack` - Kibana with X-Pack plugin

Use the command `make` in the project directory:
```bash
make all                      # Build and test all Docker images
make build                    # Build all Docker images
make rebuild                  # Rebuild all Docker images
make clean                    # Remove all containers and clean work files
make docker-pull              # Pull all images from Docker Registry
make docker-pull-baseimage    # Pull the base image from the Docker Registry
make docker-pull-dependencies # Pull all image dependencies from Docker Registry
make docker-pull-image        # Pull all project images from Docker Registry
make docker-pull-testimage    # Pull all project images from Docker Registry
make docker-push              # Push all project images to Docker Registry
```

Use the command `make` in the image version directories:
```bash
make all                      # Build a new image and run the tests
make ci                       # Build a new image and run the tests
make build                    # Build a new image
make rebuild                  # Build a new image without using the Docker layer caching
make config-file              # Display the configuration file for the current configuration
make vars                     # Display the make variables for the current configuration
make up                       # Remove the containers and then run them fresh
make create                   # Create the containers
make start                    # Start the containers
make stop                     # Stop the containers
make restart                  # Restart the containers
make rm                       # Remove the containers
make wait                     # Wait for the start of the containers
make ps                       # Display running containers
make logs                     # Display the container logs
make logs-tail                # Follow the container logs
make shell                    # Run the shell in the container
make test                     # Run the tests
make test-shell               # Run the shell in the test container
make clean                    # Remove all containers and work files
make docker-pull              # Pull all images from the Docker Registry
make docker-pull-baseimage    # Pull the base image from the Docker Registry
make docker-pull-dependencies # Pull the project image dependencies from the Docker Registry
make docker-pull-image        # Pull the project image from the Docker Registry
make docker-pull-testimage    # Pull the test image from the Docker Registry
make docker-push              # Push the project image into the Docker Registry
```

`Kibana` container with default configuration listens on TCP port 5601 and uses HTTPS.

## Deployment

You can start with this sample `docker-compose.yml` file:
```yaml
services:
  kibana:
    image: sicz/kibana
    environment:
      - ELASTICSEARCH_URL=http://elasticsearch:9200
  elasticsearch:
    image: sicz/elasticsearch
    volumes:
      - elasticsearch_data:/usr/share/elasticsearch_data
volumes:
  elasticsearch_data:
```

## Authors

* [Petr Řehoř](https://github.com/prehor) - Initial work.

See also the list of [contributors](https://github.com/sicz/docker-kibana/contributors)
who participated in this project.

## License

This project is licensed under the Apache License, Version 2.0 - see the
[LICENSE](LICENSE) file for details.
