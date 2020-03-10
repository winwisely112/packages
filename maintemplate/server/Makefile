.DEFAULT_GOAL       := help
VERSION             := v0.0.0
TARGET_MAX_CHAR_NUM := 20

GREEN  := $(shell tput -Txterm setaf 2)
YELLOW := $(shell tput -Txterm setaf 3)
WHITE  := $(shell tput -Txterm setaf 7)
RESET  := $(shell tput -Txterm sgr0)


.PHONY: help build-nats serve-maintemplate serve-nats

## Show help
help:
	@echo ''
	@echo ''
	@echo 'Usage:'
	@echo '  ${YELLOW}make${RESET} ${GREEN}<target>${RESET}'
	@echo ''
	@echo 'Targets:'
	@awk '/^[a-zA-Z\-\_0-9]+:/ { \
		helpMessage = match(lastLine, /^## (.*)/); \
		if (helpMessage) { \
			helpCommand = substr($$1, 0, index($$1, ":")); \
			helpMessage = substr(lastLine, RSTART + 3, RLENGTH); \
			printf "  ${YELLOW}%-$(TARGET_MAX_CHAR_NUM)s${RESET} ${GREEN}%s${RESET}\n", helpCommand, helpMessage; \
		} \
	} \
	{ lastLine = $$0 }' $(MAKEFILE_LIST)

## Serve nats-streaming-server
builds-nats:
	go get -v github.com/nats-io/nats-streaming-server

## Serve nats-streaming-server
serve-nats: builds-nats
	nats-streaming-server   --store file   --dir /tmp/maintemplte-data   --max_msgs 0   --max_bytes 0

## Build maintemplate server
build-maintemplate: 
	go build -o maintemplate cmd/main.go
	chmod +x ./maintemplate

## Local server
serve-maintemplate: build-maintemplate
	cd ../client/ && flutter config --enable-web && flutter build web
	./maintemplate -local -dir ../client/build/web

## Cleanup
clean:
	rm -rf ./maintemplate
