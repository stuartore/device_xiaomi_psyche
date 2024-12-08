BUILD_BROKEN_SRC_DIR_IS_WRITABLE := true
#
# Copyright (C) 2021 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

# A/B
TARGET_IS_VAB := true

# Inherit from sm8250-common
$(call inherit-product, device/xiaomi/sm8250-common/kona.mk)

# AAPT
PRODUCT_AAPT_CONFIG := normal
PRODUCT_AAPT_PREF_CONFIG := xxhdpi

# Audio configs
PRODUCT_COPY_FILES += \
    $(call find-copy-subdir-files,*,$(LOCAL_PATH)/audio/,$(TARGET_COPY_OUT_VENDOR)/etc)

# Boot animation
TARGET_SCREEN_HEIGHT := 2400
TARGET_SCREEN_WIDTH := 1080

# Camera
PRODUCT_PACKAGES += \
    libpiex_shim

# Dolby Config File
TARGET_USES_MIUI_DOLBY := true
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/dolby/config/dax-default.xml:$(TARGET_COPY_OUT_VENDOR)/etc/dolby/dax-default.xml

# Fingerprint
TARGET_HAS_UDFPS := true

# Nfc
PRODUCT_PACKAGES += NfcTargetOverlay

# Overlays
PRODUCT_PACKAGES += \
    ApertureTargetOverlay \
    FrameworksTargetOverlay \
    SettingsProviderTargetOverlay \
    SettingsTargetOverlay \
    SettingsTargetOverlayPsycheCN \
    SettingsTargetOverlayPsycheGL \
    SystemUITargetOverlay

# Sensors
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/configs/sensors/hals.conf:$(TARGET_COPY_OUT_VENDOR)/etc/sensors/hals.conf

# Shipping API level
PRODUCT_SHIPPING_API_LEVEL := 30

# Soong namespaces
PRODUCT_SOONG_NAMESPACES += \
    $(LOCAL_PATH)

# Thermal Config
PRODUCT_COPY_FILES += \
    $(call find-copy-subdir-files,*,$(LOCAL_PATH)/configs/thermal/,$(TARGET_COPY_OUT_VENDOR)/etc)

# WiFi
PRODUCT_PACKAGES += \
    TargetWifiOverlay

# Inherit from vendor blobs
$(call inherit-product, vendor/xiaomi/psyche/psyche-vendor.mk)
