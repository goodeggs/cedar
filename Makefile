all: build

build:
	docker build -t goodeggs/cedar .

vendor:
	@rm -rf buildkit
	@mkdir -p buildkit
	@cd buildkit && curl https://buildkits.herokuapp.com/buildkit/default.tgz | tar xz
