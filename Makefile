include .env

DOCKLE_LATEST=`(curl --silent "https://api.github.com/repos/goodwithtech/dockle/releases/latest" | grep '"tag_name":' | sed -E 's/.*"v([^"]+)".*/\1/')`

build:
	DOCKER_BUILDKIT=1 docker buildx build --push --platform linux/arm64/v8,linux/amd64 -t sangheon/sandbox:$(VERSION) --no-cache .

init:
	docker buildx inspect --bootstrap
	docker buildx create --name multiarch-builder --use
	docker buildx use multiarch-builder

push:
	docker push sangheon/sandbox:$(VERSION)

clean:
	-docker-compose down --rmi all
	-docker rm sangheon/sandbox_$(VERSION)
	-docker rmi sangheon/sandbox:$(VERSION)

shell:
	docker exec -it sandbox_$(VERSION) /bin/zsh

start:
	docker run -itd --rm --name sandbox_$(VERSION) sangheon/sandbox:$(VERSION)

stop:
	docker stop sandbox_$(VERSION)

up:
	docker-compose up -d

down:
	docker-compose down --rmi local

sandbox:
	docker run --interactive --tty --rm --name sandbox_$(VERSION) --volume $(PWD):/sandbox/ --entrypoint /bin/zsh sangheon/sandbox:$(VERSION)

lint:
	docker run --rm -v /var/run/docker.sock:/var/run/docker.sock goodwithtech/dockle:v${DOCKLE_LATEST} sangheon/sandbox:$(VERSION)
