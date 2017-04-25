# Copyright 2016 The Android Open Source Project
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

# Linaro blob(s) necessary for Hikey hardware
PRODUCT_COPY_FILES := \
    vendor/linaro/hikey960/hisilicon/proprietary/lib64/libhilog.so:system/lib64/libhilog.so \
    vendor/linaro/hikey960/hisilicon/proprietary/libhilog.so:system/lib/libhilog.so \
    vendor/linaro/hikey960/hisilicon/proprietary/lib64/libion.so:system/lib64/libion.so \
    vendor/linaro/hikey960/hisilicon/proprietary/libion.so:system/lib/libion.so \
    vendor/linaro/hikey960/hisilicon/proprietary/lib64/gralloc.hikey960.so:system/lib64/hw/gralloc.hikey960.so \
    vendor/linaro/hikey960/hisilicon/proprietary/gralloc.hikey960.so:system/lib/hw/gralloc.hikey960.so \
    vendor/linaro/hikey960/hisilicon/proprietary/lib64/hwcomposer.hikey960.so:system/vendor/lib64/hwcomposer.hikey960.so \
    vendor/linaro/hikey960/hisilicon/proprietary/hwcomposer.hikey960.so:system/vendor/lib/hwcomposer.hikey960.so \
    vendor/linaro/hikey960/hisilicon/proprietary/lib64/libhiion.so:system/vendor/lib64/libhiion.so \
    vendor/linaro/hikey960/hisilicon/proprietary/libhiion.so:system/vendor/lib/libhiion.so
