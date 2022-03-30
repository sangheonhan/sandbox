build:
	docker build . -t sangheon/sandbox --no-cache

push:
	docker push sangheon/sandbox

clean:
	-docker-compose down --rmi all
	-docker rm sangheon/sandbox
	-docker rmi sangheon/sandbox:latest

shell:
	docker exec -it sandbox /bin/zsh

start:
	docker run -itd --rm --name sandbox sangheon/sandbox:latest

stop:
	docker stop sandbox

up:
	docker-compose up -d

down:
	docker-compose down --rmi all
