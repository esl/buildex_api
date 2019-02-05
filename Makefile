.PHONY: build dev

PROJECT := $(shell pwd | awk 'BEGIN{FS="/"}{print $$NF}' )
GIT_TAG := $(shell git describe --tags --abbrev=0 2> /dev/null || echo "" )
DOCKER_BRANCH := $(shell git describe --always --all | sed 's_^heads/__;s/\//-/g' )
DOCKER_TAG_AND_HASH := $(shell git describe --always)

build:
	docker build --build-arg=tag="$(GIT_TAG)" -t "$(PROJECT):$(DOCKER_BRANCH)-$(DOCKER_TAG_AND_HASH)" -t "$(PROJECT):latest" . 

dev:
	mix deps.get && exec iex --name admin@127.0.0.1 --cookie buildix -S mix
