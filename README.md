# Introduction

Alpine Linux is great, but not if you have to install it on an embedded system with only a serial console.

Additionally, you may want some tools like `nvme` and `efibootmgr` present to do system management, which are not included by default.

This repository contains a `Dockerfile` to easily and quickly generate an Alpine installation ISO for this use case.

**Note**: `mkimg` has set `syslinux` to output onto the second serial port (port 1, `0x2F8`) not the first one.

# Building

```
docker build -f Dockerfile --build-arg ALPINE_VERSION=3.17 -t alpine-serial-iso-builder .
```

# Generating the ISO

```
docker run -it -v $(pwd)/out:/out alpine-serial-iso-builder
```

# Using the ISO

The generated installer ISO is an ISO9660/MBR hybrid, so you can either test it using qemu:
```
qemu-system-x86_64 -enable-kvm -m 2048 -cdrom out/alpine-serialtty-${ALPINE_VERSION}-x86_64.iso
```

or `dd` the image to bootable media and boot your baremetal target with it.

