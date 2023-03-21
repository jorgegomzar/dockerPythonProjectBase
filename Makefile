#!make
include .env
SHELL := /bin/bash

# Constants
TAIL_LOGS = 50

complete-build: build up

up:
	docker compose up --force-recreate --remove-orphans -d

down:
	docker compose down

start-registry:
	docker run -d -p ${REGISTRY_PORT}:5000 --restart=always --name "${REGISTRY_NAME}" registry:2

sh:
	docker exec -it ${DOCKER_CONTAINER} bash

logs:
	docker logs --tail ${TAIL_LOGS} -f ${DOCKER_CONTAINER}

ruff:
	ruff check . --fix

build:
	docker buildx build -f docker/src/Dockerfile --platform linux/amd64 --output type=docker -t ${DOCKER_IMAGE}:${TAG} .
	docker tag ${DOCKER_IMAGE}:${TAG} ${REGISTRY}:${REGISTRY_PORT}/${DOCKER_IMAGE}:${TAG}

backup:
	docker tag  ${REGISTRY}:${REGISTRY_PORT}/${DOCKER_IMAGE}:${TAG}  ${REGISTRY}:${REGISTRY_PORT}/${DOCKER_IMAGE}:${TAG}-backup