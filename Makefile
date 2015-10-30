.PHONY: all build vendor release

GIT_SHA := $(shell git rev-parse --short HEAD)

all: build

build:
	docker build -t goodeggs/cedar .

release:
	( git diff --quiet && git diff --cached --quiet ) || ( echo "checkout must be clean"; false )
	docker build -t goodeggs/cedar:$(GIT_SHA) .
	docker push goodeggs/cedar:$(GIT_SHA)
	docker tag -f goodeggs/cedar:$(GIT_SHA) goodeggs/cedar:latest
	docker push goodeggs/cedar:latest

vendor:
	@rm -rf buildkit
	@mkdir -p buildkit
	@cd buildkit && curl https://buildkits.herokuapp.com/buildkit/default.tgz | tar xz

