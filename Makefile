
IMAGE_NAME="colomoto/colomoto-docker-base:$(TAG)"
LIST=installed-packages/$(TAG).txt

.PHONY: installed-packages
installed-packages:
	docker run --rm $(IMAGE_NAME) bash -c "echo APT; apt list --installed; echo CONDA; conda list" > $(LIST)

