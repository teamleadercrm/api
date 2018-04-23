PWD = $(shell pwd)

all: lint build preview

node_modules: package.json
	docker run -it --init --rm -v $(PWD):/code -w /code node npm install

lint: node_modules
	docker run -it --init --rm -v $(PWD):/code -w /code node npm run lint

build: src node_modules
	docker run -it --init --rm -v $(PWD):/code -w /code node npm run build

preview: apiary.html node_modules
	docker run -it --init --rm -v $(PWD):/code -w /code apiaryio/client preview --path=/code/apiary.apib --output=/code/apiary.html

watch: node_modules
	docker run -it --init --rm -v $(PWD):/code -w /code node npm run watch
