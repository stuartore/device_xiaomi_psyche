#!/bin/bash
# This file is generated for Xiaomi 12X (psyche)

dt_bringup_complished=0

# ROM specs
rising_specs(){
	cat>>$1<<SPECS
# RisingOS

# GMS
WITH_GMS := true
TARGET_CORE_GMS := true

#TARGET_CORE_GMS_EXTRAS := true
PRODUCT_PACKAGES += \\
    Photos \\
    MarkupGoogle \\
    LatinIMEGooglePrebuilt \\
    AiWallpapers \\
    WallpaperEmojiPrebuilt \\
    PrebuiltDeskClockGoogle \\
    CalculatorGooglePrebuilt \\
    Velvet

TARGET_DEFAULT_PIXEL_LAUNCHER := true
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

alphadroid_specs(){
	cat>>$1<<SPECS
# AlphaDroid prop
TARGET_SUPPORTS_CALL_RECORDING := true
TARGET_EXCLUDES_AUDIOFX := true
TARGET_INCLUDE_MATLOG := false
TARGET_BUILD_PACKAGE := 2
TARGET_LAUNCHER := 2

TARGET_DEBLOAT := true
TARGET_INCLUDE_WIFI_EXT := true
TARGET_INCLUDE_LIVE_WALLPAPERS := true

# Charging Animation
TARGET_INCLUDE_PIXEL_CHARGER := true

# Maintainer
ALPHA_BUILD_TYPE := UNOFFICIAL
ALPHA_MAINTAINER := 斯图尔特

# GMS
WITH_GMS := true
TARGET_CORE_GMS := true
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
TARGET_INCLUDE_LIVE_WALLPAPERS := true
TARGET_INCLUDE_STOCK_ARCORE := false

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

afterlife_specs(){
	cat>>$1<<SPECS
AFTERLIFE_GAPPS := true
GAPPS_BASIC := true
AFTERLIFE_MAINTAINER := 斯图尔特
TARGET_SUPPORTS_GOOGLE_RECORDER := true
SPECS
}

aosp_specs(){
	cat>>$1<<SPECS
WITH_GAPPS := true
TARGET_USES_MINI_GAPPS := true
TARGET_SUPPORTS_GOOGLE_RECORDER := true
SPECS
}

# rom patches

psyche_rom_patches(){
	case $rom_spec_str in
 		"superior")
   			return
      			;;
	 esac
}

# device bringup for current ROM
dt_bringup(){
	# patch device tree string
	if [[ $dt_bringup_complished -eq 1 ]];then return;fi

	# check rom and it's spec str
        export rom_spec_str="$(basename "$(dirname $(find vendor -maxdepth 3 -type d -name '*config' -exec sh -c 'test -e "{}/common.mk" -o -e "{}/version.mk"' \; -print))")"
        rom_lowwercase="$(basename `pwd` | tr '[:upper:]' '[:lower:]')"
    	case $rom_spec_str in
     		"rising")
       			rom_spec_str="lineage"
	  		;;
     	esac

	cd device/xiaomi/psyche
	dt_device_name="$(grep 'PRODUCT_DEVICE' *.mk --max-count=1 | sed 's/[[:space:]]//g' | sed 's/.*:=//g')"
	dt_main_mk=$(grep 'PRODUCT_DEVICE :=' *.mk  --max-count=1 | sed 's/[[:space:]]//g' | sed 's/:PRODUCT_DEVICE.*//g')
	dt_old_str=$(echo $dt_main_mk | sed 's/_.*//g')

	sed -i 's/'"${dt_old_str}"'/'"${rom_spec_str}"'/g' AndroidProducts.mk
	sed -i 's/'"${dt_old_str}"'/'"${rom_spec_str}"'/g' $dt_main_mk
	sed -i 's/vendor\/'"${dt_old_str}"'/vendor\/'"${rom_spec_str}"'/g' BoardConfig*.mk
	if [[ $(grep 'include device/xiaomi/sm8250-common' *.mk) ]];then
                sed -i 's/vendor\/.*\/config/vendor\/'"${rom_spec_str}"'\/config/g' ../sm8250-common/BoardConfig*.mk
                sed -i 's/TARGET_2ND_ARCH_VARIANT := .*/TARGET_2ND_ARCH_VARIANT := armv8-2a/g' ../sm8250-common/BoardConfig*.mk
        fi

	dt_new_main_mk="${rom_spec_str}_psyche.mk"
	if [[ ! -f $dt_new_main_mk ]];then
		mv $dt_main_mk $dt_new_main_mk
	fi
	if [[ ! -f ${rom_spec_str}.dependencies ]];then
		mv ${dt_old_str}.dependencies ${rom_spec_str}.dependencies
	fi

	if [[ ! $(grep AUTOADD $dt_new_main_mk) ]];then
		sed -i '$a \
\
# Interit from '"$rom_str"' - AUTOADD\
' $dt_new_main_mk
		case $rom_spec_str in
			"lineage")
	  			case $rom_lowwercase in
                    alphadroid*)
                        alphadroid_specs $dt_new_main_mk
                        ;;
                    rising*)
                        rising_specs $dt_new_main_mk
                        ;;
                    *)
                        aosp_specs $dt_new_main_mk
                        ;;
                esac
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
			"afterlife")
   				afterlife_specs $dt_new_main_mk
   				;;
			*)
				aosp_specs $dt_new_main_mk
				;;
		esac
	fi
 	# patch device tree because of using different source
  	if [[ $(grep include *.mk | grep sm8250) ]];then
   		# fix libudfpshandler dumplicate name
		pwd
		if [[ -f ../sm8250-common/udfps/Android.bp ]];then
		  	if [[ $(grep 'name: "libudfpshandler"' configs/udfps/Android.bp) ]] && [[ $(grep 'name: "libudfpshandler"' ../sm8250-common/udfps/Android.bp) ]];then
				mv ../sm8250-common/udfps/Android.bp ../sm8250-common/udfps/Android.bp.bak
	   		fi
		fi
     		# fix audio name
       		if [[ $(grep "media_codecs_dolby_audio.xml" -rns ../sm8250-common/  | grep "name:") ]];then
			local audio_bp_file="$(grep "media_codecs_dolby_audio.xml" -rns ../sm8250-common/  | grep "name:" | sed 's/Android.bp.*/Android.bp/g' | head -1)"
   			sed -i 's/media_codecs_dolby_audio.xml/media_codecs_dolby_audio1.xml/g' $audio_bp_file
      			sed -i 's/media_codecs_dolby_audio.xml/media_codecs_dolby_audio1.xml/g' ../sm8250-common/*.mk
  		fi
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

turn_psyche_15_dt(){
	# 1 - device tree source
	$1
}

source_xiaomi_psyche(){
	git_check_dir https://github.com/stuartore/device_xiaomi_psyche fifteen device/xiaomi/psyche
	git_check_dir https://github.com/stuartore/device_xiaomi_sm8250-common.git fifteen device/xiaomi/sm8250-common
	git_check_dir https://github.com/stuartore/vendor_xiaomi_psyche.git fifteen vendor/xiaomi/psyche
	git_check_dir https://github.com/stuartore/vendor_xiaomi_sm8250-common.git fifteen vendor/xiaomi/sm8250-common
	# git_check_dir https://github.com/stuartore/kernel_xiaomi_sm8250.git fourteen kernel/xiaomi/sm8250
 	# magictime kernel
  	git_check_dir https://github.com/TIMISONG-dev/kernel_xiaomi_sm8250 magictime-new kernel/xiaomi/sm8250
        # hardware xiaomi
	git_check_dir https://github.com/LineageOS/android_hardware_xiaomi lineage-22.0 hardware/xiaomi
}

psyche_deps(){
	rom_spec_str="$(basename "$(find vendor -maxdepth 3 -type f -iname "common.mk" | sed 's/config.*//g')")"
	mkdir -p device/xiaomi vendor/xiaomi kernel/xiaomi

	# turn xiaomi psyche default dt - test
	turn_psyche_15_dt source_xiaomi_psyche
	
	# Other - rom patches
	case $rom_spec_str in
		"afterlife")
			# lineage based device tree string modify for custom rom
			sed -i 's/hardware\/lineage/hardware\/afterlife/g' device/xiaomi/sm8250-common/kona.mk
			sed -i 's/hardware\/lineage/hardware\/afterlife/g' device/xiaomi/sm8250-common/Android.bp
			sed -i 's/vendor\/lineage/vendor\/afterlife/g' device/xiaomi/sm8250-common/BoardConfigCommon.mk
			;;
	esac
}

psyche_rom_setup(){
	rom_str="$(grep 'url' .repo/manifests.git/config | uniq | sed 's/url//g' | sed 's/=//g' | awk  -F '/' '{print $4}')"

	if [[ ! $(grep 'revision="android-15' .repo/manifests/default.xml) ]];then echo -e "\033[1;33m=>\033[0m SKIP - source code is \033[1;33mnot Android 15\033[0m";exit;fi

	tasks=( psyche_deps dt_bringup psyche_rom_patches )
	for task in "${tasks[@]}"
 	do
  		$task
    	done
}

psyche_rom_setup
