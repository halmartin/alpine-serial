ARG ALPINE_VERSION=3.17
FROM alpine:$ALPINE_VERSION
ARG ALPINE_VERSION

RUN apk update && apk add --no-cache alpine-sdk build-base apk-tools \
  alpine-conf busybox fakeroot syslinux xorriso squashfs-tools sudo \
  mtools dosfstools grub-efi git

RUN abuild-keygen -n -i -a -q

WORKDIR /root
RUN touch /root/.default_boot_services
RUN git clone --depth=1 https://gitlab.alpinelinux.org/alpine/aports.git

COPY --chmod=0775 mkimg.serialtty.sh /root/aports/scripts/
COPY --chmod=0755 genapkovl-mkimgoverlay.sh /root/aports/scripts/

WORKDIR /root/aports/scripts
# you're supposed to be able to use args
# at build time, but this doesn't play nice
# with the CMD so whatever
CMD ["./mkimage.sh", "--arch", "x86_64", "--outdir", "/out", "--profile", "serialtty", "--tag", "3.17", "--repository", "http://dl-cdn.alpinelinux.org/alpine/v3.17/main", "--repository", "http://dl-cdn.alpinelinux.org/alpine/v3.17/community"]
