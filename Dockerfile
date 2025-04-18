##
## Debian base layer with python
##

FROM docker.io/library/debian:12.10-slim@sha256:b1211f6d19afd012477bd34fdcabb6b663d680e0f4b0537da6e6b0fd057a3ec3 AS debian
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
RUN pip install yamllint==1.37.0 \
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
