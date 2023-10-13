profile_serialtty() {
        profile_standard
        PORT="${PORT:=1}"
        SPEED="${SPEED:=115200}"
        kernel_cmdline="unionfs_size=512M console=tty0 console=ttyS0,$SPEED console=ttyS1,$SPEED"
        syslinux_serial="$PORT $SPEED"
        kernel_addons=""
        apks="$apks nvme-cli dmidecode pciutils
                lvm2 mdadm mkinitfs mtools usbutils
                parted rsync sfdisk syslinux util-linux
                dosfstools efibootmgr cryptsetup debootstrap
                openssh python3 partx e2fsprogs-extra
                "
        local _k _a
        apkovl="genapkovl-mkimgoverlay.sh"
}
