include Settings.mak


all: toolchain sources

orig: toolchain sources_orig

download: download_work 

ipk: prepare_ipk build_ipk index_ipk

clean: clean_toolchain clean_sources

dist_clean: dist_clean_sources dist_clean_work

prepare_host:
	@[ ! -x $(SCRIPTS_DIR)/hostprepare.sh ] || ./$(SCRIPTS_DIR)/hostprepare.sh

pack_fw:
	@[ ! -x $(SCRIPTS_DIR)/pack_fw.sh ] || ./$(SCRIPTS_DIR)/pack_fw.sh

toolchain: prepare_toolchain
	@[ -d $(TCHAIN_DIR) ] || sudo $(MAKE) -C $(TCHAIN_SRC_DIR)

prepare_toolchain: download_sources
	@[ -d $(TCHAIN_DIR) ] || \
	./$(SCRIPTS_DIR)/tchainprepare.sh \
	$(PROJECT_TARGET) $(FWVER) $(DIFFS_DIR) $(SRC_DIR) $(TCHAIN_SRC_DIR) $(TCHAIN_TAR) $(TCHAIN_INST_DIR) $(TCHAIN_BROOT_DL_DIR)

sources: patch_sources
	@cd $(SRC_DIR); sudo $(MAKE) kernel && sudo $(MAKE) source;

sources_orig: patch_sources
	@cd $(SRC_DIR); sudo $(MAKE) kernel && sudo $(MAKE) source_orig;

download_sources:
	@./$(SCRIPTS_DIR)/dl_sources.sh $(SRC_DIR) $(SRC_URL) $(SRC_FILE)

patch_sources: download_sources
	@if [ ! -f $(SRC_DIR)/.patched ]; then \
	cd $(SCRIPTS_DIR); \
	$(foreach D, "misc" "kernel" "uclibc" "apps", ./apply_patch.sh $(PROJECT_TARGET) $(FWVER) $(DIFFS_DIR) $D || exit 1;) \
	cd ..; \
	touch $(SRC_DIR)/.patched; \
	fi

work: download_sources
	@[ ! -d $(WORK_SRC_DIR) ] || $(MAKE) -C $(WORK_SRC_DIR)

prepare_work: download_sources
	@[ ! -d $(WORK_SRC_DIR) ] || $(MAKE) -C $(WORK_SRC_DIR) prepare

download_work: download_sources
	@[ ! -d $(WORK_SRC_DIR) ] || $(MAKE) -C $(WORK_SRC_DIR) download

prepare_ipk: work
	@[ ! -d $(WORK_SRC_DIR) ] || $(MAKE) BUILD=1 -C $(WORK_SRC_DIR) prepare_package

build_ipk:
	@[ ! -d $(WORK_SRC_DIR) ] || $(MAKE) BUILD=1 -C $(WORK_SRC_DIR) build_package

index_ipk:
	@[ ! -d $(WORK_SRC_DIR) ] || $(MAKE) BUILD=1 -C $(WORK_SRC_DIR) build_index

opkg-local:
	@[ ! -d $(WORK_SRC_DIR) ] || $(MAKE) -C $(WORK_SRC_DIR) opkg-local

clean_toolchain:
	@echo "Removing toolchain source dir: $(TCHAIN_SRC_DIR) ..."
	@sudo rm -rf $(TCHAIN_SRC_DIR)

dist_clean_toolchain: clean_toolchain
	@echo "Removing all built toolchains on: $(TCHAIN_INST_DIR) ..."
	@sudo rm -rf $(TCHAIN_INST_DIR)

clean_sources:
	@[ ! -d $(SRC_DIR) ] || sudo $(MAKE) -C $(SRC_DIR) all_clean

dist_clean_sources:
	@echo "Removing source dir: $(SRC_DIR) ..."
	@sudo rm -rf $(SRC_DIR)

