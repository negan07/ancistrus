ifndef LOCAL
PROFILE_ARCH	:= arm
export TMPDIR	:= /tmp
ifndef DEBUG
export ETCDIR	:= $(PREFIX)/usr/etc
export BINDIR	:= $(PREFIX)/usr/sbin
export LIBDIR	:= $(PREFIX)/lib
export MODDIR	:= $(LIBDIR)/modules
export WWWDIR	:= $(PREFIX)/www.eng
else
export ETCDIR	:= $(PREFIX)
export BINDIR	:= $(PREFIX)
export LIBDIR	:= $(PREFIX)
export MODDIR	:= $(PREFIX)
export WWWDIR	:= $(PREFIX)
endif
else
PROFILE_ARCH	:= i386
export TMPDIR	:= $(PREFIX)/tmp
export ETCDIR	:= $(TMPDIR)/etc
export BINDIR	:= $(PREFIX)/usr/sbin
export LIBDIR	:= $(PREFIX)/lib
export MODDIR	:= $(LIBDIR)/modules
export WWWDIR	:= $(PREFIX)/www.eng
endif

export SHARED_DIR := $(SOURCE_PATH)/Source/shared
export KERNEL_DIR := $(SOURCE_PATH)/Source/kernel
export KERNEL_INC := $(KERNEL_DIR)/include
export KERNEL_SRC := $(KERNEL_DIR)

TOOLCHAIN_USRBIN_PATH_MIPS   := /opt/toolchains/crosstools-mips-gcc-4.6-linux-3.4-uclibc-0.9.32-binutils-2.21/usr/bin
TOOLCHAIN_USRBIN_PATH_ARM    := /opt/toolchains/crosstools-arm-gcc-4.6-linux-3.4-uclibc-0.9.32-binutils-2.21-NPTL/usr/bin
TOOLCHAIN_USRBIN_PATH_MIPSEL := /opt/toolchains/crosstools-mipsel-gcc-4.6-linux-3.4-uclibc-0.9.32-binutils-2.21/usr/bin
TOOLCHAIN_USRBIN_PATH_I386   := /usr/bin/

PREFIX_MIPS	:= mips-unknown-linux-uclibc-
PREFIX_ARM	:= arm-unknown-linux-uclibcgnueabi-
PREFIX_MIPSEL	:= mipsel-unknown-linux-uclibc-
PREFIX_I386	:= 

ifeq ($(PROFILE_ARCH),mips)
export ARCH		:= mips
export ARCH_ENDIAN	:= big
export ENDIAN_FLAGS	:= -b
export TOOLCHAIN	:= $(TOOLCHAIN_USRBIN_PATH_MIPS)
export CROSS		:= $(PREFIX_MIPS)
endif

ifeq ($(PROFILE_ARCH),arm)
export ARCH		:= arm
export ARCH_ENDIAN	:= little
export ENDIAN_FLAGS	:= -l
export TOOLCHAIN	:= $(TOOLCHAIN_USRBIN_PATH_ARM)
export CROSS		:= $(PREFIX_ARM)
endif

ifeq ($(PROFILE_ARCH),mipsel)
export ARCH		:= mips
export ARCH_ENDIAN	:= little
export ENDIAN_FLAGS	:= -l
export TOOLCHAIN	:= $(TOOLCHAIN_USRBIN_PATH_MIPSEL)
export CROSS		:= $(PREFIX_MIPSEL)
endif

ifeq ($(PROFILE_ARCH),i386)
export ARCH		:= i386
export TOOLCHAIN	:= $(TOOLCHAIN_USRBIN_PATH_I386)
export CROSS		:= $(PREFIX_I386)
endif

export PATH := $(PATH):$(TOOLCHAIN)

export CROSS_COMPILE	:= $(CROSS)
export AR		:= $(CROSS)ar
export AS		:= $(CROSS)as
export LD		:= $(CROSS)ld
export CC		:= $(CROSS)gcc
export CXX		:= $(CROSS)g++
export CPP		:= $(CROSS)cpp
export NM		:= $(CROSS)nm
export STRIP		:= $(CROSS)strip
export OBJCOPY		:= $(CROSS)objcopy
export OBJDUMP		:= $(CROSS)objdump
export RANLIB		:= $(CROSS)ranlib
ifndef LOCAL
export SSTRIP		:= $(CROSS)sstrip
else
export SSTRIP		:= $(STRIP)
endif

export STRIPFLAGS := -x -R .note -R .comment -R .version --strip-unneeded
#export STRIPFLAGS := -x -R .note -R .comment

ifeq ($(ARCH),mips)
export CFLAGS := -mips32 -march=mips32 -mtune=mips32 -Wa,-mips32 -G 0 -pipe -funit-at-a-time -fomit-frame-pointer -fno-strict-aliasing -fno-common -mno-shared -mabi=32 -msoft-float
endif

ifeq ($(ARCH),arm)
export CFLAGS := -marm -march=armv7-a -mcpu=cortex-a9 -mtune=cortex-a9 -mfpu=neon-fp16 -pipe -funit-at-a-time -fomit-frame-pointer -ffixed-r8 -fno-common -mno-thumb-interwork -mabi=aapcs-linux -mfloat-abi=soft
#CFLAGS += -mfloat-abi=softfp
endif

ifeq ($(ARCH),i386)
export CFLAGS := -fomit-frame-pointer
endif

