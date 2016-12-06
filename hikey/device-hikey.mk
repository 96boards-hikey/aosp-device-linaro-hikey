#
# Copyright (C) 2011 The Android Open-Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

ifeq ($(TARGET_PREBUILT_KERNEL),)
LOCAL_KERNEL := device/linaro/hikey-kernel/Image-dtb
LOCAL_DTB := device/linaro/hikey-kernel/hi6220-hikey.dtb
LOCAL_FSTAB := fstab.hikey
else
LOCAL_KERNEL := $(TARGET_PREBUILT_KERNEL)
LOCAL_DTB := $(TARGET_PREBUILT_DTB)
LOCAL_FSTAB := $(TARGET_FSTAB)
endif

PRODUCT_COPY_FILES +=   $(LOCAL_KERNEL):kernel \
                        $(LOCAL_DTB):hi6220-hikey.dtb \
			$(LOCAL_PATH)/$(LOCAL_FSTAB):root/fstab.hikey \
			device/linaro/hikey/init.common.rc:root/init.hikey.rc \
			device/linaro/hikey/init.common.usb.rc:root/init.hikey.usb.rc \
			device/linaro/hikey/ueventd.common.rc:root/ueventd.hikey.rc \
			device/linaro/hikey/common.kl:system/usr/keylayout/hikey.kl

# Build HiKey HDMI audio HAL
PRODUCT_PACKAGES += audio.primary.hikey

# Include USB speed switch App
PRODUCT_PACKAGES += UsbSpeedSwitch

# Build libion
PRODUCT_PACKAGES += libion

# Build gralloc for hikey
PRODUCT_PACKAGES += gralloc.hikey

# PowerHAL
PRODUCT_PACKAGES += power.hikey

# Include vendor binaries
$(call inherit-product-if-exists, vendor/linaro/hikey/device-vendor.mk)
