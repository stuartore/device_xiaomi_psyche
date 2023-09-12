#!/bin/bash
psyche_allowlist_patch(){
	if [[ ! $(grep 'psyche adds' build/soong/scripts/check_boot_jars/package_allowed_list.txt) ]];then
		sh -c "$(echo '''
# psyche adds
com\.oplus\.os
com\.oplus\.os\..*
oplus\.content\.res
oplus\.content\.res\..*
vendor\.lineage\.livedisplay
vendor\.lineage\.livedisplay\..*
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
}
psyche_patch
