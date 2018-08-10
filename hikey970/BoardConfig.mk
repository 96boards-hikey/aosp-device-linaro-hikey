include device/linaro/hikey/BoardConfigCommon.mk

TARGET_BOOTLOADER_BOARD_NAME := hikey970
TARGET_BOARD_PLATFORM := hikey970

TARGET_CPU_VARIANT := cortex-a73
TARGET_2ND_CPU_VARIANT := cortex-a73

TARGET_NO_DTIMAGE := false

BOARD_KERNEL_CMDLINE := androidboot.hardware=hikey970 console=ttyFIQ0 androidboot.console=ttyFIQ0
BOARD_KERNEL_CMDLINE += firmware_class.path=/system/etc/firmware loglevel=15
BOARD_KERNEL_CMDLINE += androidboot.selinux=permissive
ifneq ($(TARGET_SENSOR_MEZZANINE),)
BOARD_KERNEL_CMDLINE += overlay_mgr.overlay_dt_entry=hardware_cfg_$(TARGET_SENSOR_MEZZANINE)
endif
BOARD_MKBOOTIMG_ARGS := --base 0x0 --tags_offset 0x07a00000 --kernel_offset 0x00080000 --ramdisk_offset 0x07c00000

BOARD_SYSTEMIMAGE_PARTITION_SIZE := 4915724288  # 4688MB
BOARD_USERDATAIMAGE_PARTITION_SIZE := 57768165376  # 53.8GB
BOARD_CACHEIMAGE_PARTITION_SIZE := 268435456       # 256MB
BOARD_FLASH_BLOCK_SIZE := 512
