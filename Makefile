PREFIX := $(shell pwd)
VERSION := $(shell cat "$(PREFIX)/VERSION")
REPO_NAME = eichptc/heroku

CLI_BUILD_IMAGE = $(REPO_NAME):cli-latest
CLI_VERSION_IMAGE = $(REPO_NAME):cli-$(VERSION)

SRC_BUILD_IMAGE = $(REPO_NAME):src-latest
SRC_VERSION_IMAGE = $(REPO_NAME):src-$(VERSION)

ifneq ($(https_proxy),)
https_proxy_arg := --build-arg https_proxy=$(https_proxy)
endif
ifneq ($(http_proxy),)
http_proxy_arg := --build-arg http_proxy=$(http_proxy)
endif

BUILD_ARGS := $(https_proxy_arg) $(http_proxy_arg)

default: build

tag-version: build-cli build-src
	docker tag $(CLI_BUILD_IMAGE) $(CLI_VERSION_IMAGE)
	docker tag $(SRC_BUILD_IMAGE) $(SRC_VERSION_IMAGE)

build-cli:
	docker build $(BUILD_ARGS) --build-arg BUILD_HEROKU_IMAGE=$(CLI_BUILD_IMAGE) -f $(PREFIX)/Dockerfile.cli --tag $(CLI_BUILD_IMAGE) .

build-src:
	docker build $(BUILD_ARGS) -f $(PREFIX)/Dockerfile --tag $(SRC_BUILD_IMAGE) .

alias-cli:
	@echo "# run the command : eval \"\$$(docker run -it --rm $(CLI_BUILD_IMAGE) alias|dos2unix)\""

alias-src:
	@echo "# run the command : eval \"\$$(docker run -it --rm -e HEROKU_IMAGE=$(SRC_BUILD_IMAGE) $(SRC_BUILD_IMAGE) alias|dos2unix)\""

build: tag-version

