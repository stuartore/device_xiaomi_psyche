/*
 * Copyright (C) 2015 The CyanogenMod Project
 *               2017-2020 The LineageOS Project
 *               2022-2023 VoidUI Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package org.lineageos.settings;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.SharedPreferences;
import android.os.SystemProperties;
import android.util.Log;
import androidx.preference.PreferenceManager;

import org.lineageos.settings.dirac.DiracUtils;
import org.lineageos.settings.doze.DozeUtils;
import org.lineageos.settings.thermal.ThermalUtils;
import org.lineageos.settings.refreshrate.RefreshUtils;
import org.lineageos.settings.utils.FileUtils;

import vendor.xiaomi.hardware.touchfeature.V1_0.ITouchFeature;

public class BootCompletedReceiver extends BroadcastReceiver {

    private static final boolean DEBUG = false;
    private static final String TAG = "XiaomiParts";
    private static final String DC_DIMMING_ENABLE_KEY = "dc_dimming_enable";
    private static final String DISPPARAM_NODE = "/sys/class/drm/card0-DSI-1/disp_param";

    private static final String DISPPARAM_DC_ON = "0x40000";
    private static final String DISPPARAM_DC_OFF = "0x50000";
    private static final String DISPPARAM_DIMMING_ON = "0xF00";
    private static final String DISPPARAM_DIMMING_OFF = "0xE00";
    private static final String DISPPARAM_CRC_OFF = "0xF00000";

    private static final String BRIGHTNESS_NODE = "/sys/class/backlight/panel0-backlight/brightness";

    /* Double-tap */
    public static final String SHAREDD2TW = "sharadeD2TW";
    private ITouchFeature mTouchFeature;

    @Override
    public void onReceive(final Context context, Intent intent) {
        SharedPreferences sharedPrefs = PreferenceManager.getDefaultSharedPreferences(context);

        if (DEBUG)
            Log.d(TAG, "Received boot completed intent");
        try {
            DiracUtils.getInstance(context);
        } catch (Exception e) {
            Log.d(TAG, "Dirac is not present in system");
        }
        DozeUtils.checkDozeService(context);
        ThermalUtils.startService(context);
        RefreshUtils.startService(context);
        FileUtils.enableService(context);

       //Micro-Service to restore sata of dt2w on reboot
       SharedPreferences prefs = context.getSharedPreferences(SHAREDD2TW, Context.MODE_PRIVATE);
       try {
            mTouchFeature = ITouchFeature.getService();
            mTouchFeature.setTouchMode(14,prefs.getInt(SHAREDD2TW, 1));
            } catch (Exception e) {
            // Do nothing
        }

        boolean dcDimmingEnabled = sharedPrefs.getBoolean(DC_DIMMING_ENABLE_KEY, false);
        setDcDimmingStatus(dcDimmingEnabled);
    }

    void setDcDimmingStatus(boolean enabled) {
        if (enabled) {
            FileUtils.writeLine(DISPPARAM_NODE, DISPPARAM_DC_ON);
            FileUtils.writeLine(DISPPARAM_NODE, DISPPARAM_DIMMING_OFF);
            FileUtils.writeLine(DISPPARAM_NODE, DISPPARAM_DIMMING_ON);
            // Update the brightness node so dc dimming updates its state
            FileUtils.writeLine(BRIGHTNESS_NODE, FileUtils.readOneLine(BRIGHTNESS_NODE));
        } else {
            FileUtils.writeLine(DISPPARAM_NODE, DISPPARAM_DIMMING_OFF);
            FileUtils.writeLine(DISPPARAM_NODE, DISPPARAM_CRC_OFF);
            FileUtils.writeLine(DISPPARAM_NODE, DISPPARAM_DC_OFF);
            FileUtils.writeLine(DISPPARAM_NODE, DISPPARAM_DIMMING_ON);
            // Update the brightness node so dc dimming updates its state
            FileUtils.writeLine(BRIGHTNESS_NODE, FileUtils.readOneLine(BRIGHTNESS_NODE));
        }
    }
}
