PREFIX := $(shell pwd)

ifneq ($(https_proxy),)
https_proxy_arg := --build-arg https_proxy=$(https_proxy)
endif
ifneq ($(http_proxy),)
http_proxy_arg := --build-arg http_proxy=$(http_proxy)
endif

BUILD_ARGS := $(https_proxy_arg) $(http_proxy_arg)

build-cli:
	docker build $(BUILD_ARGS) -f $(PREFIX)/Dockerfile.cli --tag heroku .

alias-cli:
	@echo "# run the command : eval \"\$$(docker run -it --rm heroku alias|dos2unix)\""
