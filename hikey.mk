#
# Inherit the full_base and device configurations
$(call inherit-product, device/linaro/hikey/device.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base.mk)

#
# Overrides
PRODUCT_NAME := hikey
PRODUCT_DEVICE := hikey
