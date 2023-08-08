/*
* Copyright (C) 2018 The OmniROM Project
*               2022-2023 VoidUI Project
*
* This program is free software: you can redistribute it and/or modify
* it under the terms of the GNU General Public License as published by
* the Free Software Foundation, either version 2 of the License, or
* (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
* GNU General Public License for more details.
*
* You should have received a copy of the GNU General Public License
* along with this program. If not, see <http://www.gnu.org/licenses/>.
*
*/
package org.lineageos.settings.display;

import android.annotation.TargetApi;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Build;
import android.os.Bundle;
import android.provider.Settings;
import android.service.quicksettings.Tile;
import android.service.quicksettings.TileService;
import androidx.preference.PreferenceManager;

import org.lineageos.settings.utils.FileUtils;

@TargetApi(Build.VERSION_CODES.N)
public class DcDimmingTileService extends TileService {

    private static final String DC_DIMMING_ENABLE_KEY = "dc_dimming_enable";
    private static final String DISPPARAM_NODE = "/sys/class/drm/card0/card0-DSI-1/disp_param";

    private static final String DISPPARAM_DC_ON = "0x40000";
    private static final String DISPPARAM_DC_OFF = "0x50000";
    private static final String DISPPARAM_DIMMING_ON = "0xF00";
    private static final String DISPPARAM_DIMMING_OFF = "0xE00";
    private static final String DISPPARAM_CRC_OFF = "0xF00000";

    private static final String BRIGHTNESS_NODE = "/sys/class/backlight/panel0-backlight/brightness";

    @Override
    public void onStartListening() {
        super.onStartListening();
        SharedPreferences sharedPrefs = PreferenceManager.getDefaultSharedPreferences(this);
        updateUI(sharedPrefs.getBoolean(DC_DIMMING_ENABLE_KEY, false));
    }

    @Override
    public void onStopListening() {
        super.onStopListening();
    }

    @Override
    public void onClick() {
        super.onClick();
        SharedPreferences sharedPrefs = PreferenceManager.getDefaultSharedPreferences(this);
        final boolean enabled = !(sharedPrefs.getBoolean(DC_DIMMING_ENABLE_KEY, false));
        setDcDimmingStatus(enabled);
        sharedPrefs.edit().putBoolean(DC_DIMMING_ENABLE_KEY, enabled).apply();
        updateUI(enabled);
    }

    private void updateUI(boolean enabled) {
        final Tile tile = getQsTile();
        tile.setState(enabled ? Tile.STATE_ACTIVE : Tile.STATE_INACTIVE);
        tile.updateTile();
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
