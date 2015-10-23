REALTOP=$(realpath $(TOP))
boot_fatimage: bootimage
	dd if=/dev/zero of=$(PRODUCT_OUT)/boot_fat.uefi.img bs=512 count=98304
	mkfs.fat -n "BOOT IMG" $(PRODUCT_OUT)/boot_fat.uefi.img
	mkdir -p $(PRODUCT_OUT)/boot_tmp && sudo mount -o umask=000,loop,rw,sync $(PRODUCT_OUT)/boot_fat.uefi.img $(PRODUCT_OUT)/boot_tmp
	cp $(PRODUCT_OUT)/kernel $(PRODUCT_OUT)/boot_tmp/Image
	cp $(PRODUCT_OUT)/hi6220-hikey.dtb $(PRODUCT_OUT)/boot_tmp/hi6220-hikey.dtb
	cp -r device/linaro/hikey/bootloader/* $(PRODUCT_OUT)/boot_tmp/
	cp $(PRODUCT_OUT)/ramdisk.img $(PRODUCT_OUT)/boot_tmp/
	mkdir -p $(PRODUCT_OUT)/boot_tmp/grub/
	sync
	sudo umount -f $(PRODUCT_OUT)/boot_fat.uefi.img


droidcore: boot_fatimage
