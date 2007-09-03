#!/bin/sh
set -e

if [ -z $1 ] ; then
	echo Error: specify version number
	exit 1
fi

TARGET=iSFV
CONFIG=Release
FOLDER=Release
FOLDER_SRC=Source
MOUNT=iSFV
MOUNT_SRC=iSFV_SRC
INTERNET=y
TEMPLATE=iSFV_Template.dmg
TEMPLATE_SRC=iSFV_SRC_Template.dmg
MASTER="iSFV-$1.dmg"
MASTER_SRC="iSFV_src-$1.dmg"
SIZE=10m
FILES="iSFV.app"
FILES_SRC='*.{m,h,pch,txt,xcodeproj,icns,lproj,plist}'

SCRIPT_PATH="${PWD}/$(dirname $0)"
PROJECT_PATH="${SCRIPT_PATH}/.."
BUILD_PATH="${PROJECT_PATH}/build/${CONFIG}"

echo Cleaning
cd "$SCRIPT_PATH"
DEV=`hdiutil info | grep "${MOUNT}" | grep "Apple_HFS" | awk '{print $1}'` && \
(hdiutil detach $DEV -quiet -force)
DEV=`hdiutil info | grep "${MOUNT_SRC}" | grep "Apple_HFS" | awk '{print $1}'` && \
(hdiutil detach $DEV -quiet -force)
rm -rf "${TEMPLATE}"
rm -rf "${TEMPLATE_SRC}"
rm -rf "${MASTER}"
rm -rf "${MASTER_SRC}"
rm -rf "${BUILD_PATH}"
rm -rf "${MOUNT}"
rm -rf "${MOUNT_SRC}"

echo Building project
cd "${PROJECT_PATH}"
xcodebuild -target ${TARGET} -configuration ${CONFIG} > "${SCRIPT_PATH}/build.log"

echo Creating template disk image
cd "$SCRIPT_PATH"
hdiutil create -size "${SIZE}" "${TEMPLATE}" -srcfolder "${FOLDER}" -format UDRW -volname "${TARGET}" -quiet

echo Creating master image
mkdir -p "${MOUNT}"
hdiutil attach "${TEMPLATE}" -noautoopen -quiet -mountpoint "${MOUNT}"
for x in ${FILES} ; do
	for i in "${BUILD_PATH}/${x}"; do
		file=`basename "$i"`
		ditto -rsrc "${BUILD_PATH}/${file}" "${MOUNT}/${file}"
	done
done
DEV=`hdiutil info | grep "${MOUNT}" | grep "Apple_HFS" | awk '{print $1}'` && \
hdiutil detach $DEV -quiet -force
hdiutil convert "${TEMPLATE}" -quiet -format UDZO -imagekey zlib-level=9 -o "${MASTER}"
if [ $INTERNET == "y" ] ; then
	hdiutil internet-enable -yes -quiet "${MASTER}"
fi

echo Creating template source disk image
cd "$SCRIPT_PATH"
hdiutil create -size "${SIZE}" "${TEMPLATE_SRC}" -srcfolder "${FOLDER_SRC}" -format UDRW -volname "${TARGET} Source" -quiet

echo Creating master source image
mkdir -p "${MOUNT_SRC}"
hdiutil attach "${TEMPLATE_SRC}" -noautoopen -quiet -mountpoint "${MOUNT_SRC}"
#for x in ${FILES_SRC} ; do
#	eval "x=( ${PROJECT_PATH}/${x} )"
#	for i in ${x[@]} ; do
#		file=`basename "$i"`
#		ditto -rsrc "${PROJECT_PATH}/${file}" "${MOUNT_SRC}/${file}"
#	done
#done
svn export "${PROJECT_PATH}" "${MOUNT_SRC}/Source"
DEV=`hdiutil info | grep "${MOUNT_SRC}" | grep "Apple_HFS" | awk '{print $1}'` && \
hdiutil detach $DEV -quiet -force
hdiutil convert "${TEMPLATE_SRC}" -quiet -format UDZO -imagekey zlib-level=9 -o "${MASTER_SRC}"

echo Cleaning up
rm -rf "${MOUNT}"
rm -rf "${MOUNT_SRC}"
rm -rf "${TEMPLATE}"
rm -rf "${TEMPLATE_SRC}"

echo "Done!  Don't forget to tag the release"