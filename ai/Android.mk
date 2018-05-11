#
# Copyright (C) 2018 The Android Open-Source Project
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

ifeq ($(TARGET_USE_HIAI),true)

LOCAL_PATH := $(call my-dir)

#################################################
#build prebuilt hiaiserver
#################################################
include $(CLEAR_VARS)
LOCAL_MODULE := hiaiserver
LOCAL_INIT_RC := hiaiserver.rc
LOCAL_SRC_FILES_64 := bin/hiaiserver
LOCAL_MULTILIB := 64
LOCAL_MODULE_CLASS := EXECUTABLES
LOCAL_MODULE_TAGS := optional
LOCAL_PROPRIETARY_MODULE := true
include $(BUILD_PREBUILT)

#################################################
#build prebuilt libai_client so
#################################################
include $(CLEAR_VARS)
LOCAL_MODULE := libai_client
LOCAL_SRC_FILES_32 := lib/libai_client.so
LOCAL_SRC_FILES_64 := lib64/libai_client.so
LOCAL_MULTILIB := both
LOCAL_MODULE_CLASS := SHARED_LIBRARIES
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_SUFFIX := .so
LOCAL_PROPRIETARY_MODULE := true
include $(BUILD_PREBUILT)

#################################################
#build prebuilt vendor.huawei.hardware.ai@1.0 so
#################################################
include $(CLEAR_VARS)
LOCAL_MODULE := vendor.huawei.hardware.ai@1.0
LOCAL_SRC_FILES_32 := lib/vendor.huawei.hardware.ai@1.0.so
LOCAL_SRC_FILES_64 := lib64/vendor.huawei.hardware.ai@1.0.so
LOCAL_MULTILIB := both
LOCAL_MODULE_CLASS := SHARED_LIBRARIES
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_SUFFIX := .so
LOCAL_PROPRIETARY_MODULE := true
include $(BUILD_PREBUILT)

#################################################
#build prebuilt vendor.huawei.hardware.ai@1.1 so
#################################################
include $(CLEAR_VARS)
LOCAL_MODULE := vendor.huawei.hardware.ai@1.1
LOCAL_SRC_FILES_32 := lib/vendor.huawei.hardware.ai@1.1.so
LOCAL_SRC_FILES_64 := lib64/vendor.huawei.hardware.ai@1.1.so
LOCAL_MULTILIB := both
LOCAL_MODULE_CLASS := SHARED_LIBRARIES
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_SUFFIX := .so
LOCAL_PROPRIETARY_MODULE := true
include $(BUILD_PREBUILT)

#################################################
#build prebuilt libc_secshared so
#################################################
include $(CLEAR_VARS)
LOCAL_MODULE := libc_secshared
LOCAL_SRC_FILES_32 := lib/libc_secshared.so
LOCAL_SRC_FILES_64 := lib64/libc_secshared.so
LOCAL_MULTILIB := both
LOCAL_MODULE_CLASS := SHARED_LIBRARIES
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_SUFFIX := .so
LOCAL_PROPRIETARY_MODULE := true
include $(BUILD_PREBUILT)

include $(call all-makefiles-under,$(LOCAL_PATH))
endif
