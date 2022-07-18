include .env

DOCKLE_LATEST=`(curl --silent "https://api.github.com/repos/goodwithtech/dockle/releases/latest" | grep '"tag_name":' | sed -E 's/.*"v([^"]+)".*/\1/')`

build:
	docker build . -t sangheon/sandbox:$(VERSION) --no-cache

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

lint:
	docker run --rm -v /var/run/docker.sock:/var/run/docker.sock goodwithtech/dockle:v${DOCKLE_LATEST} sangheon/sandbox:$(VERSION)
