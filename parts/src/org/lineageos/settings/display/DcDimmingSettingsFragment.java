/*
 * Copyright (C) 2018 The LineageOS Project
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

package org.lineageos.settings.display;

import android.content.Context;
import android.os.Bundle;
import androidx.preference.Preference;
import androidx.preference.Preference.OnPreferenceChangeListener;
import androidx.preference.PreferenceFragment;
import androidx.preference.SwitchPreference;

import org.lineageos.settings.R;
import org.lineageos.settings.utils.FileUtils;

public class DcDimmingSettingsFragment extends PreferenceFragment implements OnPreferenceChangeListener {

    private SwitchPreference mDcDimmingPreference;
    private static final String DC_DIMMING_ENABLE_KEY = "dc_dimming_enable";
    private static final String DISPPARAM_NODE = "/sys/class/drm/card0/card0-DSI-1/disp_param";

    private static final String DISPPARAM_DC_ON = "0x40000";
    private static final String DISPPARAM_DC_OFF = "0x50000";
    private static final String DISPPARAM_DIMMING_ON = "0xF00";
    private static final String DISPPARAM_DIMMING_OFF = "0xE00";
    private static final String DISPPARAM_CRC_OFF = "0xF00000";

    private static final String BRIGHTNESS_NODE = "/sys/class/backlight/panel0-backlight/brightness";

    @Override
    public void onCreatePreferences(Bundle savedInstanceState, String rootKey) {
        addPreferencesFromResource(R.xml.dcdimming_settings);
        mDcDimmingPreference = (SwitchPreference) findPreference(DC_DIMMING_ENABLE_KEY);
        if (FileUtils.fileExists(DISPPARAM_NODE)) {
            mDcDimmingPreference.setEnabled(true);
            mDcDimmingPreference.setOnPreferenceChangeListener(this);
        } else {
            mDcDimmingPreference.setSummary(R.string.dc_dimming_enable_summary_not_supported);
            mDcDimmingPreference.setEnabled(false);
        }
    }

    @Override
    public boolean onPreferenceChange(Preference preference, Object newValue) {
        if (DC_DIMMING_ENABLE_KEY.equals(preference.getKey())) {
            if ((Boolean) newValue) {
                setDcDimmingStatus(true);
            } else {
                setDcDimmingStatus(false);
            }
        }
        return true;
    }

    private void setDcDimmingStatus(boolean enabled) {
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
