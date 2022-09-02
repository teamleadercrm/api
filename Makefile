PWD = $(shell pwd)

all: build lint

node_modules: package.json
	docker run -it --init --rm -v $(PWD):/code -w /code node:9 npm install

lint: node_modules
	docker run -it --init --rm -v $(PWD):/code -w /code node:9 npm run lint

build: src node_modules
	docker run -it --init --rm -v $(PWD):/code -w /code node:9 npm run build

preview: build
	docker run -it --init --rm -v $(PWD):/code -w /code apiaryio/client preview --path=/code/apiary.apib --output=/code/apiary.html && \
    echo "\nView documentation at file://$(PWD)/apiary.html"

watch: node_modules
	docker run -it --init --rm -v $(PWD):/code -w /code node:9 npm run watch

yamllint:
		docker run --rm -ti -v $(shell pwd):/api -w /api/ci teamleader/yamllint:latest . -d .yamllint

fly-validate:
		docker run --rm -ti -v $(shell pwd):/api -w /api/ci teamleader/concourse-fly:6.2

set-pipeline:
		fly -t tl set-pipeline -p api -c ci/pipeline.yaml -l ci/common-vars.yaml
