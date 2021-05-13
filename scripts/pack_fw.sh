#!/bin/sh
#
# ancistrus
#
# Netgear's D7000 (V1) Nighthawk Router Experience Distributed Project
#
# https://github.com/negan07/ancistrus
#
# License: GPLv2
#
#
# Prepare firmware .zip pack after compiling.
#
# Usage: $0
#
# This script starts working from the git root source dir.
# Firmware image file .img must be present.
# Old build revision version number must be present on git remote in order to calculate last commit log lines.
#

while [ ! -d .git ] && [ "`pwd`" != "/" ]; do cd ..; done
[ ! -d .git ] && echo "`basename ${PWD}` not a git root dir" && exit 5
PROJ=$(basename -s .git `git config --get remote.origin.url`)

OLDVER=$(basename `git ls-remote --tags origin | tail -n 1 | awk '{printf $2}'` 2>/dev/null)
[ -z "${OLDVER}" ] && echo "Old build revision version number missed" && exit 4

SRCDIR=`for F in *; do echo ${F} | grep _WW_src | sed "s/_WW_src//"; done | head -n 1`
[ -z "${SRCDIR}" ] && echo "Source dir tree missed" && exit 3
BOARD=${SRCDIR%_*}
ORIGFWVER=${SRCDIR#*_}

VER=`git rev-list --count HEAD`
IMG_NAME=${BOARD}-${ORIGFWVER}_1.0.1-${PROJ}_${USER}-build-${VER}
[ ! -e  ${IMG_NAME}.img ] && echo "Firmware image: ${IMG_NAME}.img not present" && exit 2

LOG_FILE=commit_log_${VER}
git log --pretty='format:%<(10)%an%<(20)%ad%<(20)%s' --date=format:'%d/%m/%Y  %H:%M' | head -n $(( ${VER} - ${OLDVER} )) >${LOG_FILE}

sudo chown -Rf ${USER}:${USER} build localbin scripts work *.img
zip -j9T ${IMG_NAME}.zip ${IMG_NAME}.img DISCLAIMER LICENSE ${LOG_FILE}
[ $? -ne 0 ] && echo "Error occurred creating archive: ${IMG_NAME}.zip" && exit 1

exit 0
