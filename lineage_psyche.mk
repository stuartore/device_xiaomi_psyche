#
# Copyright (C) 2021 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

# Inherit from those products. Most specific first.
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)

# Inherit some common LineageOS stuff.
$(call inherit-product, vendor/lineage/config/common_full_phone.mk)

# Device Specific Flags
TARGET_INCLUDE_WIFI_EXT := true
TARGET_BOOT_ANIMATION_RES := 1080

#BUILD_BROKEN_SRC_DIR_RW_ALLOWLIST := /home/ubuntu/.repo_.gitconfig.json 
#BUILD_BROKEN_SRC_DIR_IS_WRITABLE := true

# Environment Flags
TARGET_FACE_UNLOCK_SUPPORTED := true
TARGET_SUPPORTS_GOOGLE_RECORDER := true
TARGET_INCLUDE_STOCK_ARCORE := true
TARGET_INCLUDE_LIVE_WALLPAPERS := true
TARGET_SUPPORTS_NEXT_GEN_ASSISTANT := true

# Inherit from psyche device
$(call inherit-product, device/xiaomi/psyche/device.mk)

PRODUCT_NAME := lineage_psyche
PRODUCT_DEVICE := psyche
PRODUCT_MANUFACTURER := Xiaomi
PRODUCT_BRAND := Xiaomi
PRODUCT_MODEL := Xiaomi 12X

PRODUCT_GMS_CLIENTID_BASE := android-xiaomi

PRODUCT_BUILD_PROP_OVERRIDES += \
    BuildDesc="psyche-user 13 TKQ1.221114.001 V816.0.10.0.TLDMIXM release-keys" \
    BuildFingerprint=Xiaomi/psyche/psyche:13/TKQ1.221114.001/V816.0.10.0.TLDCNXM:user/release-keys

# Device Props
TARGET_FACE_UNLOCK_SUPPORTED := true
TARGET_SUPPORTS_QUICK_TAP := true

TARGET_ENABLE_BLUR := true
PRODUCT_NO_CAMERA := false

# MATLOG
TARGET_INCLUDE_MATLOG := false
