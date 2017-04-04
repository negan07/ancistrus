include Settings.mak


all: toolchain sources

download: download_work 

clean: clean_toolchain clean_sources

dist_clean: dist_clean_sources dist_clean_work

prepare_host:
	@./$(SCRIPTS_DIR)/hostprepare.sh
	@echo "close and open a new shell terminal now, or reboot the machine"

toolchain: prepare_toolchain
	@if [ ! -d $(TCHAIN_DIR) ]; then \
	sudo $(MAKE) -C $(TCHAIN_SRC_DIR); \
	fi

prepare_toolchain: download_sources
	@if [ ! -d $(TCHAIN_DIR) ]; then \
	./$(SCRIPTS_DIR)/tchainprepare.sh $(PROJECT_TARGET) $(FWVER) $(DIFFS_DIR) $(SRC_DIR) \
	$(TCHAIN_SRC_DIR) $(TCHAIN_TAR) $(TCHAIN_INST_DIR) $(TCHAIN_BROOT_DL_DIR); \
	fi

sources: patch_sources
	@cd $(SRC_DIR); sudo $(MAKE) kernel && sudo $(MAKE) source;

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
	@if [ -d $(WORK_SRC_DIR) ]; then \
	$(MAKE) -C $(WORK_SRC_DIR); \
	fi

prepare_work: download_sources
	@if [ -d $(WORK_SRC_DIR) ]; then \
	$(MAKE) -C $(WORK_SRC_DIR) prepare; \
	fi

download_work: download_sources
	@if [ -d $(WORK_SRC_DIR) ]; then \
	$(MAKE) -C $(WORK_SRC_DIR) download; \
	fi

ipk: prepare_ipk build_ipk index_ipk

prepare_ipk: work
	@if [ -d $(WORK_SRC_DIR) ]; then \
	$(MAKE) BUILD=1 -C $(WORK_SRC_DIR) prepare_package; \
	fi

build_ipk:
	@if [ -d $(WORK_SRC_DIR) ]; then \
	$(MAKE) BUILD=1 -C $(WORK_SRC_DIR) build_package; \
	fi

index_ipk:
	@if [ -d $(WORK_SRC_DIR) ]; then \
	$(MAKE) BUILD=1 -C $(WORK_SRC_DIR) build_index; \
	fi

clean_toolchain:
	@echo "Removing toolchain source dir: $(TCHAIN_SRC_DIR) ..."
	@sudo rm -rf $(TCHAIN_SRC_DIR)

dist_clean_toolchain: clean_toolchain
	@echo "Removing all built toolchains on: $(TCHAIN_INST_DIR) ..."
	@sudo rm -rf $(TCHAIN_INST_DIR)

clean_sources:
	@if [ -d $(SRC_DIR) ]; then \
	sudo $(MAKE) -C $(SRC_DIR) all_clean; \
	fi

dist_clean_sources:
	@echo "Removing source dir: $(SRC_DIR) ..."
	@sudo rm -rf $(SRC_DIR)

clean_work:
	@if [ -d $(WORK_SRC_DIR) ]; then \
	$(MAKE) -C $(WORK_SRC_DIR) clean; \
	fi

clean_tars_work:
	@if [ -d $(WORK_SRC_DIR) ]; then \
	$(MAKE) -C $(WORK_SRC_DIR) clean_tars; \
	fi

clean_ipk:
	@if [ -d $(WORK_SRC_DIR) ]; then \
	$(MAKE) BUILD=1 -C $(WORK_SRC_DIR) clean_build; \
	fi

dist_clean_work:
	@if [ -d $(WORK_SRC_DIR) ]; then \
	$(MAKE) -C $(WORK_SRC_DIR) dist_clean; \
	fi

dist_clean_ipk:
	@if [ -d $(WORK_SRC_DIR) ]; then \
	$(MAKE) BUILD=1 -C $(WORK_SRC_DIR) dist_clean_build; \
	fi

info:
	@echo $(PROJECT_NAME)
	@echo ""
	@echo $(PROJECT_PLOT)
	@echo ""
	@echo $(PROJECT_TARGET)
	@echo ""
	@echo $(GITHUB_DIR)
	@echo ""
	@echo $(PROJECT_LICENSE)
	@echo ""
	@echo ""

help: info
	@echo "make			- download sources, compile & install toolchain, compile sources, compile work-thirdparty, create img"
	@echo "make download		- download & extract sources, download/copy & extract work-thirdparty apps without patching"
	@echo "make clean		- cleanup toolchain sources, kernel & app sources (included work-thirdparty apps), target, img"
	@echo "make dist_clean		- delete toolchain source dir, delete source dir, cleanup work & delete previously downloaded dirs"
	@echo "make prepare_host	- tune-up host & install packets needed to make & develop (optional)"
	@echo "make toolchain		- download sources, extract, patch & compile the toolchain"
	@echo "make prepare_toolchain	- download sources, extract & patch the toolchain without compiling"
	@echo "make sources		- download sources, patch and compile kernel, apps, work-thirdparty apps, drivers, target, create img"
	@echo "make download_sources	- download sources from web"
	@echo "make patch_sources	- download sources, extract & patch sources without compiling"
	@echo "make work		- download sources, download/copy, config, patch, compile work-thirdparty apps"
	@echo "make prepare_work	- download sources, download/copy, config, patch work-thirdparty apps without compiling"
	@echo "make download_work	- download & extract sources, download/copy, extract, config work-thirdparty apps only"
	@echo "make  ipk		- download sources, download/copy, config, patch, compile work-thirdparty apps, build packets & index"
	@echo "make  prepare_ipk	- download sources, download/copy, config, patch, compile work-thirdparty apps, prepare ipk packets"
	@echo "make build_ipk		- build already prepared ipk packages"
	@echo "make index_ipk		- build already prepared ipk packages index"
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

