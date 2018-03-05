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

PRODUCT_COPY_FILES +=	$(TARGET_PREBUILT_KERNEL):kernel \
			$(TARGET_PREBUILT_DTB):kirin970-hikey970.dtb

PRODUCT_COPY_FILES +=	$(LOCAL_PATH)/fstab.hikey970:root/fstab.hikey970 \
			device/linaro/hikey/init.common.rc:root/init.hikey970.rc \
			device/linaro/hikey/init.hikey970.power.rc:root/init.hikey970.power.rc \
			device/linaro/hikey/init.common.usb.rc:root/init.hikey970.usb.rc \
			device/linaro/hikey/ueventd.common.rc:root/ueventd.hikey970.rc \
			device/linaro/hikey/common.kl:system/usr/keylayout/hikey970.kl \
			frameworks/native/data/etc/android.hardware.vulkan.level-0.xml:system/etc/permissions/android.hardware.vulkan.level.xml \
			frameworks/native/data/etc/android.hardware.vulkan.version-1_0_3.xml:system/etc/permissions/android.hardware.vulkan.version.xml

# Copy hifi firmware
PRODUCT_COPY_FILES += \
	device/linaro/hikey/hifi/firmware/hifi-hikey970.img:system/etc/firmware/hifi/hifi.img


# Build HiKey970 HDMI audio HAL. Experimental only may not work. FIXME
PRODUCT_PACKAGES += audio.primary.hikey970

PRODUCT_PACKAGES += gralloc.hikey970

PRODUCT_PACKAGES += power.hikey970

PRODUCT_DEFAULT_PROPERTY_OVERRIDES += sys.usb.controller=ff100000.dwc3

# Include vendor binaries
$(call inherit-product-if-exists, vendor/linaro/hikey970/device-vendor.mk)

# GPU drivers
OVERRIDE_RS_DRIVER := libRSDriverArm.so

PRODUCT_PACKAGES += android.hardware.renderscript@1.0-impl

