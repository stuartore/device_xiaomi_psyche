
#!/bin/bash
# This file is generated for Xiaomi 12X (psyche)

dt_bringup_complished=0

# ROM specs
rising_specs(){
	cat>>$1<<SPECS
RISING_DEVICE := Xiaomi 12X
RISING_CHIPSET := Snapdragon®870
RISING_MAINTAINER := 斯图尔特

TARGET_USE_PIXEL_FINGERPRINT := true
TARGET_ENABLE_BLUR := true

# Graphene Camera
TARGET_BUILD_GRAPHENEOS_CAMERA := false

# Aperture Camera
TARGET_BUILD_APERTURE_CAMERA := true

# Gapps
WITH_GMS := true
TARGET_USE_GOOGLE_TELEPHONY := true
TARGET_FACE_UNLOCK_SUPPORTED := true

# Vendor addons
TARGET_ADD_MOTO_CALCULATOR := false
TARGET_ADD_MOTO_CALENDAR := false
TARGET_ADD_MOTO_PHOTO := false
TARGET_ADD_VIA_BROWSER := false
TARGET_ADD_NFC_CARDEMULATOR := true
SPECS
}

superior_specs(){
	cat>>$1<<SPECS
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
SPECS
}

derpfest_specs(){
	cat>>$1<<SPECS
TARGET_USES_MINI_GAPPS := true
TARGET_SUPPORTS_GOOGLE_RECORDER := true
SPECS
}

pixys_specs(){
	cat>>$1<<SPECS
TARGET_BOOT_ANIMATION_RES := 1080
TARGET_INCLUDE_LIVE_WALLPAPERS := true
TARGET_INCLUDE_STOCK_ARCORE := false
TARGET_FACE_UNLOCK_SUPPORTED := true
TARGET_SUPPORTS_QUICK_TAP := true
TARGET_SUPPORTS_GOOGLE_RECORDER := true
TARGET_GAPPS_ARCH := arm64

TARGET_USES_MINI_GAPPS := true
TARGET_SUPPORTS_GOOGLE_RECORDER := true
SPECS
}

cherish_specs(){
	cat>>$1<<SPECS
CHERISH_VANILLA := true
CHERISH_BUILD_TYPE := UNOFFICIAL
TARGET_USE_PIXEL_LAUNCHER := false
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.cherish.maintainer=斯图尔特
SPECS
}

aosp_specs(){
	cat>>$1<<SPECS
WITH_GAPPS := true
TARGET_USES_MINI_GAPPS := true
TARGET_SUPPORTS_GOOGLE_RECORDER := true
SPECS
}

# rom patch
rising_13_patch(){
	if [[ $(basename $(pwd) | tr "[A-Z]" "[a-z]") != "risingtechoss" ]] || [[ ! $(grep 'revision="android-13' .repo/manifests/default.xml) ]];then return;fi

	if [[ ! $(grep 'aosp-setup patch' build/soong/Android.bp) ]];then
	cat>>build/soong/Android.bp<<ROMPATCH
//aosp-setup patch android 13
soong_config_module_type {
    name: "qti_vibrator_hal",
    module_type: "cc_defaults",
    config_namespace: "lineageQcomVars",
    bool_variables: ["qti_vibrator_use_effect_stream"],
    value_variables: ["qti_vibrator_effect_lib"],
    properties: [
        "cppflags",
        "shared_libs",
    ],
}
qti_vibrator_hal {
	name: "qti_vibrator_hal_defaults",
	soong_config_variables: {
		qti_vibrator_use_effect_stream: {
			cppflags: ["-DUSE_EFFECT_STREAM"],
		},
		qti_vibrator_effect_lib: {
			shared_libs: ["%s"],
		},
	},
}
ROMPATCH
	fi
}

