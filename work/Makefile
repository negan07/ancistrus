include ../Settings.mak
include dirs.mak

GIT_ROOT		:= $(shell cd ..; pwd;)
CUR_PATH		:= $(shell pwd)
CUR_REL_PATH		:= $(notdir $(CUR_PATH))
SRC_PATH_NAME		:= $(shell cd ../$(SRC_DIR); pwd;)
RULES			:= $(CUR_PATH)/Rules.mak
ARCH_LCASE		:= $(shell echo $(CPU_ARCH_NAME) | tr A-Z a-z)
OPKGBUILD		:= $(ZLIB) $(ARCHIVE) $(OPKG)
NUMTHREAD		:= $$((2 * `getconf _NPROCESSORS_ONLN 2>/dev/null || echo 1`))
#NUMTHREAD		:= $$((2 * `grep processor /proc/cpuinfo | wc -l`))

ifneq "$(or $(LOCAL),$(DEBUG))" ""
PREFIX_PATH		:= $(DEBUG_DIR)
else
PREFIX_PATH		:= $(SRC_PATH_NAME)/$(SRC_TARGET_REL_DIR)
endif

ifdef BUILD
BUILD_DIR_PATH		:= $(GIT_ROOT)/$(OPKG_PKG_DIR)
BUILD_TMP		:= $(BUILD_DIR_PATH)$(RCTMPDIR)
BUILD_TARGET		:= $(SRC_PATH_NAME)/$(SRC_TARGET_REL_DIR)
IMAGEDIR		:= $(SRC_PATH_NAME)/$(SRC_IMAGE_REL_DIR)
CTRL_DIR_PATH		:= $(BUILD_TMP)/CONTROL
CTRL			:= $(CTRL_DIR_PATH)/control
CTRL_SCRIPTS		:= preinst postinst prerm postrm
ifndef DEBUG
PREFIX_PATH		:= $(BUILD_TMP)
else
PREFIX_PATH		:= $(BUILD_TMP)$(RECEIVE_DIR)
endif
endif


all:    creat_rules prepare
	@$(foreach D, $(SUBDIRS), echo -e "\\e[35m$(CUR_REL_PATH): make \\e[36m$D \\e[0m"; \
	$(MAKE) -j$(NUMTHREAD) -C $D || exit 1;)

install:
	@$(foreach D, $(SUBDIRS), echo -e "\\e[35m$(CUR_REL_PATH): install \\e[36m$D \\e[0m"; \
	$(MAKE) -j$(NUMTHREAD) -C $D install || exit 1;)

opkg-local: creat_rules prepare
	@if [ ! -x $(GIT_ROOT)/$(LBIN_DIR)/opkg ] || [ ! -f $(GIT_ROOT)/$(LBIN_DIR)/opkg.conf ]; then \
	$(foreach D, $(OPKGBUILD), echo -e "\\e[35m$(CUR_REL_PATH): make local \\e[36m$D \\e[0m"; \
	[ ! -f $(D)/h_config ] || $(MAKE) -j$(NUMTHREAD) -C $D distclean; \
	$(MAKE) LOCAL=1 -j$(NUMTHREAD) -C $D; \
	$(MAKE) LOCAL=1 -j$(NUMTHREAD) -C $D install;) \
	$(foreach D, $(OPKGBUILD), echo -e "\\e[35m$(CUR_REL_PATH): make distclean \\e[36m$D \\e[0m"; \
	$(MAKE) -j$(NUMTHREAD) -C $D distclean;) \
	fi

ifdef BUILD
monolithic: build pre_inst opkg_inst post_inst

build: prepare_package build_package build_index

