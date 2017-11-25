ifdef LOCAL
export LOCAL
endif

ifdef DEBUG
export DEBUG
endif

ifdef BUILD
override undefine LOCAL
export BUILD
endif

PROJECT_NAME		?= ancistrus
PROJECT_TARGET		?= D7000
PROJECT_FOUNDER		?= negan07
PROJECT_PLOT		?= "Netgear's $(PROJECT_TARGET) Nighthawk Router Experience Distributed Project"
LICENSE_NAME		?= GPLv2
PROJECT_LICENSE		?= "License: $(LICENSE_NAME)"

GITHUB_DIR		?= https://github.com/$(PROJECT_FOUNDER)/$(PROJECT_NAME)
PROJECT_HOMEPAGE	?= https://$(PROJECT_FOUNDER).github.io/$(PROJECT_NAME)
PROJECT_REP_ROOT	?= https://raw.githubusercontent.com/$(PROJECT_FOUNDER)/$(PROJECT_NAME)/gh-pages
LOCAL_REP_ROOT		?= https://192.168.0.51

FWVER			?= V1.0.1.48
CPU_ARCH_NAME		?= ARM
RCBOOT			?= /usr/etc/rcS

OPKG_PKG_DIR		?= build
DIFFS_DIR		?= diffs
LBIN_DIR		?= localbin
SCRIPTS_DIR		?= scripts
WORK_SRC_DIR		?= work
DEBUG_DIR		?= /home/ftp
RECEIVE_DIR		?= /tmp/etc/ancdbg

SRC_DIR			?= $(PROJECT_TARGET)_$(FWVER)_WW_src
SRC_APPS_DIR		?= $(SRC_DIR)/Source/apps
SRC_REL_DIR		?= ../$(SRC_DIR)
SRC_APPS_REL_DIR	?= $(SRC_REL_DIR)/Source/apps
SRC_BUILDS_REL_DIR	?= Source/Builds
SRC_TARGET_REL_DIR	?= Source/target
SRC_URL			?= http://www.downloads.netgear.com/files/GPL
SRC_FILE		?= $(PROJECT_TARGET)_WW_src.tar.bz2_$(FWVER).zip

TCHAIN_SRC_DIR		?= crosstools-gcc-4.6-linux-3.4-uclibc-0.9.32-binutils-2.21-sources
TCHAIN_TAR		?= $(SRC_DIR)/Source/$(TCHAIN_SRC_DIR).tar.bz2
TCHAIN_BROOT_DL_DIR	?= src/buildroot-2011.11/dl
TCHAIN_INST_DIR		?= /opt/toolchains

TCHAIN_MIPS_DIR		?= $(TCHAIN_INST_DIR)/crosstools-mips-gcc-4.6-linux-3.4-uclibc-0.9.32-binutils-2.21/usr/bin
TCHAIN_ARM_DIR		?= $(TCHAIN_INST_DIR)/crosstools-arm-gcc-4.6-linux-3.4-uclibc-0.9.32-binutils-2.21-NPTL/usr/bin
TCHAIN_MIPSEL_DIR	?= $(TCHAIN_INST_DIR)/crosstools-mipsel-gcc-4.6-linux-3.4-uclibc-0.9.32-binutils-2.21/usr/bin
TCHAIN_I386_DIR		?= /usr/bin/

TARGET_MIPS		?= mips-unknown-linux-uclibc
TARGET_ARM		?= arm-unknown-linux-uclibcgnueabi
TARGET_MIPSEL		?= mipsel-unknown-linux-uclibc
TARGET_I386		?= 

PREFIX_MIPS		?= $(TARGET_MIPS)-
PREFIX_ARM		?= $(TARGET_ARM)-
PREFIX_MIPSEL		?= $(TARGET_MIPSEL)-
PREFIX_I386		?= $(TARGET_I386)

TCHAIN_DIR		?= $(TCHAIN_$(CPU_ARCH_NAME)_DIR)
TCHAIN_PREFIX		?= $(PREFIX_$(CPU_ARCH_NAME))
TCHAIN_PATH		?= $(TCHAIN_DIR)/$(TCHAIN_PREFIX)

