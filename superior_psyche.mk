#
# Copyright (C) 2021 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

# Inherit from those products. Most specific first.
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)

# default configs
TARGET_USES_AOSP_RECOVERY := true
TARGET_SUPPORTS_QUICK_TAP := true
TARGET_BOOT_ANIMATION_RES := 1080
$(call inherit-product, vendor/superior/config/common.mk)

# Inherit from psyche device
$(call inherit-product, device/xiaomi/psyche/device.mk)

# Dolby
TARGET_USES_MIUI_DOLBY := true

# UDFPS animations
EXTRA_UDFPS_ANIMATIONS := true
TARGET_HAS_UDFPS := true

PRODUCT_NAME := superior_psyche
PRODUCT_DEVICE := psyche
PRODUCT_MANUFACTURER := Xiaomi
PRODUCT_BRAND := Xiaomi
PRODUCT_MODEL := 2112123AG


PRODUCT_GMS_CLIENTID_BASE := android-xiaomi

PRODUCT_CHARACTERISTICS := nosdcard
BUILD_FINGERPRINT := Xiaomi/psyche_global/psyche:13/RKQ1.211001.001/V14.0.4.0.TLDMIXM:user/release-keys

# Interit from SuperiorOS - AUTOADD

IS_PHONE := true

# Charging Animation
TARGET_INCLUDE_PIXEL_CHARGER := true

# Disable/Enable Blur Support, default is false
TARGET_ENABLE_BLUR := true

# Officialify
SUPERIOR_OFFICIAL := false
BUILD_WITH_GAPPS := true

# Udfps Stuff
SUPERIOR_UDFPS_ANIMATIONS := true

# Superior Prebuilts
USE_MOTO_CALCULATOR := true
USE_QUICKPIC := true
