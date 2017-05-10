#
# Copyright (C) 2006 The Android Open Source Project
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

# Select a combo based on the compiler being used.
#
# Inputs:
#	combo_target -- prefix for final variables (HOST_ or TARGET_)
#	combo_2nd_arch_prefix -- it's defined if this is loaded for the 2nd arch.
#

# Build a target string like "linux-arm" or "darwin-x86".
combo_os_arch := $($(combo_target)OS)-$($(combo_target)$(combo_2nd_arch_prefix)ARCH)

combo_var_prefix := $(combo_2nd_arch_prefix)$(combo_target)

# Set reasonable defaults for the various variables

$(combo_var_prefix)CC := $(CC)
$(combo_var_prefix)CXX := $(CXX)
$(combo_var_prefix)AR := $(AR)
$(combo_var_prefix)STRIP := $(STRIP)

# crDroid build
ifeq ($(CRDROID_OPTIMIZATIONS),true)
    # DragonTC info
    DRAGONTC_VERSION := 5.0
    DISABLE_DTC_OPTS := false

ifeq ($(TARGET_ARCH),arm)
    TARGET_GCC_VERSION_EXP := 6.3
endif

    # Find host os
    UNAME := $(shell uname -s)
    HOST_OS := linux

    # Add extra libs for the compilers to use
    export LD_LIBRARY_PATH := $(TARGET_ARCH_LIB_PATH):$(LD_LIBRARY_PATH)
    export LIBRARY_PATH := $(TARGET_ARCH_LIB_PATH):$(LIBRARY_PATH)
else
    DRAGONTC_VERSION := 3.8
    DISABLE_DTC_OPTS := true
endif

$(combo_var_prefix)GLOBAL_CFLAGS := -fno-exceptions -Wno-multichar $(BOARD_GLOBAL_CFLAGS)
ifneq ($(DISABLE_DTC_OPTS),true)
$(combo_var_prefix)RELEASE_CFLAGS := -g0 $(BOARD_RELEASE_CFLAGS)
$(combo_var_prefix)GLOBAL_CPPFLAGS := -w -g0 $(BOARD_GLOBAL_CPPFLAGS)
$(combo_var_prefix)GLOBAL_LDFLAGS := -w -g0
else
$(combo_var_prefix)RELEASE_CFLAGS := -O2 -g -fno-strict-aliasing $(BOARD_RELEASE_CFLAGS)
$(combo_var_prefix)GLOBAL_CPPFLAGS := $(BOARD_GLOBAL_CPPFLAGS)
$(combo_var_prefix)GLOBAL_LDFLAGS :=
endif
$(combo_var_prefix)GLOBAL_ARFLAGS := crsPD
$(combo_var_prefix)GLOBAL_LD_DIRS :=

$(combo_var_prefix)EXECUTABLE_SUFFIX :=
$(combo_var_prefix)SHLIB_SUFFIX := .so
$(combo_var_prefix)JNILIB_SUFFIX := $($(combo_var_prefix)SHLIB_SUFFIX)
$(combo_var_prefix)STATIC_LIB_SUFFIX := .a

# Now include the combo for this specific target.
include $(BUILD_COMBOS)/$(combo_target)$(combo_os_arch).mk
