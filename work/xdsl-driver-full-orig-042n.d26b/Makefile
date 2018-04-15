include ../Rules.mak

all:
	@echo "Nothing to do: run 'make install' to install."

clean: 
	@echo "Nothing to clean"

install: control
	install -m 0755 -d $(TMPINSTDIR)
	for F in $(RCDSLKO); do [ -f $$F ] && $(STRIP) $(STRIPFLAGS) $$F && install -m 0644 $$F $(TMPINSTDIR); done
	for F in $(RCDSLKO) $(RCDSLDRV); do [ -f $$F ] && install -m 0644 $$F $(TMPINSTDIR); done
	for F in $(RCDSLBINS); do [ -f $$F ] && $(SSTRIP) $$F && install -m 0644 $$F $(TMPINSTDIR); done
	for F in $(RCDSLBINS); do [ -f $$F ] && install -m 0755 $$F $(TMPINSTDIR); done

ifndef BUILD
control:
else
POSTINST		:= $(CTRL_DIR)/postinst

control: postinst

postinst:
	@echo "#!/bin/sh" > $(POSTINST)
	@echo "echo \"Stopping XDSL connection...\"" >> $(POSTINST)
	@echo "$(RCDSLCMD) connection --down" >> $(POSTINST)
	@echo "$(RCDSLCMD) stop" >> $(POSTINST)
	@echo "sleep 2" >> $(POSTINST)
	@echo "echo" >> $(POSTINST)
	@echo "echo \"Restoring original XDSL driverset...\"" >> $(POSTINST)
	@echo "for F in $(RCDSLKO); do [ -f $(TMPDIR)/\$$F ] && echo \"Restoring XDSL kodrv: \$$F ...\" && cp -f $(TMPDIR)/\$$F $(LDLIBMOD)/; done" >> $(POSTINST)
	@echo "for F in $(RCDSLDRV); do [ -f $(TMPDIR)/\$$F ] && echo \"Restoring XDSL drv: \$$F ...\" && cp -f $(TMPDIR)/\$$F $(USRETCADSL)/ && cp -f $(TMPDIR)/\$$F $(ETCADSL)/; done" >> $(POSTINST)
	@echo "for F in $(RCDSLSO); do [ -f $(TMPDIR)/\$$F ] && echo \"Removing XDSL orphan solib: \$$F ...\" && rm -f $(LDLIB)/\$$F; done" >> $(POSTINST)
	@echo "for F in $(RCDSLBINS); do [ -f $(TMPDIR)/\$$F ] && echo \"Restoring XDSL bin: \$$F ...\" && cp -f $(TMPDIR)/\$$F $(USRSBIN)/; done" >> $(POSTINST)
	@echo "[ ! -h $(USRSBIN)/$(RCDSLCMD) ] && [ -f $(USRSBIN)/$(RCDSLCMDBIN) ] && mv -f $(USRSBIN)/$(RCDSLCMDBIN) $(USRSBIN)/$(RCDSLCMD)" >> $(POSTINST)
	@echo "sync" >> $(POSTINST)
	@echo "echo" >> $(POSTINST)
	@echo "echo \"Original XDSL driverset restored\"" >> $(POSTINST)
	@echo "echo" >> $(POSTINST)
	@echo "echo \"This package can be removed now\"" >> $(POSTINST)
	@echo "echo \"This package requires also a reboot: type 'opkg remove xdsl-driver-full-orig && reboot'\"" >> $(POSTINST)
	@echo "exit 0" >> $(POSTINST)
endif

