include ../Rules.mak

all:
	@echo "Nothing to do: run 'make install' to install."

install: control
	install -m 0755 -d $(APPDIR)
	@if [ -f rc_qos ] && [ -x rc_qos ]; then \
	install -m 0755 rc_qos $(APPDIR); \
	ln -sf rc_qos $(APPDIR)/rc_buffer_bloat; \
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
	@echo "echo \"Check if qos-sqm package installed...\"" >> $(PREINST)
	@echo "if [ \`$(USRSBIN)/opkg list-installed | grep qos-sqm | head -c 7\` = qos-sqm ]; then" >> $(PREINST)
	@echo "echo \"Another qos package seems to be already installed: remove it before installing this one\"" >> $(PREINST)
	@echo "echo \"Type: 'opkg remove qos-sqm' and then 'opkg install qos-netgear'\"" >> $(PREINST)
	@echo "exit 1" >> $(PREINST)
	@echo "else" >> $(PREINST)
	@echo "echo \"Stopping qos service...\"" >> $(PREINST)
	@echo "$(RC) qos stop" >> $(PREINST)
	@echo "exit 0" >> $(PREINST)
	@echo "fi" >> $(PREINST)

postinst:
	@echo "#!/bin/sh" > $(POSTINST)
	@echo "echo \"Enable, setup & apply qos from webgui\"" >> $(POSTINST)
	@echo "echo \"If already setup earlier, simply type: 'nvram set qos_enable=1' and then 'rc qos restart'\"" >> $(POSTINST)
	@echo "exit 0" >> $(POSTINST)

prerm:
	@echo "#!/bin/sh" > $(PRERM)
	@echo "echo \"Stopping qos service...\"" >> $(PRERM)
	@echo "$(RC) qos stop" >> $(PRERM)
	@echo "exit 0" >> $(PRERM)

postrm:
	@echo "#!/bin/sh" > $(POSTRM)
	@echo "ln -sf $(TMPETC)/$(RCAPPSBIN) $(USRSBINRCAPP)/rc_qos" >> $(POSTRM)
	@echo "exit 0" >> $(POSTRM)
endif

