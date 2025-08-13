##
## Debian base layer with python
##

# hadolint global ignore=DL3008
FROM docker.io/library/debian:13.0-slim@sha256:c85a2732e97694ea77237c61304b3bb410e0e961dd6ee945997a06c788c545bb AS debian
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
