FROM alpine:latest
MAINTAINER Brad Bishop <bradleyb@fuzziesquirrel.com>

ENV SNAPSHOT_VERSION 1.2.4

RUN mkdir /build
COPY 0001-adaptations-for-busybox-cron-and-podman.patch /build
RUN apk add --no-cache s6 zfs \
  && apk add --no-cache --virtual build-dependencies alpine-sdk \
  && wget https://github.com/zfsonlinux/zfs-auto-snapshot/archive/upstream/${SNAPSHOT_VERSION}.tar.gz \
  && tar -xzf ${SNAPSHOT_VERSION}.tar.gz \
  && cd zfs-auto-snapshot-upstream-${SNAPSHOT_VERSION} \
  && patch -p1 < /build/0001-adaptations-for-busybox-cron-and-podman.patch \
  && make PREFIX=/usr install \
  && apk del build-dependencies \
  && rm -rf /build
COPY s6 /etc/s6
COPY entrypoint.sh /
COPY scrub.sh /

ENTRYPOINT ["/entrypoint.sh"]
CMD ["s6-svscan","/etc/s6"]
