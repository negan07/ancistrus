include ../Settings.mak
include dirs.mak

GIT_ROOT		:= $(shell cd ..; pwd;)
CUR_PATH		:= $(shell pwd)
CUR_REL_PATH		:= $(notdir $(CUR_PATH))
SRC_PATH_NAME		:= $(shell cd ../$(SRC_DIR); pwd;)
RULES			:= $(CUR_PATH)/Rules.mak
ARCH_LCASE		:= $(shell echo $(CPU_ARCH_NAME) | tr A-Z a-z)
FLOATABI_NAME		:= $(shell tail -n 1 $(TCHAIN_GCC_CONF_ARGS) | cut -d '"' -f 16 )
OPKGBUILD		:= $(ZLIB) $(LIBARCHIVE) $(OPKG)
NUMTHREAD		:= $$((2 * `getconf _NPROCESSORS_ONLN 2>/dev/null || echo 1`))
#NUMTHREAD		:= $$((2 * `grep processor /proc/cpuinfo | wc -l`))

ifneq "$(or $(LOCAL),$(DEBUG))" ""
PREFIX_PATH		:= $(DEBUG_DIR)
else
PREFIX_PATH		:= $(SRC_PATH_NAME)/$(SRC_TARGET_REL_DIR)
endif

ifeq ($(FLOATABI_NAME), $(FPU_TYPE))
FPU_NAME=FPU
endif

ifdef BUILD
BUILD_DIR_PATH		:= $(GIT_ROOT)/$(OPKG_PKG_DIR)
BUILD_TMP		:= $(BUILD_DIR_PATH)/tmp
CTRL_DIR_PATH		:= $(BUILD_TMP)/CONTROL
CTRL			:= $(CTRL_DIR_PATH)/control
CTRL_SCRIPTS		:= preinst postinst prerm postrm
OPKGLIST		:= $(ZLIB) $(LIBARCHIVE) $(OPKG_UTILS)
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
build: prepare_package build_package build_index

prepare_package: creat_rules
	@[ -d $(BUILD_DIR_PATH) ] || mkdir -p -m 0755 $(BUILD_DIR_PATH) || exit 1;
	@$(foreach D, $(SUBDIRS), echo -e "\\e[35m$(CUR_REL_PATH): prepare package \\e[36m$D \\e[0m"; \
	rm -rf $(BUILD_DIR_PATH)/$(D) $(BUILD_TMP); \
	mkdir -p -m 0755 $(BUILD_TMP) || exit 1; \
	mkdir -p -m 0755 $(CTRL_DIR_PATH) || exit 1; \
	echo "Package: $(NAME_$(D))"					> $(CTRL); \
	echo "Version: $(VER_$(D))"					>> $(CTRL); \
	echo "Depends: $(DEP_$(D))"					>> $(CTRL); \
	echo "Section: $(SEC_$(D))"					>> $(CTRL); \
	echo "Architecture: $(ARCH_LCASE)$(PROJECT_TARGET)$(FPU_NAME)"	>> $(CTRL); \
	echo "Maintainer: $(GITHUB_DIR)"				>> $(CTRL); \
	echo "Source: $(GITHUB_DIR)"					>> $(CTRL); \
	echo "Description: $(DESC_$(D))"				>> $(CTRL); \
	echo "OE: $(NAME_$(D))"						>> $(CTRL); \
	echo "Homepage: $(HOME_$(D))"					>> $(CTRL); \
	echo "License: $(LIC_$(D))"					>> $(CTRL); \
	echo "Priority: $(PRIO_$(D))"					>> $(CTRL); \
	$(MAKE) -j$(NUMTHREAD) -C $D install || exit 1; \
	$(foreach S, $(CTRL_SCRIPTS), chmod -f 755 $(CTRL_DIR_PATH)/$(S);) \
	mv -f $(BUILD_TMP) $(BUILD_DIR_PATH)/$(D);)
	@echo -e "\\e[35m$(CUR_REL_PATH): cleanup void \\e[36mPackages \\e[0m";
	@$(foreach R, $(OPKGLIST), rm -rf $(BUILD_DIR_PATH)/$(R);)

