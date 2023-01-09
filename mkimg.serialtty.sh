profile_serialtty() {
        profile_standard
        kernel_cmdline="unionfs_size=512M console=tty0 console=ttyS0,115200 console=ttyS1,115200"
        syslinux_serial="${PORT:=1} ${SPEED:=115200}"
        kernel_addons=""
        apks="$apks nvme-cli dmidecode pciutils
                lvm2 mdadm mkinitfs mtools usbutils
                parted rsync sfdisk syslinux util-linux
                dosfstools efibootmgr cryptsetup
                "
        local _k _a
        #for _k in $kernel_flavors; do
        #        apks="$apks linux-$_k"
        #        for _a in $kernel_addons; do
        #                apks="$apks $_a-$_k"
        #        done
        #done
        #apks="$apks linux-firmware"
        apkovl="genapkovl-mkimgoverlay.sh"
}
