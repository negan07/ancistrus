include ../Rules.mak

all:
	@echo "Nothing to do: run 'make install' to install."

clean: 
	@echo "Nothing to clean"

install: control
	install -m 0755 -d $(TMPINSTDIR)
	@if [ -f $(RCDSLCMDBIN) ]; then \
	for F in $(RCDSLKO); do [ -f $$F ] && $(STRIP) $(STRIPFLAGS) $$F && install -m 0644 $$F $(TMPINSTDIR); done; \
	for F in $(RCDSLDRV); do [ -f $$F ] && install -m 0644 $$F $(TMPINSTDIR); done; \
	for F in $(RCDSLBINS); do [ -f $$F ] && $(SSTRIP) $$F && install -m 0755 $$F $(TMPINSTDIR); done; \
	for F in lib$(RCDSLCMD).so; do [ -f $$F ] && install -m 0755 $$F $(TMPINSTDIR); done; \
	fi

ifndef BUILD
control:
else
POSTINST		:= $(CTRL_DIR)/postinst

control: postinst

postinst:
	@echo "#!/bin/sh" > $(POSTINST)
	@echo "[ ! -f $(TMPDIR)/$(RCDSLCMDBIN) ] && exit 0" >> $(POSTINST)
	@echo "echo \"Restoring original XDSL driverset...\"" >> $(POSTINST)
	@echo "for F in $(RCDSLKO); do [ -f $(TMPDIR)/\$$F ] && echo \"Restoring XDSL kodrv: \$$F ...\" && mv -f $(TMPDIR)/\$$F $(LDLIBMOD)/; done" >> $(POSTINST)
	@echo "for F in $(RCDSLDRV); do [ -f $(TMPDIR)/\$$F ] && echo \"Restoring XDSL drv: \$$F ...\" && cp -f $(TMPDIR)/\$$F $(USRETCADSL)/ && mv -f $(TMPDIR)/\$$F $(ETCADSL)/; done" >> $(POSTINST)
	@echo "for F in $(RCDSLSO); do [ -f $(TMPDIR)/\$$F ] && [ \"\$$F\"!=\"lib$(RCDSLCMD).so\" ] && echo \"Removing XDSL orphan solib: \$$F ...\" && rm -f $(LDLIB)/\$$F; done" >> $(POSTINST)
	@echo "[ -f $(TMPDIR)/lib$(RCDSLCMD).so ] && echo \"Restoring XDSL solib: lib$(RCDSLCMD).so ...\" && mv -f $(TMPDIR)/lib$(RCDSLCMD).so $(LDLIB)/; done" >> $(POSTINST)
	@echo "for F in $(RCDSLBINS); do [ -f $(TMPDIR)/\$$F ] && echo \"Restoring XDSL bin: \$$F ...\" && mv -f $(TMPDIR)/\$$F $(USRSBIN)/; done" >> $(POSTINST)
	@echo "[ ! -h $(USRSBIN)/$(RCDSLCMD) ] && [ -f $(USRSBIN)/$(RCDSLCMDBIN) ] && mv -f $(USRSBIN)/$(RCDSLCMDBIN) $(USRSBIN)/$(RCDSLCMD)" >> $(POSTINST)
	@echo "sync" >> $(POSTINST)
	@echo "echo" >> $(POSTINST)
	@echo "echo \"Original XDSL driverset restored\"" >> $(POSTINST)
	@echo "echo" >> $(POSTINST)
	@echo "echo \"This package can be removed now\"" >> $(POSTINST)
	@echo "echo \"This package requires also a reboot: type 'opkg remove $(XDSL_042N_D26B_NAME) && reboot'\"" >> $(POSTINST)
	@echo "exit 0" >> $(POSTINST)
endif

