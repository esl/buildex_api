.phony: build

PROJECT := $(shell pwd | awk 'BEGIN{FS="/"}{print $$NF}' )
GIT_TAG := $(shell git describe --tags --abbrev=0)
DOCKER_BRANCH := $(shell git describe --always --all | sed 's_^heads/__;s/\//-/g' )
DOCKER_TAG_AND_HASH := $(shell git describe --always)

build:
	docker build --build-arg=tag="$(GIT_TAG)" -t "$(PROJECT):$(DOCKER_BRANCH)-$(DOCKER_TAG_AND_HASH)" -t "$(PROJECT):latest" . 
