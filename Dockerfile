##
## Debian base layer with python
##

# hadolint global ignore=DL3008
FROM docker.io/library/debian:13.4-slim@sha256:e02d6676e4dc2633fe045d6435d6039396736055976136f71ee5b77498f96fcf AS debian
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
RUN pip install yamllint==v1.38.0 \
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
