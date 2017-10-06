# Set zygote32 config before one in hikey.mk
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += ro.zygote=zygote32
PRODUCT_COPY_FILES += system/core/rootdir/init.zygote32.rc:root/init.zygote32.rc

$(call inherit-product, device/linaro/hikey/hikey.mk)

#
# Overrides
PRODUCT_NAME := hikey32
PRODUCT_DEVICE := hikey32
