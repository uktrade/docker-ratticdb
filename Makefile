image := groventure/ratticdb-uwsgi:1.3.1

default: build

build: Dockerfile
	docker build --rm --no-cache -t '$(image)' .
