#!/bin/sh -e

HOSTNAME="$1"
if [ -z "$HOSTNAME" ]; then
	echo "usage: $0 hostname"
	exit 1
fi

cleanup() {
	rm -rf "$tmp"
}

makefile() {
	OWNER="$1"
	PERMS="$2"
	FILENAME="$3"
	cat > "$FILENAME"
	chown "$OWNER" "$FILENAME"
	chmod "$PERMS" "$FILENAME"
}

rc_add() {
	mkdir -p "$tmp"/etc/runlevels/"$2"
	ln -sf /etc/init.d/"$1" "$tmp"/etc/runlevels/"$2"/"$1"
}

tmp="$(mktemp -d)"
trap cleanup EXIT

mkdir -p "$tmp"/etc
makefile root:root 0644 "$tmp"/etc/hostname <<EOF
$HOSTNAME
EOF

mkdir -p "$tmp"/etc/network
makefile root:root 0644 "$tmp"/etc/network/interfaces <<EOF
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet dhcp
EOF

mkdir -p "$tmp"/etc/apk
makefile root:root 0644 "$tmp"/etc/apk/world <<EOF
alpine-base
nvme-cli
dmidecode
pciutils
usbutils
lvm2
mdadm
efibootmgr
sfdisk
openssh
rsync
python3
debootstrap
e2fsprogs
e2fsprogs-extra
cryptsetup
partx
EOF

mkdir -p "$tmp"/etc/ssh
makefile root:root 0600 "$tmp"/etc/ssh/authorized_keys <<EOF
# put your SSH pubkeys here
EOF

makefile root:root 0644 "$tmp"/etc/ssh/sshd_config <<EOF
AuthorizedKeysFile	.ssh/authorized_keys /etc/ssh/authorized_keys
AllowTcpForwarding yes
GatewayPorts no
X11Forwarding no
Subsystem	sftp	/usr/lib/ssh/sftp-server
EOF

rc_add devfs sysinit
rc_add dmesg sysinit
rc_add mdev sysinit
rc_add hwdrivers sysinit
rc_add modloop sysinit

rc_add hwclock boot
rc_add modules boot
rc_add sysctl boot
rc_add hostname boot
rc_add bootmisc boot
rc_add syslog boot
rc_add networking boot
rc_add sshd boot

rc_add mount-ro shutdown
rc_add killprocs shutdown
rc_add savecache shutdown

tar -c -C "$tmp" etc | gzip -9n > $HOSTNAME.apkovl.tar.gz
