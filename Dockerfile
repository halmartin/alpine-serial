ARG ALPINE_VERSION=3.17
FROM alpine:$ALPINE_VERSION
ARG ALPINE_VERSION
ARG ALPINE_ARCH=x86_64
ENV ALPINE_VERSION=$ALPINE_VERSION
ENV ALPINE_ARCH=$ALPINE_ARCH
ENV ALPINE_URI_BASE="http://dl-cdn.alpinelinux.org/alpine/v${ALPINE_VERSION}"

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

CMD ./mkimage.sh \
  --arch $ALPINE_ARCH \
  --outdir /out \
  --profile serialtty \
  --tag $ALPINE_VERSION \
  --repository ${ALPINE_URI_BASE}/main \
  --repository ${ALPINE_URI_BASE}/community