# device bringup for current ROM
dt_bringup(){
	# patch device tree string
	if [[ $dt_bringup_complished -eq 1 ]];then return;fi

	rom_spec_str="$(basename "$(find vendor -maxdepth 3 -type f -iname "common.mk" | sed 's/config.*//g')")"
	cd device/xiaomi/psyche
	dt_device_name="$(grep 'PRODUCT_DEVICE' *.mk --max-count=1 | sed 's/[[:space:]]//g' | sed 's/.*:=//g')"
	dt_main_mk=$(grep 'PRODUCT_DEVICE :=' *.mk  --max-count=1 | sed 's/[[:space:]]//g' | sed 's/:PRODUCT_DEVICE.*//g')
	dt_old_str=$(echo $dt_main_mk | sed 's/_.*//g')

	sed -i 's/'"${dt_old_str}"'/'"${rom_spec_str}"'/g' AndroidProducts.mk
	sed -i 's/'"${dt_old_str}"'/'"${rom_spec_str}"'/g' $dt_main_mk
	sed -i 's/vendor\/'"${dt_old_str}"'/vendor\/'"${rom_spec_str}"'/g' BoardConfig*.mk

	dt_new_main_mk="${rom_spec_str}_psyche.mk"
	if [[ ! -f $dt_new_main_mk ]];then
		mv $dt_main_mk $dt_new_main_mk
	fi
	if [[ ! -f ${rom_spec_str}.dependencies ]];then
		mv ${dt_old_str}.dependencies ${rom_spec_str}.dependencies
	fi
	if [[ ! -f ../../../vendor/${rom_spec_str}/config/device_framework_matrix.xml ]] && [[ -f configs/hidl/aosp_device_framework_matrix.xml ]];then
		mv configs/hidl/aosp_device_framework_matrix.xml ../../../vendor/${rom_spec_str}/config/device_framework_matrix.xml
	fi
	if [[ -f ../../../packages/resources/devicesettings/Android.bp ]] && [[ -f parts/Android.bp ]];then
		if [[ $(grep settings.resource ../../../packages/resources/devicesettings/Android.bp | grep -c 'name:') -eq 1 ]];then
			old_parts_settings_str="$(grep settings.resources parts/Android.bp | sed 's/[[:space:]]//g')"
			new_parts_settings_str="$(grep name: ../../../packages/resources/devicesettings/Android.bp | sed 's/[[:space:]]//g' | sed 's/name://g')"
			sed -i 's/'"${old_parts_settings_str}"'/'"${new_parts_settings_str}"'/g' parts/Android.bp
		fi
	fi

	if [[ ! $(grep AUTOADD $dt_new_main_mk) ]];then
		sed -i '$a \
\
# Interit from '"$rom_str"' - AUTOADD\
' $dt_new_main_mk
		case $rom_spec_str in
			"lineage")
				rising_specs $dt_new_main_mk
				;;
			"superior")
				superior_specs $dt_new_main_mk
    				sed -i 's/common_full_phone/common/g' $dt_new_main_mk
				;;
			"derp")
				derpfest_specs $dt_new_main_mk
				;;
			"pixys")
				pixys_specs $dt_new_main_mk
				;;
			"cherish")
				cherish_specs $dt_new_main_mk
				;;
			"evolution")
                                aosp_specs $dt_new_main_mk
                                sed -i 's/ro.com.android.dataroaming=true//g' vendor.prop
                                ;;
			*)
				aosp_specs $dt_new_main_mk

				;;
		esac
	fi
	sed -i '4s|dt_bringup_complished=.*|dt_bringup_complished=1|g' ${BASH_SOURCE}
	cd ../../..
}

# Prepare sources
git_check_dir(){
	if [[ ! -d $3 ]];then
		mkdir -p $(dirname $3)
		git clone --depth=1 $1 -b $2 $3
	else
		echo -e "\033[1;32m=>\033[0m Found $3"
	fi
}

