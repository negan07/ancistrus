include ../Rules.mak

all:
	@echo "Nothing to do: run 'make install' to install."

clean: 
	@echo "Nothing to clean"

install: control
	install -m 0755 -d $(TMPINSTDIR)
	for F in $(RCDSLKO); do [ -f $$F ] && $(STRIP) $(STRIPFLAGS) $$F; done
	for F in $(RCDSLKO) $(RCDSLDRV); do [ -f $$F ] && install -m 0644 $$F $(TMPINSTDIR); done
	for F in $(RCDSLBINS); do [ -f $$F ] && $(SSTRIP) $$F; done
	for F in $(RCDSLSO) $(RCDSLBINS); do [ -f $$F ] && install -m 0755 $$F $(TMPINSTDIR); done

ifndef BUILD
control:
else
POSTINST		:= $(CTRL_DIR)/postinst

control: postinst

postinst:
	@echo "#!/bin/sh" > $(POSTINST)
	@echo "[ ! -f $(TMPDIR)/$(RCDSLCMDBIN) ] && exit 0" >> $(POSTINST)
	@echo "echo \"Updating XDSL driverset...\"" >> $(POSTINST)
	@echo "for F in $(RCDSLKO); do [ -f $(TMPDIR)/\$$F ] && echo \"Updating XDSL kodrv: \$$F ...\" && mv -f $(TMPDIR)/\$$F $(LDLIBMOD)/; done" >> $(POSTINST)
	@echo "for F in $(RCDSLDRV); do [ -f $(TMPDIR)/\$$F ] && echo \"Updating XDSL drv: \$$F ...\" && cp -f $(TMPDIR)/\$$F $(USRETCADSL)/ && mv -f $(TMPDIR)/\$$F $(ETCADSL)/; done" >> $(POSTINST)
	@echo "for F in $(RCDSLSO); do [ -f $(TMPDIR)/\$$F ] && echo \"Updating XDSL solib: \$$F ...\" && mv -f $(TMPDIR)/\$$F $(LDLIB)/; done" >> $(POSTINST)
	@echo "for F in $(RCDSLBINS); do [ -f $(TMPDIR)/\$$F ] && echo \"Updating XDSL bin: \$$F ...\" && mv -f $(TMPDIR)/\$$F $(USRSBIN)/; done" >> $(POSTINST)
	@echo "[ ! -h $(USRSBIN)/$(RCDSLCMD) ] && [ -f $(USRSBIN)/$(RCDSLCMDBIN) ] && mv -f $(USRSBIN)/$(RCDSLCMDBIN) $(USRSBIN)/$(RCDSLCMD)" >> $(POSTINST)
	@echo "sync" >> $(POSTINST)
	@echo "echo" >> $(POSTINST)
	@echo "echo \"XDSL driverset updated\"" >> $(POSTINST)
	@echo "echo" >> $(POSTINST)
	@echo "echo \"This package can be removed now\"" >> $(POSTINST)
	@echo "echo \"This package requires also a reboot: type 'opkg remove $(XDSL_042U_D26O_NAME) && reboot'\"" >> $(POSTINST)
	@echo "exit 0" >> $(POSTINST)
endif

