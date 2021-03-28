# COMMON NAMES
export RCBIN		:= rc
export RCAPP		:= rc_app
export RCAPPSBIN	:= rc_apps
export RCSSCR		:= rcS
export INITD		:= init.d
export RCSD		:= $(RCSSCR).d
export RCPRE		:= rc.pre
export RCPOST		:= rc.post
export RCFW		:= rc.fw
export RCSCH		:= rc.sch
export USBSERV		:= usb_service
# RELEASE + DEBUG
ifndef LOCAL
PROFILE_ARCH		:= $(CPU_ARCH)
export TMPDIR		:= /tmp
export TMPETC		:= /etc
export VARLIB		:= /var
export USRDIR		:= /usr
# RELEASE
ifndef DEBUG
# ROOT DIRS
export LDLIB		:= /lib
export LDLIBMOD		:= $(LDLIB)/modules
export CONFDIR		:= /config
export NVRAMDIR		:= $(CONFDIR)/nvram
export ETCADSL		:= $(TMPETC)/adsl
export USRETC		:= $(USRDIR)$(TMPETC)
export USRETCADSL	:= $(USRETC)/adsl
export USRETCINITD	:= $(USRETC)/$(INITD)
export USRETCINITDRCSD	:= $(USRETCINITD)/$(RCSD)
export USRETCINITDPRE	:= $(USRETCINITD)/$(RCPRE)
export USRETCINITDPOST	:= $(USRETCINITD)/$(RCPOST)
export USRETCINITDFW	:= $(USRETCINITD)/$(RCFW)
export USRETCINITDSCH	:= $(USRETCINITD)/$(RCSCH)
export USRETCINITDPUSB	:= $(USRETCINITDPOST)/$(USBSERV)
export ROOTUSR		:= $(USRDIR)
export USRSBIN		:= $(USRDIR)/sbin
export USRSBINSCR	:= $(USRSBIN)/scripts
export USRSBINRCAPP	:= $(USRSBIN)/$(RCAPP)
export WWW		:= /www.eng
# ROOT BINS
export RC		:= $(USRSBIN)/$(RCBIN)
export RCAPPS		:= $(USRSBINRCAPP)/$(RCAPPSBIN)
# INSTALL DIRS
export TMPINSTDIR	:= $(PREFIX)$(TMPDIR)
export ETCDIR		:= $(PREFIX)$(USRETC)
export ADSLDIR		:= $(ETCDIR)/adsl
export INITDIR		:= $(ETCDIR)/$(INITD)
export RCSDIR		:= $(INITDIR)/$(RCSD)
export PREDIR		:= $(INITDIR)/$(RCPRE)
export POSTDIR		:= $(INITDIR)/$(RCPOST)
export FWDIR		:= $(INITDIR)/$(RCFW)
export SCHDIR		:= $(INITDIR)/$(RCSCH)
export USBSERVDIR	:= $(POSTDIR)/$(USBSERV)
export ROOTUSRDIR	:= $(PREFIX)$(USRDIR)
export BINDIR		:= $(PREFIX)$(USRSBIN)
export APPDIR		:= $(BINDIR)/$(RCAPP)
export SCRDIR		:= $(BINDIR)/scripts
export LIBDIR		:= $(PREFIX)$(LDLIB)
export MODDIR		:= $(LIBDIR)/modules
export WWWDIR		:= $(PREFIX)$(WWW)
# DEBUG
else
# ROOT DIRS
export LDLIB		:= $(RECEIVE_DIR)
export LDLIBMOD		:= $(RECEIVE_DIR)
export CONFDIR		:= $(RECEIVE_DIR)
export NVRAMDIR		:= $(RECEIVE_DIR)
export ETCADSL		:= $(RECEIVE_DIR)
export USRETC		:= $(RECEIVE_DIR)
export USRETCADSL	:= $(RECEIVE_DIR)
export USRETCINITD	:= $(RECEIVE_DIR)/$(INITD)
export USRETCINITDRCSD	:= $(USRETCINITD)/$(RCSD)
export USRETCINITDPRE	:= $(USRETCINITD)/$(RCPRE)
export USRETCINITDPOST	:= $(USRETCINITD)/$(RCPOST)
export USRETCINITDFW	:= $(USRETCINITD)/$(RCFW)
export USRETCINITDSCH	:= $(USRETCINITD)/$(RCSCH)
export USRETCINITDPUSB	:= $(USRETCINITDPOST)/$(USBSERV)
export ROOTUSR		:= $(RECEIVE_DIR)
export USRSBIN		:= $(RECEIVE_DIR)
export USRSBINSCR	:= $(RECEIVE_DIR)
export USRSBINRCAPP	:= $(RECEIVE_DIR)
export WWW		:= $(RECEIVE_DIR)/$(WWW)
# ROOT BINS
export RC		:= $(RECEIVE_DIR)/$(RCBIN)
export RCAPPS		:= $(RECEIVE_DIR)/$(RCAPPSBIN)
# INSTALL DIRS
export TMPINSTDIR	:= $(PREFIX)
export ETCDIR		:= $(PREFIX)
export ADSLDIR		:= $(PREFIX)
export INITDIR		:= $(PREFIX)
export RCSDIR		:= $(PREFIX)
export PREDIR		:= $(PREFIX)
export POSTDIR		:= $(PREFIX)
export FWDIR		:= $(PREFIX)
export SCHDIR		:= $(PREFIX)
export USBSERVDIR	:= $(PREFIX)
export ROOTUSRDIR	:= $(PREFIX)
export BINDIR		:= $(PREFIX)
export APPDIR		:= $(PREFIX)
export SCRDIR		:= $(PREFIX)
export LIBDIR		:= $(PREFIX)
export MODDIR		:= $(PREFIX)
export WWWDIR		:= $(PREFIX)
endif
# LOCAL
else
PROFILE_ARCH		:= I386
# ROOT DIRS
export TMPDIR		:= $(PREFIX)/tmp
export TMPETC		:= $(TMPDIR)/etc
export VARLIB		:= $(PREFIX)/var
export USRDIR		:= $(PREFIX)/usr
export LDLIB		:= $(PREFIX)/lib
export LDLIBMOD		:= $(LDLIB)/modules
export CONFDIR		:= $(PREFIX)/config
export NVRAMDIR		:= $(CONFDIR)/nvram
export ETCADSL		:= $(TMPETC)/adsl
export USRETC		:= $(USRDIR)/etc
export USRETCADSL	:= $(USRETC)/adsl
export USRETCINITD	:= $(USRETC)/$(INITD)
export USRETCINITDRCSD	:= $(USRETCINITD)/$(RCSD)
export USRETCINITDPRE	:= $(USRETCINITD)/$(RCPRE)
export USRETCINITDPOST	:= $(USRETCINITD)/$(RCPOST)
export USRETCINITDFW	:= $(USRETCINITD)/$(RCFW)
export USRETCINITDSCH	:= $(USRETCINITD)/$(RCSCH)
export USRETCINITDPUSB	:= $(USRETCINITDPOST)/$(USBSERV)
export ROOTUSR		:= $(USRDIR)
export USRSBIN		:= $(USRDIR)/sbin
export USRSBINSCR	:= $(USRSBIN)/scripts
export USRSBINRCAPP	:= $(USRSBIN)/$(RCAPP)
export WWW		:= $(PREFIX)/$(WWW)
# ROOT BINS
export RC		:= $(USRSBIN)/$(RCBIN)
export RCAPPS		:= $(USRSBINRCAPP)/$(RCAPPSBIN)
# INSTALL DIRS
export TMPINSTDIR	:= $(TMPDIR)
export ETCDIR		:= $(TMPETC)
export ADSLDIR		:= $(TMPETC)/adsl
export INITDIR		:= $(TMPETC)/$(INITD)
export RCSDIR		:= $(INITDIR)/$(RCSD)
export PREDIR		:= $(INITDIR)/$(RCPRE)
export POSTDIR		:= $(INITDIR)/$(RCPOST)
export FWDIR		:= $(INITDIR)/$(RCFW)
export SCHDIR		:= $(INITDIR)/$(RCSCH)
export USBSERVDIR	:= $(POSTDIR)/$(USBSERV)
export ROOTUSRDIR	:= $(USRDIR)
export BINDIR		:= $(USRSBIN)
export APPDIR		:= $(BINDIR)/$(RCAPP)
export SCRDIR		:= $(BINDIR)/scripts
export LIBDIR		:= $(LDLIB)
export MODDIR		:= $(LIBDIR)/modules
export WWWDIR		:= $(PREFIX)$(WWW)
endif
# SOURCE DIRS
export SHARED_DIR 	:= $(SOURCE_PATH)/Source/shared
export KERNEL_DIR 	:= $(SOURCE_PATH)/Source/kernel
export KERNEL_INC 	:= $(KERNEL_DIR)/include
export KERNEL_BIN	:= $(KERNEL_DIR)/../../bin
export KERNEL_SRC 	:= $(KERNEL_DIR)
export APPS_DIR		:= $(SOURCE_PATH)/Source/apps
export RC_LIBS_DIR	:= $(APPS_DIR)/rc
export SC_LIBSLINK_DIR	:= $(APPS_DIR)/sc_libs/liblink
# MIPS
ifeq ($(PROFILE_ARCH),MIPS)
export ARCH		:= mips
export ARCH_ENDIAN	:= big
export ENDIAN_FLAGS	:= -b
export TOOLCHAIN	:= $(TCHAIN_MIPS_DIR)
export TARGET_NAME	:= $(TARGET_MIPS)
export CROSS		:= $(PREFIX_MIPS)
endif
# ARM
ifeq ($(PROFILE_ARCH),ARM)
export ARCH		:= arm
export ARCH_ENDIAN	:= little
export ENDIAN_FLAGS	:= -l
export TOOLCHAIN	:= $(TCHAIN_ARM_DIR)
export TARGET_NAME	:= $(TARGET_ARM)
export CROSS		:= $(PREFIX_ARM)
endif
# MIPSEL
ifeq ($(PROFILE_ARCH),MIPSEL)
export ARCH		:= mips
export ARCH_ENDIAN	:= little
export ENDIAN_FLAGS	:= -l
export TOOLCHAIN	:= $(TCHAIN_MIPSEL_DIR)
export TARGET_NAME	:= $(TARGET_MIPSEL)
export CROSS		:= $(PREFIX_MIPSEL)
endif
# LOCAL
ifeq ($(PROFILE_ARCH),I386)
export ARCH		:= i386
export ARCH_ENDIAN	:= little
export ENDIAN_FLAGS	:= -l
export TOOLCHAIN	:= $(TCHAIN_I386_DIR)
export TARGET_NAME	:= $(TARGET_I386)
export CROSS		:= $(PREFIX_I386)
endif
# HOST VARS
export PATH 		:= $(PATH):$(TOOLCHAIN)
export BUILD_HOST	:= x86_64-unknown-linux-gnu
# TOOLCHAIN BINS
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
# STRIP FLAGS
export STRIPFLAGS 	:= -x -R .note -R .comment -R .version --strip-unneeded
export STRIPKOFLAGS	:= -d --strip-unneeded
# MIPS GCC FLAGS
ifeq ($(ARCH),mips)
export CFLAGS 		:= -mips32 -march=mips32 -mtune=mips32 -Wa,-mips32 -G 0 -pipe -funit-at-a-time -fomit-frame-pointer -fno-strict-aliasing -fno-common -mno-shared -mabi=32 -msoft-float
endif
# ARM GCC FLAGS
ifeq ($(ARCH),arm)
export CFLAGS 		:= -marm -march=armv7-a -mcpu=cortex-a9 -mtune=cortex-a9 -pipe -funit-at-a-time -fomit-frame-pointer -ffixed-r8 -fno-common -mno-thumb-interwork -mabi=aapcs-linux -mfloat-abi=soft
endif
# HOST GCC FLAGS
ifeq ($(ARCH),i386)
export CFLAGS 		:= -fomit-frame-pointer
endif

