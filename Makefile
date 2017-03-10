include Settings.mak


all: toolchain sources

download: download_work 

clean: clean_toolchain clean_sources

dist_clean: dist_clean_sources dist_clean_work

prepare_host:
	@./hostprepare.sh
	@echo "close and open a new shell terminal now, or reboot the machine"

toolchain: prepare_toolchain
	@if [ ! -d $(TCHAIN_DIR) ]; then \
	cd $(TCHAIN_SRC_DIR); sudo $(MAKE); \
	fi

prepare_toolchain: download_sources
	@if [ ! -d $(TCHAIN_DIR) ]; then \
	./tchainprepare.sh $(PROJECT_TARGET) $(FWVER) $(DIFFS_DIR) \
	$(SRC_DIR) $(TCHAIN_SRC_DIR) $(TCHAIN_TAR) $(TCHAIN_INST_DIR) $(TCHAIN_BROOT_DL_DIR); \
	fi

sources: patch_sources
	@cd $(SRC_DIR); sudo $(MAKE) kernel && sudo $(MAKE) source;

download_sources:
	@./dl_sources.sh $(SRC_DIR) $(SRC_URL) $(SRC_FILE)

patch_sources: download_sources
	@if [ ! -f $(SRC_DIR)/.patched ]; then \
	$(foreach D, "misc" "kernel" "uclibc" "apps", \
	./apply_patch.sh $(PROJECT_TARGET) $(FWVER) $(DIFFS_DIR) $D || exit 1;) \
	touch $(SRC_DIR)/.patched; \
	fi

work: download_sources
	@if [ -d  $(WORK_SRC_DIR) ]; then \
	cd $(WORK_SRC_DIR); $(MAKE); \
	fi

prepare_work: download_sources
	@if [ -d  $(WORK_SRC_DIR) ]; then \
	cd $(WORK_SRC_DIR); $(MAKE) prepare; \
	fi

download_work: download_sources
	@if [ -d  $(WORK_SRC_DIR) ]; then \
	cd $(WORK_SRC_DIR); $(MAKE) download; \
	fi

clean_toolchain:
	@echo "Removing toolchain source dir: $(TCHAIN_SRC_DIR) ..."
	@sudo rm -rf $(TCHAIN_SRC_DIR)

dist_clean_toolchain: clean_toolchain
	@echo "Removing all built toolchains on: $(TCHAIN_INST_DIR) ..."
	@sudo rm -rf $(TCHAIN_INST_DIR)

clean_sources:
	@if [ -d  $(SRC_DIR) ]; then \
	cd $(SRC_DIR); sudo $(MAKE) all_clean ; \
	fi

dist_clean_sources:
	@echo "Removing source dir: $(SRC_DIR) ..."
	@sudo rm -rf $(SRC_DIR)

clean_work:
	@if [ -d  $(WORK_SRC_DIR) ]; then \
	cd $(WORK_SRC_DIR); $(MAKE) clean; \
	fi

clean_tars_work:
	@if [ -d  $(WORK_SRC_DIR) ]; then \
	cd $(WORK_SRC_DIR); $(MAKE) clean_tars; \
	fi

dist_clean_work:
	@if [ -d  $(WORK_SRC_DIR) ]; then \
	cd $(WORK_SRC_DIR); $(MAKE) dist_clean; \
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
	@echo ""

help: info
	@echo "make			- download sources, compile & install toolchain, compile sources, compile work-thirdparty create img"
	@echo "make download		- download & extract sources, download/copy & extract work-thirdparty apps without patching"
	@echo "make clean		- cleanup toolchain sources, kernel & app sources (included work-thirdparty apps), target, img"
	@echo "make dist_clean		- delete toolchain source dir, delete source dir, cleanup work & delete previously downloaded dirs"
	@echo "make prepare_host	- tune-up host & install packets needed to make & develop (optional)"
	@echo "make toolchain		- download sources, extract, patch & compile the toolchain"
	@echo "make prepare_toolchain	- download sources, extract & patch the toolchain without compiling"
	@echo "make sources		- download sources, patch and compile kernel, apps, work-thirdparty apps, drivers, target, create img"
	@echo "make download_sources	- download sources from web"
	@echo "make patch_sources	- download sources, extract & patch sources without compiling"
	@echo "make work		- download sources, download/copy, patch & compile work-thirdparty apps"
	@echo "make prepare_work	- download sources, download/copy & patch work-thirdparty apps without compiling"
	@echo "make download_work	- download & extract sources, download/copy & extract work-thirdparty apps without patching"
	@echo "make clean_toolchain	- delete toolchain sources dir"
	@echo "make dist_clean_toolchain- delete toolchain sources dir & delete all built toolchains"
	@echo "make clean_sources	- cleanup kernel & app sources (included work-thirdparty apps), target, img"
	@echo "make dist_clean_sources	- delete sources dir"
	@echo "make clean_work		- cleanup work-thirdparty apps"
	@echo "make clean_tars_work	- delete all previously downloaded work-thirdparty archives"
	@echo "make dist_clean_work	- cleanup work-thirdparty apps & delete all previously downloaded work-thirdparty app dirs"
	@echo "make info		- show project info"
	@echo "make help		- show project info and this help"

