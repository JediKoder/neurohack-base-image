VERSION=2016.12
IMAGE_NAME=neurohack-base:$(VERSION)
IMAGE_NAME_JUPYTER=neurohack-jupyter:$(VERSION)
ORGANIZATION=yandexdataschool

build_base: Dockerfile
	docker build -t $(IMAGE_NAME) .

tag_base: build_base
	docker tag $(IMAGE_NAME) $(ORGANIZATION)/$(IMAGE_NAME)

login:
	docker login -e="$(DOCKER_EMAIL)" -u="$(DOCKER_USERNAME)" -p="$(DOCKER_PASSWORD)"

push_base: build_base tag_base login
	docker push $(ORGANIZATION)/$(IMAGE_NAME)

build_jupyter: Dockerfile-jupyter tag_base
	docker build -t $(IMAGE_NAME_JUPYTER) -f Dockerfile-jupyter .

tag_jupyter: build_jupyter
	docker tag $(IMAGE_NAME_JUPYTER) $(ORGANIZATION)/$(IMAGE_NAME_JUPYTER)

push_jupyter: build_jupyter tag_jupyter login
	docker push $(ORGANIZATION)/$(IMAGE_NAME_JUPYTER)

build: build_base build_jupyter ;

test:
	docker run $(IMAGE_NAME_JUPYTER) /bin/bash -c "source activate py3_env && python --version && source activate py2_env && python --version && source activate r_env && R --version"

push: push_base push_jupyter ;
