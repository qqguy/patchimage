#!/bin/bash

WORKDIR=nsmb.d
DOL=${WORKDIR}/sys/main.dol
#DOWNLOAD_LINK="http://rvlution.net/forums/viewtopic.php?f=53&t=1352"
RIIVOLUTION_ZIP="Koopa country.rar"
RIIVOLUTION_DIR="."
GAMENAME="Koopa Country"
XML_SOURCE="${RIIVOLUTION_DIR}"/Koopa
XML_FILE="${RIIVOLUTION_DIR}"/riivolution/KoopaP.xml
GAME_TYPE=RIIVOLUTION
BANNER_LOCATION=${WORKDIR}/files/opening.bnr

show_notes () {

echo -e \
"************************************************
${GAMENAME}

Traverse through 13 new levels as you stop the evil king bowser
and his deadly invasion from taking over the mushroom kingdom,
sugar star forest and dear ol' Yoshi's island...

Take on the koopa kids and bowser himself in even more difficult
battles than before! And lastly, dont forget to save your power
ups because toad houses are something you wont see many of in
this adventure! oh...and wasn't there something on the top
floor of the castle?

Source:			http://rvlution.net/forums/viewtopic.php?f=53&t=1352
Base Image:		New Super Mario Bros. Wii (SMN?01)
Supported Versions:	EURv1, EURv2, USAv1, USAv2, JPNv1
************************************************"

}

check_input_image_special () {

	if [[ ! ${IMAGE} ]]; then
		if test -f SMN?01.wbfs; then
			IMAGE=SMN?01.wbfs
		elif test -f SMN?01.iso; then
			IMAGE=SMN?01.iso
		else
			echo -e "please specify image to use with --iso=<path>"
			exit 1
		fi
	fi

}

detect_game_version () {


	if [[ -f ${WORKDIR}/files/COPYDATE_LAST_2009-10-03_232911 ]]; then
		VERSION=EURv1
		REG_LETTER=P
	elif [[ -f ${WORKDIR}/files/COPYDATE_LAST_2010-01-05_152101 ]]; then
		VERSION=EURv2
		REG_LETTER=P
	elif [[ -f ${WORKDIR}/files/COPYDATE_LAST_2009-10-03_232303 ]]; then
		VERSION=USAv1
		REG_LETTER=E
	elif [[ -f ${WORKDIR}/files/COPYDATE_LAST_2010-01-05_143554 ]]; then
		VERSION=USAv2
		REG_LETTER=E
	elif [[ -f ${WORKDIR}/files/COPYDATE_LAST_2009-10-03_231655 ]]; then
		VERSION=JPNv1
		REG_LETTER=J
	elif [[ ! ${VERSION} ]]; then
		echo -e "please specify your games version using --version={EURv1,EURv2,USAv1,USAv2,JPNv1}"
		exit 1
	fi

	GAMEID=SMN${REG_LETTER}09

}

place_files () {

	NEW_DIRS=( ${WORKDIR}/files/NewerRes ${WORKDIR}/files/EU/NedEU )
	for dir in ${NEW_DIRS[@]}; do
		mkdir -p ${dir}
	done

	cp -r "${RIIVOLUTION_DIR}"/Koopa/EU/EngEU/{m,M}essage

	case ${VERSION} in
		EUR* )
			LANGDIRS=( EngEU FraEU GerEU ItaEU SpaEU NedEU )
			for dir in ${LANGDIRS[@]}; do
				cp -r "${RIIVOLUTION_DIR}"/Koopa/EU/EngEU/Message/ ${WORKDIR}/files/EU/${dir}/
			done
			cp "${RIIVOLUTION_DIR}"/Koopa/OpeningP/* ${WORKDIR}/files/EU/Layout/openingTitle/
		;;

		USAv* )
			LANGDIRS=( FraUS EngUS SpaUS )
			for dir in ${LANGDIRS[@]}; do
				cp -r "${RIIVOLUTION_DIR}"/Koopa/EU/EngEU/Message/ ${WORKDIR}/files/US/${dir}/
			done
			cp "${RIIVOLUTION_DIR}"/Koopa/OpeningE/* ${WORKDIR}/files/US/Layout/openingTitle/
		;;

		JPNv1 )
			cp -r "${RIIVOLUTION_DIR}"/Koopa/EU/EngEU/Message/ ${WORKDIR}/files/JP/
			cp "${RIIVOLUTION_DIR}"/Koopa/OpeningJ/* ${WORKDIR}/files/JP/Layout/openingTitle/
		;;
	esac

	cp "${RIIVOLUTION_DIR}"/Koopa/Stage/Texture/* ${WORKDIR}/files/Stage/Texture/
	cp "${RIIVOLUTION_DIR}"/Koopa/NewerRes/* ${WORKDIR}/files/NewerRes/
	cp "${RIIVOLUTION_DIR}"/Koopa/Stage/*.arc ${WORKDIR}/files/Stage/
	cp "${RIIVOLUTION_DIR}"/Koopa/Env/* ${WORKDIR}/files/Env/
	cp "${RIIVOLUTION_DIR}"/Koopa/sound/stream/* ${WORKDIR}/files/Sound/stream/
	cp "${RIIVOLUTION_DIR}"/Koopa/sound/*.brsar ${WORKDIR}/files/Sound/
	cp "${RIIVOLUTION_DIR}"/Koopa/WorldMap/* ${WORKDIR}/files/WorldMap/
	cp "${RIIVOLUTION_DIR}"/Koopa/Object/* ${WORKDIR}/files/Object/
	cp -r "${RIIVOLUTION_DIR}"/Koopa/Layout/preGame.arc ${WORKDIR}/files/Layout/preGame/
	# fixes
	cp patches/01-03.arc ${WORKDIR}/files/Stage/
	cp patches/08-01.arc ${WORKDIR}/files/Stage/

}


dolpatch() {

	cp "${XML_FILE}" "${XML_FILE}".new
	sed -e 's/80001800/803482C0/g' -i "${XML_FILE}".new
	XML_FILE="${XML_FILE}".new

	${WIT} dolpatch ${DOL} xml="${XML_FILE}" -s "${XML_SOURCE}" \
		"802F148C=53756D6D53756E#7769696D6A3264" \
		"802F118C=53756D6D53756E#7769696D6A3264" \
		"802F0F8C=53756D6D53756E#7769696D6A3264" \
		xml="patches/KoopaCountry-Loader.xml" -q

	${WIT} dolpatch ${DOL} xml="patches/NSMBW_AP.xml" -q

}