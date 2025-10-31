/*
 * Copyright (C) 2021-2025 The LineageOS Project
 *
 * SPDX-License-Identifier: Apache-2.0
 */

#include <libvariant.h>

static const variant_info psyche_global_info = {
    .hwc_value = "GLOBAL",
    .sku_value = "",

    .brand = "Xiaomi",
    .device = "psyche",
    .marketname = "Xiaomi 12X",
    .model = "2112123AG",
    .build_fingerprint = "Xiaomi/psyche_global/psyche:13/RKQ1.211001.001/V816.0.8.0.TLDMIXM:user/release-keys",

    .nfc = true,
};

static const variant_info psyche_info = {
    .hwc_value = "",
    .sku_value = "",

    .brand = "Xiaomi",
    .device = "psyche",
    .marketname = "Xiaomi 12X",
    .model = "2112123AC",
    .build_fingerprint = "Xiaomi/psyche_global/psyche:13/RKQ1.211001.001/V816.0.8.0.TLDMIXM:user/release-keys",

    .nfc = true,
};

const std::vector<variant_info> variants = {
    psyche_global_info,
    psyche_info,
};