build_package:
	@[ -d $(BUILD_DIR_PATH) ] && [ -x ../$(SCRIPTS_DIR)/$(OPKG_UTILS)/opkg-build ]
	@$(foreach D, $(SUBDIRS), echo -e "\\e[35m$(CUR_REL_PATH): build package \\e[36m$D \\e[0m"; \
	echo "$(OPKGLIST)" | grep "$(D)" > /dev/null 2>&1 || [ -d $(BUILD_DIR_PATH)/$(D) ] || exit 1; \
	if [ ! -z $(MONOLITHIC) ]; then echo "$(OPKGLIST)" | grep "$(D)" > /dev/null 2>&1 || \
	../$(SCRIPTS_DIR)/$(OPKG_UTILS)/opkg-build -o root -g root $(BUILD_DIR_PATH)/$(D) $(BUILD_DIR_PATH) || exit 1; \
	else echo "$(OPKGLIST)" | grep "$(D)" > /dev/null 2>&1 || \
	../$(SCRIPTS_DIR)/$(OPKG_UTILS)/opkg-build -T $(TCHAIN_PATH) -o root -g root $(BUILD_DIR_PATH)/$(D) $(BUILD_DIR_PATH) || exit 1; \
	fi;)

build_index:
	@[ -d $(BUILD_DIR_PATH) ] && [ -x ../$(SCRIPTS_DIR)/$(OPKG_UTILS)/opkg-make-index ]
	@echo -e "\\e[35m$(CUR_REL_PATH): build index \\e[36mPackages \\e[0m"
	@cd $(BUILD_DIR_PATH); ../$(SCRIPTS_DIR)/$(OPKG_UTILS)/opkg-make-index -a $(BUILD_DIR_PATH) > Packages || exit 1; \
	gzip -qf Packages || exit 1; gzip -qt Packages.gz || exit 1;

monolithic: build
	@echo -e "\\e[35m$(CUR_REL_PATH): making FS modifications on \\e[36m$(SRC_PATH_NAME)/$(SRC_TARGET_REL_DIR) \\e[0m"
	@cp -f $(SRC_PATH_NAME)/$(SRC_TARGET_REL_DIR)$(RCBOOT) $(SRC_PATH_NAME)/$(SRC_TARGET_REL_DIR)$(RCBOOT).orig
	@echo -e "\\e[35m$(CUR_REL_PATH): opkg install packages on \\e[36m$(SRC_PATH_NAME)/$(SRC_TARGET_REL_DIR) \\e[0m"
	@[ -x $(GIT_ROOT)/$(LBIN_DIR)/opkg ] || exit 1
	@[ -f $(GIT_ROOT)/$(LBIN_DIR)/opkg.conf ] || exit 1
	@$(GIT_ROOT)/$(LBIN_DIR)/opkg -f $(GIT_ROOT)/$(LBIN_DIR)/opkg.conf update || exit 1
	@$(foreach P, $(SUBDIRS), echo "$(OPKGLIST)" | grep "$(P)" > /dev/null 2>&1 || \
	$(GIT_ROOT)/$(LBIN_DIR)/opkg -f $(GIT_ROOT)/$(LBIN_DIR)/opkg.conf install $(NAME_$(P)) || exit 1;)
	@rm -rf $(SRC_PATH_NAME)/$(SRC_TARGET_REL_DIR)/tmp/*

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
	if [ ! -d $(D)/$(D) ] && [ -f $(D)/Makefile.in ]; then \
	FLIST=$$(ls -A $D); \
	mkdir -p -m 0755 $(D)/$(D) || exit 1; \
	cd $D; mv -f $${FLIST} $D || exit 1; cd ..; \
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
	@echo "export FLOATABI		:= $(FLOATABI_NAME)" >> $(RULES)
ifeq ($(FLOATABI_NAME), $(FPU_TYPE))
	@echo "export FPU		:= $(FPU_NAME)" >> $(RULES)
endif
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