prepare_package: creat_rules
	@[ -d $(BUILD_DIR_PATH) ] || mkdir -p -m 0755 $(BUILD_DIR_PATH) || exit 1;
	@$(foreach D, $(SUBDIRS), echo -e "\\e[35m$(CUR_REL_PATH): prepare package \\e[36m$D$(SUBVER_$D) \\e[0m"; \
	rm -rf $(BUILD_DIR_PATH)/$(D) $(BUILD_TMP); \
	mkdir -p -m 0755 $(BUILD_TMP) $(CTRL_DIR_PATH) || exit 1; \
	echo "Package: $(NAME_$(D))"					> $(CTRL); \
	echo "Version: $(VER_$(D))"					>> $(CTRL); \
	echo "Depends: $(DEP_$(D))"					>> $(CTRL); \
	echo "Section: $(SEC_$(D))"					>> $(CTRL); \
	echo "Architecture: $(ARCH_LCASE)$(PROJECT_TARGET)"		>> $(CTRL); \
	echo "Maintainer: $(GITHUB_DIR)"				>> $(CTRL); \
	echo "Source: $(GITHUB_DIR)"					>> $(CTRL); \
	echo "Description: $(DESC_$(D))"				>> $(CTRL); \
	echo "OE: $(NAME_$(D))"						>> $(CTRL); \
	echo "Homepage: $(HOME_$(D))"					>> $(CTRL); \
	echo "License: $(LIC_$(D))"					>> $(CTRL); \
	echo "Priority: $(PRIO_$(D))"					>> $(CTRL); \
	$(MAKE) -j$(NUMTHREAD) -C $D install || exit 1; \
	$(foreach S, $(CTRL_SCRIPTS), chmod -f 755 $(CTRL_DIR_PATH)/$(S);) \
	mv -f $(BUILD_TMP) $(BUILD_DIR_PATH)/$(D)$(SUBVER_$D);)
	@echo -e "\\e[35m$(CUR_REL_PATH): cleanup void \\e[36mPackages \\e[0m";
	@$(foreach R, $(PKG_RM_LIST), rm -rf $(BUILD_DIR_PATH)/$(R)$(SUBVER_$R);)

build_package:
	@[ -d $(BUILD_DIR_PATH) ] && [ -x ../$(SCRIPTS_DIR)/$(OPKG_UTILS)/opkg-build ]
	@$(foreach D, $(SUBDIRS), echo -e "\\e[35m$(CUR_REL_PATH): build package \\e[36m$D$(SUBVER_$D) \\e[0m"; \
	echo "$(PKG_RM_LIST)" | grep "$(D)" > /dev/null 2>&1 || [ -d $(BUILD_DIR_PATH)/$(D)$(SUBVER_$D) ] || exit 1; \
	if [ ! -z $(MONOLITHIC) ]; then echo "$(PKG_RM_LIST)" | grep "$(D)" > /dev/null 2>&1 || \
	../$(SCRIPTS_DIR)/$(OPKG_UTILS)/opkg-build -o root -g root $(BUILD_DIR_PATH)/$(D)$(SUBVER_$D) $(BUILD_DIR_PATH) || exit 1; \
	else echo "$(PKG_RM_LIST)" | grep "$(D)" > /dev/null 2>&1 || \
	../$(SCRIPTS_DIR)/$(OPKG_UTILS)/opkg-build -T $(TCHAIN_PATH) -o root -g root $(BUILD_DIR_PATH)/$(D)$(SUBVER_$D) $(BUILD_DIR_PATH) || exit 1; \
	fi;)

build_index:
	@[ -d $(BUILD_DIR_PATH) ] && [ -x ../$(SCRIPTS_DIR)/$(OPKG_UTILS)/opkg-make-index ]
	@echo -e "\\e[35m$(CUR_REL_PATH): build index \\e[36mPackages \\e[0m"
	@cd $(BUILD_DIR_PATH); ../$(SCRIPTS_DIR)/$(OPKG_UTILS)/opkg-make-index -a $(BUILD_DIR_PATH) > Packages || exit 1; \
	gzip -qf Packages || exit 1; gzip -qt Packages.gz || exit 1;

