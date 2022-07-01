VERSION=22.04

build:
	docker build . -t sangheon/sandbox:$(VERSION) --no-cache

push:
	docker tag sangheon/sandbox:$(VERSION) sangheon/sandbox:latest
	docker push sangheon/sandbox:$(VERSION)
	docker push sangheon/sandbox:latest

clean:
	-docker-compose down --rmi all
	-docker rm sangheon/sandbox
	-docker rmi sangheon/sandbox:$(VERSION)
	-docker rmi sangheon/sandbox:latest

shell:
	docker exec -it sandbox /bin/zsh

start:
	docker run -itd --rm --name sandbox sangheon/sandbox:$(VERSION)

stop:
	docker stop sandbox

up:
	docker-compose up -d

down:
	docker-compose down --rmi all
