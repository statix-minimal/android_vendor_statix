#
# Copyright (C) 2018-2022 StatiXOS
#
# SPDX-License-Identifier: Apache-2.0
#

include vendor/statix/build/core/vendor/*.mk

# Conditionally call QCOM makefiles
ifeq ($(PRODUCT_USES_QCOM_HARDWARE), true)
include vendor/statix/build/core/ProductConfigQcom.mk
endif

PRODUCT_BUILD_PROP_OVERRIDES += BUILD_UTC_DATE=0

ifeq ($(PRODUCT_GMS_CLIENTID_BASE),)
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.com.google.clientidbase=android-google
else
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.com.google.clientidbase=$(PRODUCT_GMS_CLIENTID_BASE)
endif

PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    keyguard.no_require_sim=true \
    dalvik.vm.debug.alloc=0 \
    ro.url.legal=http://www.google.com/intl/%s/mobile/android/basic/phone-legal.html \
    ro.url.legal.android_privacy=http://www.google.com/intl/%s/mobile/android/basic/privacy.html \
    ro.error.receiver.system.apps=com.google.android.gms \
    ro.setupwizard.enterprise_mode=1 \
    ro.com.android.dataroaming=false \
    ro.atrace.core.services=com.google.android.gms,com.google.android.gms.ui,com.google.android.gms.persistent \
    ro.com.android.dateformat=MM-dd-yyyy \
    persist.sys.disable_rescue=true \
    ro.build.selinux=1

# Conditionally enable blur
ifeq ($(TARGET_USES_BLUR), true)
PRODUCT_PRODUCT_PROPERTIES += \
    ro.sf.blurs_are_expensive=1 \
    ro.surface_flinger.supports_background_blur=1
endif

# Enable support of one-handed mode
PRODUCT_PRODUCT_PROPERTIES += \
    ro.support_one_handed_mode?=true

# Enable SystemUIDialog volume panel
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    sys.fflag.override.settings_volume_panel_in_systemui=true

# Copy over some StatiX assets
PRODUCT_COPY_FILES += \
    vendor/statix/prebuilt/etc/init.statix.rc:system/etc/init/init.statix.rc \
    vendor/statix/prebuilt/etc/permissions/privapp-permissions-statix-product.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/permissions/privapp-permissions-statix-product.xml \
    vendor/statix/prebuilt/etc/permissions/privapp-permissions-statix-se.xml:$(TARGET_COPY_OUT_SYSTEM_EXT)/etc/permissions/privapp-permissions-statix-se.xml

# Compile SystemUI on device with `speed`.
PRODUCT_PROPERTY_OVERRIDES += \
    dalvik.vm.systemuicompilerfilter=speed

# Packages
include vendor/statix/config/packages.mk

# Branding
include vendor/statix/config/branding.mk

# Overlays
PRODUCT_ENFORCE_RRO_EXCLUDED_OVERLAYS += vendor/statix/overlay
DEVICE_PACKAGE_OVERLAYS += vendor/statix/overlay/common

# Artifact path requirements
PRODUCT_ARTIFACT_PATH_REQUIREMENT_ALLOWED_LIST += \
    system/etc/pvmfw.bin \
    system/etc/init/init.statix.rc \
    system/lib/libRSSupport.so \
    system/lib/libblasV8.so \
    system/lib/librsjni.so \
    system/lib64/libRSSupport.so \
    system/lib64/libblasV8.so \
    system/lib64/librsjni.so

# Enable Compose in SystemUI by default.
SYSTEMUI_USE_COMPOSE ?= true

# Flags
ifeq ($(TARGET_BUILD_VARIANT), user)
    PRODUCT_ART_TARGET_INCLUDE_DEBUG_BUILD := false
    PRODUCT_MINIMIZE_JAVA_DEBUG_INFO := true
    PRODUCT_SYSTEM_SERVER_DEBUG_INFO := false
    WITH_DEXPREOPT_DEBUG_INFO := false
endif

include vendor/statix/config/BoardConfigStatix.mk