pre_inst:
	@echo -e "\\e[35m$(CUR_REL_PATH): creating partition dir \\e[36m$(RCINITD) \\e[0m"
	@mkdir -p -m 0777 $(IMAGEDIR)/$(RCINITD) $(BUILD_TARGET)$(RCINITDIR) || exit 1
	@echo -e "\\e[35m$(CUR_REL_PATH): creating partition dir \\e[36mopkg \\e[0m"
	@mkdir -p -m 0777 $(IMAGEDIR)/opkg $(BUILD_TARGET)$(OPKG_INFO_STATUS_DIR) || exit 1
	@echo -e "\\e[35m$(CUR_REL_PATH): removing old mandatory shared lib references on \\e[36m$(BUILD_TARGET) \\e[0m"
	@rm $(BUILD_TARGET)$(RCLDLIB)/libz.so* $(BUILD_TARGET)$(RCLDLIB)/libcrypto.so* $(BUILD_TARGET)$(RCLDLIB)/libssl.so* $(BUILD_TARGET)$(RCLDLIB)/libcurl.so* || exit 1

opkg_inst:
	@echo -e "\\e[35m$(CUR_REL_PATH): opkg install packages on \\e[36m$(BUILD_TARGET) \\e[0m"
	@[ -x $(GIT_ROOT)/$(LBIN_DIR)/opkg ] || exit 1
	@[ -r $(GIT_ROOT)/$(LBIN_DIR)/opkg.conf ] || exit 1
	@$(GIT_ROOT)/$(LBIN_DIR)/opkg -f $(GIT_ROOT)/$(LBIN_DIR)/opkg.conf update || exit 1
	@$(foreach P, $(SUBDIRS), echo "$(PKG_RM_LIST)" | grep "$(P)" > /dev/null 2>&1 || \
	$(GIT_ROOT)/$(LBIN_DIR)/opkg -f $(GIT_ROOT)/$(LBIN_DIR)/opkg.conf install $(NAME_$(P)) || exit 1;)
	@echo -e "\\e[35m$(CUR_REL_PATH): cleanup temp opkg inst files on \\e[36m$(BUILD_TARGET) \\e[0m"
	@$(GIT_ROOT)/$(LBIN_DIR)/opkg -f $(GIT_ROOT)/$(LBIN_DIR)/opkg.conf clean || exit 1
	@rm -rf $(BUILD_TARGET)$(RCTMPDIR)/opkg/ $(BUILD_TARGET)$(RCTMPDIR)$(RCUSRDIR)/

