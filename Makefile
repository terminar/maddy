IMAGE_NAME ?= maddy
IMAGE_TAG  ?= $(shell git describe --tags --always --dirty 2>/dev/null || echo "dev")
REGISTRY=docker-registry01.fintus.de/repository/
FULL_IMAGE  = $(REGISTRY)$(IMAGE_NAME):$(IMAGE_TAG)
LATEST_IMAGE = $(REGISTRY)$(IMAGE_NAME):latest
PLATFORM   ?= linux/amd64
BUILD_TAGS ?=

.PHONY: docker-build docker-push docker-clean help

help:
	@echo "Targets:"
	@echo "  docker-build   Build the Docker image (IMAGE_NAME, IMAGE_TAG, PLATFORM, BUILD_TAGS)"
	@echo "  docker-push    Push the image to a registry"
	@echo "  docker-clean   Remove the local image"

docker-build:
	docker buildx build \
		--platform $(PLATFORM) \
		--build-arg ADDITIONAL_BUILD_TAGS="$(BUILD_TAGS)" \
		--tag $(FULL_IMAGE) \
		--tag $(LATEST_IMAGE) \
		--load \
		.
	@echo "Built: $(FULL_IMAGE) $(LATEST_IMAGE)"

docker-push:
	docker push $(FULL_IMAGE)
	docker push $(LATEST_IMAGE)

docker-clean:
	docker rmi $(FULL_IMAGE) $(LATEST_IMAGE)
