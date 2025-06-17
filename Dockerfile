##
## Debian base layer with python
##

# hadolint global ignore=DL3008
FROM docker.io/library/debian:12.11-slim@sha256:e5865e6858dacc255bead044a7f2d0ad8c362433cfaa5acefb670c1edf54dfef AS debian
RUN rm -rf /etc/*- /tmp/* /var/cache/* /var/log/* /var/lib/dpkg/*-old /var/lib/dpkg/status
RUN --mount=type=cache,target=/var/lib/apt/lists,sharing=locked \
	apt-get -qq update && \
	apt-get -qq install --yes --no-install-recommends python3-minimal libpython3-stdlib && \
	rm -rf /etc/*- /var/lib/dpkg/*-old /var/lib/dpkg/status /var/cache/* /var/log/*

##
## Download yamllint
##

FROM debian AS build
RUN --mount=type=cache,target=/var/lib/apt/lists,sharing=locked \
	apt-get -qq update && \
	apt-get -qq install --yes --no-install-recommends python3-pip && \
	rm -rf /etc/*- /var/lib/dpkg/*-old /var/lib/dpkg/status /var/cache/* /var/log/*
RUN pip install yamllint==v1.37.1 \
		--root=/build \
		--root-user-action=ignore \
		--break-system-packages \
		--no-cache-dir \
		--no-warn-script-location

##
## Final stage
##

FROM debian
COPY --link --chown=0:0 --from=build /build /
COPY --link --chown=0:0 --chmod=555 entrypoint.sh /usr/local/bin/entrypoint.sh
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
USER 1000:1000
