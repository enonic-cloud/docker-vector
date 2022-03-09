IMAGE_REPO:=enoniccloud/vector

ifneq ("$(shell git tag --points-at HEAD)", "")
IMAGE_VERSION:=$(shell git tag --points-at HEAD)
else
IMAGE_VERSION:=dev
endif

IMAGE_TAG:=${IMAGE_REPO}:${IMAGE_VERSION}

docker-build:
	docker build -t ${IMAGE_TAG} .

docker-push: docker-build
	echo docker push ${IMAGE_TAG}
