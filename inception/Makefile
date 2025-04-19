DOCKER_COMPOSE=docker-compose

fix-perms:
	sudo chmod 644 nginx/ssl/privkey.pem
	chmod +x php/entrypoint.sh

build: fix-perms
	$(DOCKER_COMPOSE) build

up:
	$(DOCKER_COMPOSE) up  -d

start: build  up

down:
	$(DOCKER_COMPOSE) down

logs:
	$(DOCKER_COMPOSE) logs -f

clean:
	$(DOCKER_COMPOSE) down -v --remove-orphans
	rm -f nginx/ssl/cert.pem nginx/ssl/privkey.pem
