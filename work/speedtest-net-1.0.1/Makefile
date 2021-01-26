include ../Rules.mak

WEB			:= ../www/$(SPEEDTESTNET_NAME).htm
LICLINK			:= speedtest-net
LICJSON			:= .config/ookla/speedtest-cli.json

all:
	@echo "Nothing to do: run 'make install' to install."

install: control
	for D in $(SCRDIR) $(WWWDIR); do install -m 0755 -d $$D; done
	install -m 0755 *.sh $(SCRDIR)
	install -m 0664 $(WEB) $(WWWDIR)
	ln -sf $(TMPDIR)/$(LICJSON) $(WWWDIR)/$(LICLINK)

clean: 
	@echo "Nothing to clean"

ifndef BUILD
control:
else
PREINST			:= $(CTRL_DIR)/preinst
PRERM			:= $(CTRL_DIR)/prerm

control: preinst prerm

preinst:
	@echo "#!/bin/sh" > $(PREINST)
	@echo "if [ ! -x $(USRSBIN)/tar ]; then" >> $(PREINST)
	@echo "echo \"Missing 'tar' cmd: upgrade or install 'busybox' package.\"" >> $(PREINST)
	@echo "echo \"Type: 'opkg update && opkg install busybox' then install this package again.\"" >> $(PREINST)
	@echo "exit 1" >> $(PREINST)
	@echo "fi" >> $(PREINST)
	@echo "killall -9 speedtest >/dev/null 2>&1" >> $(PREINST)
	@echo "sleep 1" >> $(PREINST)
	@echo "rm -rf $(TMPDIR)/speedtest $(TMPDIR)/.config/ $(TMPETC)/ssl/" >> $(PREINST)
	@echo "exit 0" >> $(PREINST)

prerm:
	@echo "#!/bin/sh" > $(PRERM)
	@echo "killall -9 speedtest >/dev/null 2>&1" >> $(PRERM)
	@echo "sleep 1" >> $(PRERM)
	@echo "rm -rf $(TMPDIR)/speedtest $(TMPDIR)/.config/ $(TMPETC)/ssl/" >> $(PRERM)
	@echo "exit 0" >> $(PRERM)
endif

