PWD = $(shell pwd)

all: build lint

node_modules: package.json
	docker run -it --init --rm -v $(PWD):/code -w /code node:9 npm install

lint: node_modules
	docker run -it --init --rm -v $(PWD):/code -w /code node:9 npm run lint

build: src node_modules lint
	docker run -it --init --rm -v $(PWD):/code -w /code node:9 npm run build

preview: build
	docker run -it --init --rm -v $(PWD):/code -w /code apiaryio/client preview --path=/code/apiary.apib --output=/code/apiary.html

watch: node_modules
	docker run -it --init --rm -v $(PWD):/code -w /code node:9 npm run watch
