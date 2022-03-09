IMAGE_REPO:=enoniccloud/vector
IMAGE_VERSION:=$(shell git tag --points-at HEAD)
IMAGE_TAG:=${IMAGE_REPO}:${IMAGE_VERSION:-dev}

docker-build:
	docker build -t ${IMAGE_TAG} .

docker-push: docker-build
	echo docker push ${IMAGE_TAG}