clean_work:
	@[ ! -d $(WORK_SRC_DIR) ] || $(MAKE) -C $(WORK_SRC_DIR) clean

clean_tars_work:
	@[ ! -d $(WORK_SRC_DIR) ] || $(MAKE) -C $(WORK_SRC_DIR) clean_tars

clean_ipk:
	@[ ! -d $(WORK_SRC_DIR) ] || $(MAKE) BUILD=1 -C $(WORK_SRC_DIR) clean_build

dist_clean_work:
	@[ ! -d $(WORK_SRC_DIR) ] || $(MAKE) -C $(WORK_SRC_DIR) dist_clean

dist_clean_ipk:
	@[ ! -d $(WORK_SRC_DIR) ] || $(MAKE) BUILD=1 -C $(WORK_SRC_DIR) dist_clean_build

info:
	@echo $(PROJECT_NAME)
	@echo ""
	@echo $(PROJECT_PLOT)
	@echo ""
	@echo $(GITHUB_DIR)
	@echo ""
	@echo $(PROJECT_LICENSE)
	@echo ""
	@echo ""

help: info
	@echo "make			- download sources, compile & install toolchain, compile sources, compile work-thirdparty, create img"
	@echo "make orig		- download sources, compile & install toolchain, compile sources, create img"
	@echo "make download		- download & extract sources, download/copy & extract work-thirdparty apps without patching"
	@echo "make  ipk		- download sources, download/copy, config, patch, compile work-thirdparty apps, build packets & index"
	@echo "make clean		- cleanup toolchain sources, kernel & app sources (included work-thirdparty apps), target, img"
	@echo "make dist_clean		- delete toolchain source dir, delete source dir, cleanup work & delete previously downloaded dirs"
	@echo "make prepare_host	- tune-up host & install packets needed to make & develop (optional)"
	@echo "make pack_fw		- prepare firmware .zip pack after compiling"
	@echo "make toolchain		- download sources, extract, patch & compile the toolchain"
	@echo "make prepare_toolchain	- download sources, extract & patch the toolchain without compiling"
	@echo "make sources		- download sources, patch and compile kernel, apps, work-thirdparty apps, drivers, target, create img"
	@echo "make sources_orig	- download sources, patch and compile kernel, apps, drivers, target, create img"
	@echo "make download_sources	- download sources from web"
	@echo "make patch_sources	- download sources, extract & patch sources without compiling"
	@echo "make work		- download sources, download/copy, config, patch, compile work-thirdparty apps"
	@echo "make prepare_work	- download sources, download/copy, config, patch work-thirdparty apps without compiling"
	@echo "make download_work	- download & extract sources, download/copy, extract, config work-thirdparty apps only"
	@echo "make  prepare_ipk	- download sources, download/copy, config, patch, compile work-thirdparty apps, prepare ipk packets"
	@echo "make build_ipk		- build already prepared ipk packages"
	@echo "make index_ipk		- build already prepared ipk packages index"
	@echo "make opkg-local		- download sources, download/copy, config, patch work-thirdparty apps, compile & install local opkg"
	@echo "make clean_toolchain	- delete toolchain sources dir"
	@echo "make dist_clean_toolchain- delete toolchain sources dir & delete all built toolchains"
	@echo "make clean_sources	- cleanup kernel & app sources (included work-thirdparty apps), target, img"
	@echo "make dist_clean_sources	- delete sources dir"
	@echo "make clean_work		- cleanup work-thirdparty apps"
	@echo "make clean_tars_work	- delete all previously downloaded work-thirdparty archives"
	@echo "make clean_ipk		- cleanup work-thirdparty ipk packet dirs"
	@echo "make dist_clean_work	- cleanup work-thirdparty apps & delete all previously downloaded work-thirdparty app dirs"
	@echo "make dist_clean_ipk	- cleanup work-thirdparty ipk packets build dir"
	@echo "make info		- show project info"
	@echo "make help		- show project info and this help"

