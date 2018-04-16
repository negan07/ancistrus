include ../Rules.mak

DRV			:= adsl_phy.bin

all:
	@echo "Nothing to do: run 'make install' to install."

clean: 
	@echo "Nothing to clean"

install: control
	install -m 0755 -d $(TMPINSTDIR)
	@[ -f $(DRV) ] && install -m 0644 $(DRV) $(TMPINSTDIR)

ifndef BUILD
control:
else
POSTINST		:= $(CTRL_DIR)/postinst

control: postinst

postinst:
	@echo "#!/bin/sh" > $(POSTINST)
	@echo "if [ -f $(TMPDIR)/$(DRV) ]; then" >> $(POSTINST)
	@echo "echo \"Updating XDSL driver...\"" >> $(POSTINST)
	@echo "cp -f $(TMPDIR)/$(DRV) $(USRETCADSL)/$(DRV)" >> $(POSTINST)
	@echo "cp -f $(TMPDIR)/$(DRV) $(ETCADSL)/$(DRV)" >> $(POSTINST)
	@echo "sync" >> $(POSTINST)
	@echo "sleep 2" >> $(POSTINST)
	@echo "echo" >> $(POSTINST)
	@echo "echo \"XDSL driver updated\"" >> $(POSTINST)
	@echo "echo \"Restarting XDSL connection...\"" >> $(POSTINST)
	@echo "xdslctl connection --down" >> $(POSTINST)
	@echo "xdslctl stop" >> $(POSTINST)
	@echo "sleep 2" >> $(POSTINST)
	@echo "xdslctl start" >> $(POSTINST)
	@echo "sleep 2" >> $(POSTINST)
	@echo "xdslctl connection --up" >> $(POSTINST)
	@echo "echo" >> $(POSTINST)
	@echo "echo \"This package can be removed now: type 'opkg remove $(XDSL_042U_NAME)'\"" >> $(POSTINST)
	@echo "fi" >> $(POSTINST)
	@echo "exit 0" >> $(POSTINST)
endif