psyche_deps(){
	# use git_check_dir to setup dependencies

	git_check_dir https://github.com/xiaomi-mars-devs/android_hardware_xiaomi lineage-20 hardware/xiaomi

	git_check_dir https://github.com/stuartore/device_xiaomi_psyche $1 device/xiaomi/psyche
	git_check_dir https://gitlab.com/stuartore/android_vendor_xiaomi_psyche $2 vendor/xiaomi/psyche
	git_check_dir https://gitlab.com/stuartore/vendor_xiaomi_psyche-firmware thirteen vendor/xiaomi-firmware/psyche
	git_check_dir https://github.com/Moonlight4004/kernel_xiaomi_sm8250 aosp-13 kernel/xiaomi/void-aosp-sm8250

	# you can also use xiaomi_sm8250_devs kernel
	#git_check_dir https://github.com/xiaomi-sm8250-devs/android_kernel_xiaomi_sm8250.git lineage-20 kernel/xiaomi/devs-sm8250

	# vendor addons
	git_check_dir https://github.com/stuartore/vendor_addons_xiaomi_apps.git thirteen vendor/addons/xiaomi/apps

	# clang
	git_check_dir https://github.com/EmanuelCN/zyc_clang-14.git master prebuilts/clang/host/linux-x86/ZyC-clang

	# other
	echo 'include $(call all-subdir-makefiles)' > vendor/xiaomi-firmware/Android.mk

	# type info when exit
	if [[ -d hardware/xiaomi ]] && [[ -d device/xiaomi/psyche ]] && [[ -d vendor/xiaomi/psyche ]] && [[ kernel/xiaomi/void-aosp-sm8250 ]] && [[ -d vendor/xiaomi-firmware/psyche ]] && [[ -d prebuilts/clang/host/linux-x86/ZyC-clang ]];then
		echo -e "\n\033[1;32m=>\033[0m here you're on the way, eg: lunch"
	fi
}

psyche_kernel_patch(){
	# need remove 2 techpack Android.mk
	psyche_kernel_path=$(grep TARGET_KERNEL_SOURCE device/xiaomi/psyche/BoardConfig.mk | grep -v '#' | sed 's/TARGET_KERNEL_SOURCE//g' | sed 's/:=//g' | sed 's/[[:space:]]//g')

	rm -f $psyche_kernel_path/techpack/data/drivers/rmnet/perf/Android.mk
	rm -f $psyche_kernel_path/techpack/data/drivers/rmnet/shs/Android.mk
}

psyche_allowlist_patch(){
	if [[ ! $(grep 'psyche adds' build/soong/scripts/check_boot_jars/package_allowed_list.txt) ]];then
		sh -c "$(echo '''
# psyche adds
com\.oplus\.os
com\.oplus\.os\..*
oplus\.content\.res
oplus\.content\.res\..*
vendor\.lineage\.touch
vendor\.lineage\.touch\..*
ink\.kaleidoscope
ink\.kaleidoscope\..*
''' >> build/soong/scripts/check_boot_jars/package_allowed_list.txt)"
	fi
}

psyche_patch(){
	psyche_kernel_patch
	psyche_allowlist_patch

	# rom patch
	# patch when detect risingos 13
	rising_13_patch
}

psyche_rom_setup(){
	rom_str="$(grep 'url' .repo/manifests.git/config | uniq | sed 's/url//g' | sed 's/=//g' | awk  -F '/' '{print $4}')"
	if [[ -d hardware/xiaomi ]] && [[ -d device/xiaomi/psyche ]] && [[ -d vendor/xiaomi/psyche ]] && [[ -d kernel/xiaomi/void-aosp-sm8250 ]] && [[ -d vendor/xiaomi-firmware/psyche ]] && [[ -d prebuilts/clang/host/linux-x86/ZyC-clang ]];then
		dt_bringup
		return
	fi

	if [[ ! $(grep 'revision="android-13' .repo/manifests/default.xml) ]];then echo -e "\033[1;33m=>\033[0m SKIP - source code is \033[1;33mnot Android 13\033[0m";exit;fi

	cd device/xiaomi/psyche
	dt_branch="$(git branch | grep '*'| sed 's/.*thirteen/thirteen/g' | sed 's/[[:space:]]//g')"
	vendor_branch='thirteen'
	cd ../../..

	echo -e "\033[32m=>\033[0m Detect \033[1;36m${rom_str}\033[0m and select device branch \033[1;32m${dt_branch}\033[0m\n"
	psyche_deps ${dt_branch} ${vendor_branch}

	# device tree bringup
	dt_bringup
}

psyche_rom_setup
psyche_patch