PRODUCT_COPY_FILES += \
    device/linaro/hikey/hikey970/hisilicon_libs/lib/libGLES_mali.so:system/vendor/lib/egl/libGLES_mali.so \
    device/linaro/hikey/hikey970/hisilicon_libs/lib64/libGLES_mali.so:system/vendor/lib64/egl/libGLES_mali.so \
    device/linaro/hikey/hikey970/hisilicon_libs/lib/libGLES_mali.so:system/vendor/lib/hw/vulkan.hikey970.so \
    device/linaro/hikey/hikey970/hisilicon_libs/lib64/libGLES_mali.so:system/vendor/lib64/hw/vulkan.hikey970.so \
    device/linaro/hikey/hikey970/hisilicon_libs/lib/libGLES_mali.so:system/vendor/lib/libOpenCL.so \
    device/linaro/hikey/hikey970/hisilicon_libs/lib64/libGLES_mali.so:system/vendor/lib64/libOpenCL.so \
    device/linaro/hikey/hikey970/hisilicon_libs/lib/libRSDriverArm.so:system/vendor/lib/libRSDriverArm.so \
    device/linaro/hikey/hikey970/hisilicon_libs/lib64/libRSDriverArm.so:system/vendor/lib64/libRSDriverArm.so \
    device/linaro/hikey/hikey970/hisilicon_libs/lib/libmalicore.bc:system/vendor/lib/libmalicore.bc \
    device/linaro/hikey/hikey970/hisilicon_libs/lib64/libmalicore.bc:system/vendor/lib64/libmalicore.bc \
    device/linaro/hikey/hikey970/hisilicon_libs/lib64/libbccArm.so:system/vendor/lib64/libbccArm.so \
    device/linaro/hikey/hikey970/hisilicon_libs/lib/gralloc.hikey970.so:system/vendor/lib/hw/gralloc.hikey970.so \
    device/linaro/hikey/hikey970/hisilicon_libs/lib64/gralloc.hikey970.so:system/vendor/lib64/hw/gralloc.hikey970.so \
    device/linaro/hikey/hikey970/hisilicon_libs/lib/libc_secshared.so:system/vendor/lib/libc_secshared.so \
    device/linaro/hikey/hikey970/hisilicon_libs/lib64/libc_secshared.so:system/vendor/lib64/libc_secshared.so \
    device/linaro/hikey/hikey970/hisilicon_libs/lib/vendor.huawei.hardware.graphics.gpucommon@1.0.so:system/vendor/lib/vendor.huawei.hardware.graphics.gpucommon@1.0.so \
    device/linaro/hikey/hikey970/hisilicon_libs/lib64/vendor.huawei.hardware.graphics.gpucommon@1.0.so:system/vendor/lib64/vendor.huawei.hardware.graphics.gpucommon@1.0.so \
    device/linaro/hikey/hikey970/hisilicon_libs/lib/vendor.huawei.hardware.graphics.mediacomm@2.0.so:system/vendor/lib/vendor.huawei.hardware.graphics.mediacomm@2.0.so \
    device/linaro/hikey/hikey970/hisilicon_libs/lib64/vendor.huawei.hardware.graphics.mediacomm@2.0.so:system/vendor/lib64/vendor.huawei.hardware.graphics.mediacomm@2.0.so \
    device/linaro/hikey/hikey970/hisilicon_libs/lib/libgpucommon_vendor_client.so:system/vendor/lib/libgpucommon_vendor_client.so \
    device/linaro/hikey/hikey970/hisilicon_libs/lib64/libgpucommon_vendor_client.so:system/vendor/lib64/libgpucommon_vendor_client.so \
    device/linaro/hikey/hikey970/hisilicon_libs/lib/libhiion.so:system/vendor/lib/libhiion.so \
    device/linaro/hikey/hikey970/hisilicon_libs/lib64/libhiion.so:system/vendor/lib64/libhiion.so \
    device/linaro/hikey/hikey970/hisilicon_libs/lib/libmediacomm@2.0-client.so:system/vendor/lib/libmediacomm@2.0-client.so \
    device/linaro/hikey/hikey970/hisilicon_libs/lib64/libmediacomm@2.0-client.so:system/vendor/lib64/libmediacomm@2.0-client.so \
    device/linaro/hikey/hikey970/hisilicon_libs/lib/libOMX.hisi.media.common.so:system/vendor/lib/libOMX.hisi.media.common.so \
    device/linaro/hikey/hikey970/hisilicon_libs/lib64/libOMX.hisi.media.common.so:system/vendor/lib64/libOMX.hisi.media.common.so \
    device/linaro/hikey/hikey970/hisilicon_libs/lib/libOMX.hisi.vdec.core.so:system/vendor/lib/libOMX.hisi.vdec.core.so \
    device/linaro/hikey/hikey970/hisilicon_libs/lib64/libOMX.hisi.vdec.core.so:system/vendor/lib64/libOMX.hisi.vdec.core.so \
    device/linaro/hikey/hikey970/hisilicon_libs/lib/libOMX.hisi.video.decoder.so:system/vendor/lib/libOMX.hisi.video.decoder.so \
    device/linaro/hikey/hikey970/hisilicon_libs/lib64/libOMX.hisi.video.decoder.so:system/vendor/lib64/libOMX.hisi.video.decoder.so \
    device/linaro/hikey/hikey970/hisilicon_libs/lib/libOMX.hisi.video.encoder.so:system/vendor/lib/libOMX.hisi.video.encoder.so \
    device/linaro/hikey/hikey970/hisilicon_libs/lib64/libOMX.hisi.video.encoder.so:system/vendor/lib64/libOMX.hisi.video.encoder.so \
    device/linaro/hikey/hikey970/hisilicon_libs/lib/libOMX_Core.so:system/vendor/lib/libOMX_Core.so \
    device/linaro/hikey/hikey970/hisilicon_libs/lib64/libOMX_Core.so:system/vendor/lib64/libOMX_Core.so \
    device/linaro/hikey/hikey970/hisilicon_libs/lib/libstagefrighthw.so:system/vendor/lib/libstagefrighthw.so \
    device/linaro/hikey/hikey970/hisilicon_libs/lib64/libstagefrighthw.so:system/vendor/lib64/libstagefrighthw.so \
    device/linaro/hikey/hikey970/hisilicon_libs/lib/libteec.so:system/vendor/lib/libteec.so \
    device/linaro/hikey/hikey970/hisilicon_libs/lib64/libteec.so:system/vendor/lib64/libteec.so
