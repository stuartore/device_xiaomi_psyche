/*
 * Copyright (C) 2024 The LineageOS Project
 *
 * SPDX-License-Identifier: Apache-2.0
 */

#include <libinit_dalvik_heap.h>
#include <libinit_variant.h>
#include "vendor_init.h"

static const variant_info_t psyche_info = {
    .hwc_value = "",
    .sku_value = "",

    .brand = "Xiaomi",
    .device = "psyche",
    .marketname = "Xiaomi 12X",
    .model = "2112123AC",
    .build_fingerprint = "Xiaomi/psyche/psyche:13/RKQ1.211001.001/V816.0.3.0.TLDCNXM:user/release-keys",
    .nfc = true,
};

static const std::vector<variant_info_t> variants = {
    psyche_info,
};

void vendor_load_properties() {
    search_variant(variants);
    set_dalvik_heap();
}
