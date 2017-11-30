include ../Rules.mak

RC_QOS			:= rc_qos

all:
	@echo "Nothing to do: run 'make install' to install."

install: control
	install -m 0755 -d $(APPDIR)
	@if [ -f $(RC_QOS) ] && [ -x $(RC_QOS) ]; then \
	$(SSTRIP) $(RC_QOS); \
	install -m 0755 $(RC_QOS) $(APPDIR); \
	ln -sf $(RC_QOS) $(APPDIR)/rc_buffer_bloat; \
	fi

clean: 
	@echo "Nothing to clean"

ifndef BUILD
control:
else
PREINST			:= $(CTRL_DIR)/preinst
POSTINST		:= $(CTRL_DIR)/postinst
PRERM			:= $(CTRL_DIR)/prerm
POSTRM			:= $(CTRL_DIR)/postrm

control: preinst postinst prerm postrm

preinst:
	@echo "#!/bin/sh" > $(PREINST)
	@echo "echo \"Stopping qos service...\"" >> $(PREINST)
	@echo "$(RC) qos stop" >> $(PREINST)
	@echo "exit 0" >> $(PREINST)

postinst:
	@echo "#!/bin/sh" > $(POSTINST)
	@echo "eval \`nvram get qos_enable\`" >> $(POSTINST)
	@echo "[ \$$qos_enable -eq 1 ] && echo \"Restarting qos service...\" && $(RC) qos restart" >> $(POSTINST)
	@echo "echo \"Enable, setup & apply qos from webgui\"" >> $(POSTINST)
	@echo "exit 0" >> $(POSTINST)

prerm:
	@echo "#!/bin/sh" > $(PRERM)
	@echo "echo \"Stopping qos service...\"" >> $(PRERM)
	@echo "$(RC) qos stop" >> $(PRERM)
	@echo "exit 0" >> $(PRERM)

postrm:
	@echo "#!/bin/sh" > $(POSTRM)
	@echo "ln -sf $(TMPETC)/$(RCAPPSBIN) $(USRSBINRCAPP)/$(RC_QOS)" >> $(POSTRM)
	@echo "exit 0" >> $(POSTRM)
endif

