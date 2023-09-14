/*
 * Copyright (C) 2021 The LineageOS Project
 *
 * SPDX-License-Identifier: Apache-2.0
 */

#include <libinit_dalvik_heap.h>
#include <libinit_utils.h>
#include <libinit_variant.h>

#include "vendor_init.h"

static const variant_info_t psyche_global_info = {
    .hwc_value = "GLOBAL",
    .sku_value = "",

    .brand = "Xiaomi",
    .device = "psyche",
    .marketname = "Xiaomi 12X",
    .model = "2112123AG",

    .nfc = true,
};

static const variant_info_t psyche_info = {
    .hwc_value = "",
    .sku_value = "",

    .brand = "Xiaomi",
    .device = "psyche",
    .marketname = "Xiaomi 12X",
    .model = "2112123AG",

    .nfc = true,
};

static const std::vector<variant_info_t> variants = {
    psyche_global_info,
    psyche_info,
};

void vendor_load_properties() {
    search_variant(variants);
    set_dalvik_heap();

    // SafetyNet workaround
    property_override("ro.boot.verifiedbootstate", "green");

    // sku properties
    property_override("ro.boot.hardware.sku", "psyche");
    property_override("ro.boot.product.hardware.sku", "psyche");
}
