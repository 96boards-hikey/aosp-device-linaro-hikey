REALTOP=$(realpath $(TOP))
boot_fatimage: bootimage
	dd if=/dev/zero of=$(PRODUCT_OUT)/boot_fat.uefi.img bs=512 count=98304
	mkfs.fat -n "BOOT IMG" $(PRODUCT_OUT)/boot_fat.uefi.img
	mcopy -i $(PRODUCT_OUT)/boot_fat.uefi.img $(PRODUCT_OUT)/kernel ::Image
	mcopy -i $(PRODUCT_OUT)/boot_fat.uefi.img $(PRODUCT_OUT)/hi6220-hikey.dtb ::hi6220-hikey.dtb
	mcopy -s -i $(PRODUCT_OUT)/boot_fat.uefi.img device/linaro/hikey/bootloader/* ::
	mcopy -i $(PRODUCT_OUT)/boot_fat.uefi.img  $(PRODUCT_OUT)/ramdisk.img ::ramdisk.img


droidcore: boot_fatimage
