#!/bin/bash

DOWNLOAD_LINK="http://download.wiimm.de/wiimmfi/patcher/mkw-wiimmfi-patcher-v3.7z"
GAME_TYPE="GENERIC"
GAMENAME="Mario Kart Wiimmfi"

show_notes () {

echo -e \
"************************************************
${GAMENAME}

Patches Mario Kart Wii to use Wiimm's custom server

Source:			http://wiiki.wii-homebrew.com/Wiimmfi-Patcher
Base Image:		Mario Kart Wii (RMC?01)
Supported Versions:	EUR, JAP, USA
************************************************"

}

check_input_image_special () {

	ask_input_image_mkwiimm
	echo -e "type RMC???.wbfs:\n"
	read -er ID

	if [[ -f ${PWD}/${ID} ]]; then
		GAMEDIR="${PWD}"
	elif [[ -f ${PATCHIMAGE_WBFS_DIR}/${ID} ]]; then
		GAMEDIR="${PATCHIMAGE_WBFS_DIR}"
	else	echo "invalid user input."
		exit 75
	fi


}

download_wiimm () {

	mkdir -p "${HOME}/.patchimage/tools/"
	cd "${HOME}"/.patchimage/tools
	rm -rf wiimmfi-patcher/ ./*.7z*
	wget "${DOWNLOAD_LINK}" || ( echo "something went wrong downloading ${DOWNLOAD_LINK}" && exit 57 )
	"${UNP}" mkw-wiimmfi-patcher.7z >/dev/null || ( echo "something went wrong unpacking files" && exit 63 )
	mv mkw-wiimmfi-patcher*/ wiimmfi-patcher
	chmod +x wiimmfi-patcher/*.sh
	rm ./*.7z

}

patch_wiimm () {

	cd "${HOME}"/.patchimage/tools/wiimmfi-patcher/

	ln -s "${GAMEDIR}"/"${ID}" .
	./patch-wiimmfi.sh >/dev/null || \
		( echo "wiimmfi-ing the image failed." && exit 69 )
	mv -v ./wiimmfi-images/"${ID}" "${PATCHIMAGE_GAME_DIR}"/

	rm -rf "${HOME}"/.patchimage/tools/wiimfi-patcher/
}

pi_action () {

	download_wiimm
	patch_wiimm

}
