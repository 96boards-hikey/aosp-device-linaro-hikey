############ Mkbootimg Tool Hack:null kernel build makefile ############
BUILT_NULLKERNEL_TARGET := $(PRODUCT_OUT)/nullkernel
INSTALLED_NULLKERNEL_TARGET := $(PRODUCT_OUT)/nullkernel
$(INSTALLED_NULLKERNEL_TARGET):
	$(hide)rm -rf $@
	$(hide)touch $@

############ ramdisk build makefile ############
# boot_ramdisk.img = bootheader + ramdisk.img
INTERNAL_BOOTRAMDISKIMAGE_ARGS := $(filter-out --kernel $(INSTALLED_KERNEL_TARGET), $(INTERNAL_BOOTIMAGE_ARGS))
INTERNAL_BOOTRAMDISKIMAGE_ARGS += --kernel $(INSTALLED_NULLKERNEL_TARGET)

BUILT_BOOTRAMDISKIMAGE_TARGET := $(PRODUCT_OUT)/boot_ramdisk.img
INSTALLED_BOOTRAMDISKIMAGE_TARGET := $(BUILT_BOOTRAMDISKIMAGE_TARGET)

$(INSTALLED_BOOTRAMDISKIMAGE_TARGET): $(MKBOOTIMG) $(INSTALLED_RAMDISK_TARGET) $(BUILT_NULLKERNEL_TARGET)
	$(call pretty,"Target bootramdisk image: $@")
	$(hide) $(MKBOOTIMG) $(INTERNAL_BOOTRAMDISKIMAGE_ARGS) $(INTERNAL_MKBOOTIMG_VERSION_ARGS) $(BOARD_MKBOOTIMG_ARGS) --output $@
	$(hide) $(call assert-max-file-size,$@,$(BOARD_BOOTRAMDISKIMAGE_PARTITION_SIZE))
	$(hide) echo '#!/bin/bash'      >$(PRODUCT_OUT)/pack_ramdiskimage_cmd.sh
	$(hide) echo './$(notdir $(MKBOOTIMG)) $(INTERNAL_BOOTRAMDISKIMAGE_ARGS) $(INTERNAL_MKBOOTIMG_VERSION_ARGS) $(BOARD_MKBOOTIMG_ARGS) --output $@' >> $(PRODUCT_OUT)/pack_ramdiskimage_cmd.sh

.PHONY: bootramdiskimage
bootramdiskimage: $(INSTALLED_BOOTRAMDISKIMAGE_TARGET)


############ kernel build makefile ############
# kernel.img = bootheader + kernel
INTERNAL_KERNELIMAGE_ARGS := $(filter-out --ramdisk $(INSTALLED_RAMDISK_TARGET), $(INTERNAL_BOOTIMAGE_ARGS))
BUILT_KERNELIMAGE_TARGET := $(PRODUCT_OUT)/kernel.img
INSTALLED_KERNELIMAGE_TARGET := $(BUILT_KERNELIMAGE_TARGET)
$(INSTALLED_KERNELIMAGE_TARGET): $(MKBOOTIMG) $(INSTALLED_KERNEL_TARGET)
	$(call pretty,"Target kernel image: $@")
	$(hide) $(MKBOOTIMG) $(INTERNAL_KERNELIMAGE_ARGS) $(INTERNAL_MKBOOTIMG_VERSION_ARGS) $(BOARD_MKBOOTIMG_ARGS) --output $@
	$(hide) $(call assert-max-file-size,$@,$(BOARD_KERNELIMAGE_PARTITION_SIZE))
	$(hide) echo '#!/bin/bash'      >$(PRODUCT_OUT)/pack_kernerimage_cmd.sh
	$(hide) echo './$(notdir $(MKBOOTIMG)) $(INTERNAL_KERNELIMAGE_ARGS) $(INTERNAL_MKBOOTIMG_VERSION_ARGS) $(BOARD_MKBOOTIMG_ARGS) --output $@' >> $(PRODUCT_OUT)/pack_kernerimage_cmd.sh

.PHONY: kernelimage
kernelimage: $(INSTALLED_KERNELIMAGE_TARGET)

droidcore: $(INSTALLED_BOOTRAMDISKIMAGE_TARGET)
droidcore: $(INSTALLED_KERNELIMAGE_TARGET)
