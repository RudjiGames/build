#
# Copyright 2013-2015 Milos Tosic. All rights reserved.
# License: http://www.opensource.org/licenses/BSD-2-Clause
#

LOCAL_PATH := $(call my-dir)
include $(CLEAR_VARS)
LOCAL_MODULE := @@SHORT_NAME@@-prebuilt
LOCAL_SRC_FILES := ./lib/$(TARGET_ARCH_ABI)/lib@@SHORT_NAME@@.so
LOCAL_EXPORT_C_INCLUDES := $(LOCAL_PATH)/..
include $(PREBUILT_SHARED_LIBRARY)

