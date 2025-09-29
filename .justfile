# https://just.systems/man/en/

[private]
@default:
	just --list --unsorted

# Run linter.
@lint:
	docker run --rm --read-only --volume=$(pwd):$(pwd):ro --workdir=$(pwd) kokuwaio/shellcheck
	docker run --rm --read-only --volume=$(pwd):$(pwd):ro --workdir=$(pwd) kokuwaio/hadolint
	docker run --rm --read-only --volume=$(pwd):$(pwd):ro --workdir=$(pwd) kokuwaio/yamllint
	docker run --rm --read-only --volume=$(pwd):$(pwd):rw --workdir=$(pwd) kokuwaio/markdownlint --fix
	docker run --rm --read-only --volume=$(pwd):$(pwd):ro --workdir=$(pwd) kokuwaio/renovate-config-validator
	docker run --rm --read-only --volume=$(pwd):$(pwd):ro --workdir=$(pwd) woodpeckerci/woodpecker-cli lint

# Build image with local docker daemon.
@build:
	docker buildx build . --platform=linux/amd64,linux/arm64 --build-arg=PIP_INDEX_URL --build-arg=PIP_TRUSTED_HOST

# Inspect image layers with `dive`.
@dive TARGET="":
	dive build . --target={{TARGET}} --build-arg=PIP_INDEX_URL --build-arg=PIP_TRUSTED_HOST

# Test created image.
@test:
	docker buildx build . --load --tag=kokuwaio/yamllint:dev --build-arg=PIP_INDEX_URL --build-arg=PIP_TRUSTED_HOST
	docker run --rm --read-only --volume=$(pwd):$(pwd):ro --workdir=$(pwd) kokuwaio/yamllint:dev