post_inst:
	@echo -e "\\e[35m$(CUR_REL_PATH): making FS post install modifications on \\e[36m$(BUILD_TARGET) \\e[0m"
	@if [ -n "`cat $(BUILD_TARGET)$(OPKG_INFO_STATUS_DIR)/status | grep 'Package: zlib'`" ]; then \
	echo -e "\\e[35m$(CUR_REL_PATH): updating \\e[36mzlib \\e[0m"; \
	mv $(BUILD_TARGET)$(RCTMPDIR)/libz.so* $(BUILD_TARGET)$(RCLDLIB)/ || exit 1; \
	else \
	echo -e "\\e[35m$(CUR_REL_PATH): Error: \\e[36mzlib package is mandatory\\e[0m" && exit 1; \
	fi
	@if [ -n "`cat $(BUILD_TARGET)$(OPKG_INFO_STATUS_DIR)/status | grep 'Package: openssl'`" ]; then \
	echo -e "\\e[35m$(CUR_REL_PATH): updating \\e[36mopenssl \\e[0m"; \
	mv $(BUILD_TARGET)$(RCTMPDIR)/libcrypto.so* $(BUILD_TARGET)$(RCTMPDIR)/libssl.so* $(BUILD_TARGET)$(RCLDLIB)/ || exit 1; \
	mv $(BUILD_TARGET)$(RCTMPDIR)/openssl $(BUILD_TARGET)$(RCBINDIR)/ || exit 1; \
	mv $(BUILD_TARGET)$(RCTMPDIR)/openssl.cnf $(BUILD_TARGET)$(RCBOOTDIR)/ || exit 1; \
	else \
	echo -e "\\e[35m$(CUR_REL_PATH): Error: \\e[36mopenssl package is mandatory\\e[0m" && exit 1; \
	fi
	@if [ -n "`cat $(BUILD_TARGET)$(OPKG_INFO_STATUS_DIR)/status | grep 'Package: curl'`" ]; then \
	echo -e "\\e[35m$(CUR_REL_PATH): updating \\e[36mcurl \\e[0m"; \
	mv $(BUILD_TARGET)$(RCTMPDIR)/libcurl.so* $(BUILD_TARGET)$(RCLDLIB)/ || exit 1; \
	mv $(BUILD_TARGET)$(RCTMPDIR)/curl $(BUILD_TARGET)$(RCBINDIR)/ || exit 1; \
	mv $(BUILD_TARGET)$(RCTMPDIR)/$(RCCRT) $(BUILD_TARGET)$(RCBOOTDIR)/ || exit 1; \
	mv $(BUILD_TARGET)$(RCTMPDIR)/$(RCOPTCRT) $(BUILD_TARGET)$(RCOPTCRTDIR)/ || exit 1; \
	else \
	echo -e "\\e[35m$(CUR_REL_PATH): Error: \\e[36mcurl package is mandatory\\e[0m" && exit 1; \
	fi
	@if [ -n "`cat $(BUILD_TARGET)$(OPKG_INFO_STATUS_DIR)/status | grep 'Package: ancistrus-core'`" ]; then \
	echo -e "\\e[35m$(CUR_REL_PATH): finalizing installation of \\e[36mcore \\e[0m"; \
	mv $(BUILD_TARGET)$(RCTMPDIR)/$(RCBOOT_NAME) $(BUILD_TARGET)$(RCBOOTDIR)/ || exit 1; \
	mv $(BUILD_TARGET)$(RCTMPDIR)/$(RCNVRAMSO) $(BUILD_TARGET)$(RCLDLIB)/ || exit 1; \
	mv $(BUILD_TARGET)$(RCBINDIR)/$(RCDSLCMD) $(BUILD_TARGET)$(RCBINDIR)/$(RCDSLCMDBIN) || exit 1; \
	mv $(BUILD_TARGET)$(RCTMPDIR)/rc_printserver $(BUILD_TARGET)$(RCAPPDIR)/ || exit 1; \
	for L in $(BUILD_TARGET)$(RCBOOTDIR)/$(RCAPPSNAME) $(BUILD_TARGET)$(RCBINDIR)/$(RCDSLCMD); do ln -sf $(RCBINDIR)/$(PROJ_TAG) $$L || exit 1; done; \
	echo -e "\\e[35m$(CUR_REL_PATH): updating \\e[36mmain web pages \\e[0m"; \
	$(foreach F, $(RCMAINWEB), mv $(BUILD_TARGET)$(RCTMPDIR)/$(F) $(BUILD_TARGET)$(RCWWWDIR)/$(F) || exit 1;) \
	$(foreach F, $(RCMAINCSS), mv $(BUILD_TARGET)$(RCTMPDIR)/$(F) $(BUILD_TARGET)$(RCWWWCSSDIR)/$(F) || exit 1;) \
	else \
	echo -e "\\e[35m$(CUR_REL_PATH): Error: \\e[36mcore package is mandatory\\e[0m" && exit 1; \
	fi
	@if [ -n "`cat $(BUILD_TARGET)$(OPKG_INFO_STATUS_DIR)/status | grep 'Package: busybox'`" ]; then \
	echo -e "\\e[35m$(CUR_REL_PATH): updating \\e[36mbusybox \\e[0m"; \
	mv $(BUILD_TARGET)$(RCTMPDIR)/busybox $(BUILD_TARGET)$(RCBINDIR)/ || exit 1; \
	for F in `cat $(BUSYBOX)/busybox.links`; do mv $(BUILD_TARGET)$(RCTMPDIR)/`basename $$F` $(BUILD_TARGET)$(RCBINDIR)/ || exit 1; done; \
	mv $(BUILD_TARGET)$(RCTMPDIR)/profile $(BUILD_TARGET)$(RCBOOTDIR)/ || exit 1; \
	fi
	@if [ -n "`cat $(BUILD_TARGET)$(OPKG_INFO_STATUS_DIR)/status | grep 'Package: qos-sqm'`" ]; then \
	echo -e "\\e[35m$(CUR_REL_PATH): updating \\e[36miproute2@qos-sqm \\e[0m"; \
	rm -r $(BUILD_TARGET)$(RCBOOTDIR)/iproute2 || exit 1; \
	mv $(BUILD_TARGET)$(RCTMPDIR)/iproute2 $(BUILD_TARGET)$(RCBOOTDIR)/ || exit 1; \
	mv $(BUILD_TARGET)$(RCTMPDIR)/ip $(BUILD_TARGET)$(RCTMPDIR)/tc $(BUILD_TARGET)$(RCBINDIR)/ || exit 1; \
	fi
	@if [ -n "`cat $(BUILD_TARGET)$(OPKG_INFO_STATUS_DIR)/status | grep 'Package: mini_httpd'`" ]; then \
	echo -e "\\e[35m$(CUR_REL_PATH): updating \\e[36mmini_httpd \\e[0m"; \
	mv $(BUILD_TARGET)$(RCTMPDIR)/mini_httpd.pem $(BUILD_TARGET)$(RCBOOTDIR)/ || exit 1; \
	mv $(BUILD_TARGET)$(RCTMPDIR)/mini_httpd $(BUILD_TARGET)$(RCBINDIR)/ || exit 1; \
	$(foreach F, $(RCHTTPDWEB), mv $(BUILD_TARGET)$(RCTMPDIR)/$(F) $(BUILD_TARGET)$(RCWWWDIR)/$(F) || exit 1;) \
	fi
	@if [ -n "`cat $(BUILD_TARGET)$(OPKG_INFO_STATUS_DIR)/status | grep 'Package: utelnetd'`" ]; then \
	echo -e "\\e[35m$(CUR_REL_PATH): finalizing installation of \\e[36mutelnetd \\e[0m"; \
	mv $(BUILD_TARGET)$(RCTMPDIR)/rc_debug_mode $(BUILD_TARGET)$(RCAPPDIR)/ || exit 1; \
	fi
	@if [ -n "`cat $(BUILD_TARGET)$(OPKG_INFO_STATUS_DIR)/status | grep 'Package: samba'`" ]; then \
	echo -e "\\e[35m$(CUR_REL_PATH): finalizing installation of \\e[36msamba \\e[0m"; \
	rm $(BUILD_TARGET)$(RCLDLIB)/libntpass.so* || exit 1; \
	[ -f $(BUILD_TARGET)$(RCLDLIB)/libiconv.so.2 ] || ln -sf libiconv.so.0.0 $(BUILD_TARGET)$(RCLDLIB)/libiconv.so.2 || exit 1; \
	fi
	@if [ -n "`cat $(BUILD_TARGET)$(OPKG_INFO_STATUS_DIR)/status | grep 'Package: speedtest-net'`" ]; then \
	echo -e "\\e[35m$(CUR_REL_PATH): finalizing installation of \\e[36mspeedtest-net \\e[0m"; \
	if [ ! -x $(BUILD_TARGET)$(RCBINDIR)/tar ]; then echo -e "\\e[35m$(CUR_REL_PATH): Error: \\e[36mtar cmd missed, busybox package required\\e[0m"; exit 1; fi \
	fi
	@if [ -n "`cat $(BUILD_TARGET)$(OPKG_INFO_STATUS_DIR)/status | grep 'Package: minidlna'`" ]; then \
	echo -e "\\e[35m$(CUR_REL_PATH): finalizing installation of \\e[36mminidlna \\e[0m"; \
	for L in id3tag exif jpeg ogg vorbis FLAC; do rm $(BUILD_TARGET)$(RCLDLIB)/lib$$L.so* || exit 1; done; \
	[ -f $(BUILD_TARGET)$(RCLDLIB)/libiconv.so.2 ] || ln -sf libiconv.so.0.0 $(BUILD_TARGET)$(RCLDLIB)/libiconv.so.2 || exit 1; \
	fi
	@if [ -n "`cat $(BUILD_TARGET)$(OPKG_INFO_STATUS_DIR)/status | grep 'Package: xdsl-driver'`" ]; then \
	echo -e "\\e[35m$(CUR_REL_PATH): updating \\e[36mXDSL driverset \\e[0m"; \
	for F in $(RCDSLKO); do [ ! -f $(BUILD_TARGET)$(RCTMPDIR)/$$F ] || mv $(BUILD_TARGET)$(RCTMPDIR)/$$F $(BUILD_TARGET)$(RCLDLIBMOD)/ || exit 1; done; \
	for F in $(RCDSLDRV); do [ ! -f $(BUILD_TARGET)$(RCTMPDIR)/$$F ] || mv $(BUILD_TARGET)$(RCTMPDIR)/$$F $(BUILD_TARGET)$(RCADSLDIR)/ || exit 1; done; \
	for F in $(RCDSLSO); do [ ! -f $(BUILD_TARGET)$(RCTMPDIR)/$$F ] || mv $(BUILD_TARGET)$(RCTMPDIR)/$$F $(BUILD_TARGET)$(RCLDLIB)/ || exit 1; done; \
	for F in $(RCDSLBINS); do [ ! -f $(BUILD_TARGET)$(RCTMPDIR)/$$F ] || mv $(BUILD_TARGET)$(RCTMPDIR)/$$F $(BUILD_TARGET)$(RCBINDIR)/ || exit 1; done; \
	$(GIT_ROOT)/$(LBIN_DIR)/opkg -f $(GIT_ROOT)/$(LBIN_DIR)/opkg.conf remove `cat $(BUILD_TARGET)$(OPKG_INFO_STATUS_DIR)/status | grep "Package: xdsl-driver" | sed 's/Package: //'` || exit 1; \
	fi
	@echo -e "\\e[35m$(CUR_REL_PATH): checking for tmp inst file presence on \\e[36m$(BUILD_TARGET)$(RCTMPDIR)/ \\e[0m"
	@[ -z "$$(ls -A $(BUILD_TARGET)$(RCTMPDIR)/)" ] || exit 1
	@echo -e "\\e[35m$(CUR_REL_PATH): parsing \\e[36m$(BUILD_TARGET)$(OPKG_INFO_STATUS_DIR)/status \\e[0m"
	@sed -i 's/Status: install user unpacked/Status: install user installed/g' $(BUILD_TARGET)$(OPKG_INFO_STATUS_DIR)/status || exit 1
	@echo -e "\\e[35m$(CUR_REL_PATH): moving $(RCINITD) & opkg dirs content from \\e[36m$(BUILD_TARGET) \\e[0m"
	@mv $(BUILD_TARGET)$(RCINITDIR)/* $(IMAGEDIR)/$(RCINITD) || exit 1
	@mv $(BUILD_TARGET)$(OPKG_INFO_STATUS_DIR)/* $(IMAGEDIR)/opkg || exit 1

clean_build:
	@if [ -d $(BUILD_DIR_PATH) ]; then \
	for D in $$(ls -A $(BUILD_DIR_PATH)); do \
	[ ! -d $$D ] || echo -e "\\e[35m$(CUR_REL_PATH): clean build dir \\e[36m$$D \\e[0m"; \
	[ ! -d $$D ] || rm -rf $(BUILD_DIR_PATH)/$$D; \
	done; \
	fi

dist_clean_build:
	@rm -rf $(BUILD_DIR_PATH) $(GIT_ROOT)/$(LBIN_DIR)
	@rm -f $(OPKG_UTILS)/.installed
endif

download:
	@$(foreach D, $(SUBDIRS), echo -e "\\e[35m$(CUR_REL_PATH): download & extract \\e[36m$D \\e[0m"; \
	[ -d $D ] || ../$(SCRIPTS_DIR)/dl_sources.sh $D $(DL_$D) $(TAR_$D) || exit 1; \
	if [ ! -d $(D)/$(D) ];then \
	if [ -f $(D)/Makefile.in ] || [ -f $(D)/configure.ac ] || [ -f $(D)/configure.in ] || [ -x $(D)/config ] || cat $(D)/configure 2> /dev/null | grep LC_ALL > /dev/null 2>&1; then \
	FLIST=$$(ls -A $D); mkdir -p -m 0755 $(D)/$(D) || exit 1; cd $D; mv -f $${FLIST} $D || exit 1; cd ..; \
	fi; \
	fi;)

patch:
	@$(foreach D, $(SUBDIRS), echo -e "\\e[35m$(CUR_REL_PATH): patch \\e[36m$D \\e[0m"; \
	cd ../$(SCRIPTS_DIR); [ ! -d ../$(CUR_REL_PATH)/$(D) ] || [ -f ../$(CUR_REL_PATH)/$(D)/.patched ] || \
	./apply_patch.sh $(PROJECT_TARGET) $(FWVER) $(DIFFS_DIR) $(CUR_REL_PATH) $D || exit 1; \
	cd ../$(CUR_REL_PATH); [ ! -d $D ] || [ -f $(D)/.patched ] || touch $(D)/.patched;)

prepare: download patch

clean:
	@$(foreach D, $(SUBDIRS), echo -e "\\e[35m$(CUR_REL_PATH): clean \\e[36m$D \\e[0m"; \
	[ ! -d $D ] || $(MAKE) -j$(NUMTHREAD) -C $D clean || exit 1;)

clean_dirs:
	@$(foreach D, $(DIRLIST), echo -e "\\e[35m$(CUR_REL_PATH): clean dir \\e[36m$D \\e[0m"; rm -rf $D;)

clean_tars:
	@$(foreach Z, $(TARLIST), echo -e "\\e[35m$(CUR_REL_PATH): clean archive \\e[36m$Z \\e[0m"; rm -f $Z;)

dist_clean: clean_dirs clean
	@rm -f $(RULES)

creat_rules:
	@echo "# Automatically generated by Makefile: don't edit" > $(RULES)
	@echo "export GIT_NAME		:= $(PROJECT_NAME)" >> $(RULES)
	@echo "export PROJECT		:= $(PROJECT_TARGET)" >> $(RULES)
	@echo "export CPU_ARCH		:= $(CPU_ARCH_NAME)" >> $(RULES)
	@echo "export CPU_LCARCH	:= $(ARCH_LCASE)" >> $(RULES)
	@echo "export GIT_ROOT_DIR	:= $(GIT_ROOT)" >> $(RULES)
	@echo "export WORK_DIR		:= $(CUR_PATH)" >> $(RULES)
	@echo "export SOURCE_PATH 	:= $(SRC_PATH_NAME)" >> $(RULES)
	@echo "export PREFIX		:= $(PREFIX_PATH)" >> $(RULES)
ifdef BUILD
	@echo "export CTRL_DIR		:= $(CTRL_DIR_PATH)" >> $(RULES)
endif
	@echo "include \$$(GIT_ROOT_DIR)/Settings.mak" >> $(RULES)
	@echo "include \$$(WORK_DIR)/dirs.mak" >> $(RULES)
	@echo "include \$$(WORK_DIR)/env.mak" >> $(RULES)
	@echo "include \$$(SOURCE_PATH)/$(SRC_BUILDS_REL_DIR)/\$$(PROJECT).mak" >> $(RULES)

