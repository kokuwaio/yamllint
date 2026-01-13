##
## Debian base layer with python
##

# hadolint global ignore=DL3008
FROM docker.io/library/debian:13.3-slim@sha256:77ba0164de17b88dd0bf6cdc8f65569e6e5fa6cd256562998b62553134a00ef0 AS debian
RUN --mount=type=cache,target=/var/lib/apt/lists,sharing=locked \
	--mount=type=cache,target=/var/cache \
	--mount=type=tmpfs,target=/var/lib/dpkg \
	--mount=type=tmpfs,target=/var/log \
	apt-get -qq update && \
	apt-get -qq install --yes --no-install-recommends python3-minimal libpython3-stdlib

##
## Download yamllint
##

FROM debian AS build
RUN --mount=type=cache,target=/var/lib/apt/lists,sharing=locked \
	--mount=type=cache,target=/var/cache \
	--mount=type=tmpfs,target=/var/lib/dpkg \
	--mount=type=tmpfs,target=/var/log \
	apt-get -qq update && \
	apt-get -qq install --yes --no-install-recommends python3-pip

ARG PIP_INDEX_URL
ARG PIP_TRUSTED_HOST
RUN pip install yamllint==v1.37.1 \
		--root=/build \
		--root-user-action=ignore \
		--break-system-packages \
		--no-warn-script-location \
		--no-cache-dir

##
## Final stage
##

FROM debian
COPY --link --from=build /build /
COPY --link --chmod=555 entrypoint.sh /usr/local/bin/entrypoint.sh
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
USER 1000:1000
