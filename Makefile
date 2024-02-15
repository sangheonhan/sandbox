include .env

USER_ID=$(shell id -u)
GROUP_ID=$(shell id -g)

DOCKLE_LATEST=`(curl --silent "https://api.github.com/repos/goodwithtech/dockle/releases/latest" | grep '"tag_name":' | sed -E 's/.*"v([^"]+)".*/\1/')`

build:
	DOCKER_BUILDKIT=1 docker buildx build --push --platform linux/arm64/v8,linux/amd64 -t sangheon/sandbox:$(VERSION) --no-cache .

init:
	docker buildx rm multiarch-builder
	docker buildx inspect --bootstrap
	docker buildx create --name multiarch-builder --use
	docker buildx use multiarch-builder

push:
	docker push sangheon/sandbox:$(VERSION)

pull:
	docker pull sangheon/sandbox:$(VERSION)

clean:
	-docker-compose down --rmi all
	-docker rm sangheon/sandbox_$(VERSION)
	-docker rmi sangheon/sandbox:$(VERSION)

shell:
	docker exec -it -u app sandbox_$(VERSION) /bin/zsh

start:
	docker run -itd --rm --name sandbox_$(VERSION) -e HOST_UID=$(USER_ID) -e HOST_GID=$(GROUP_ID) sangheon/sandbox:$(VERSION)

stop:
	docker stop sandbox_$(VERSION)

sandbox:
	docker run --interactive --tty --rm --name sandbox_$(VERSION) -e HOST_UID=$(USER_ID) -e HOST_GID=$(GROUP_ID) --volume "$(PWD)":/sandbox/ sangheon/sandbox:$(VERSION) /bin/zsh

lint:
	docker run --rm -v /var/run/docker.sock:/var/run/docker.sock goodwithtech/dockle:v${DOCKLE_LATEST} sangheon/sandbox:$(VERSION)
