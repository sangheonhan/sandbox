build:
	docker build . -t sandbox --no-cache

run:
	docker run -it --rm --name sandbox sandbox:latest

shell:
	docker exec -it sandbox /bin/zsh

clean:
	-docker rm sandbox
	-docker rmi sandbox:latest
