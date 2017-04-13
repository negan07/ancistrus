include ../Rules.mak

QOS_KO := act_ipt.ko sch_fq_codel.ko cls_flow.ko

all:
	@echo "Nothing to do: run 'make install' to install."

install: control
	install -m 0755 -d $(ETCDIR)
	install -m 0755 -d $(MODDIR)
	install -m 0755 -d $(SCRDIR)
	install -m 0755 -d $(APPDIR)
	install -m 0644 *.conf $(ETCDIR)
	@$(foreach Q, $(QOS_KO), install -m 0755 $(KERNEL_BIN)/$(Q) $(MODDIR) || exit 1; $(STRIP) -d $(MODDIR)/$(Q);)
	install -m 0755 *.qos $(SCRDIR)
	install -m 0755 rc_qos $(APPDIR)

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
	@echo "echo \"Check if qos-netgear package installed...\"" >> $(PREINST)
	@echo "if [ \`$(USRSBIN)/opkg list-installed | grep qos-netgear | head -c 11\` = qos-netgear ]; then" >> $(PREINST)
	@echo "echo \"Another qos package seems to be already installed: remove it before installing this one\"" >> $(PREINST)
	@echo "echo \"Type: 'opkg remove qos-netgear' and then 'opkg install qos-sqm'\"" >> $(PREINST)
	@echo "exit 1" >> $(PREINST)
	@echo "else" >> $(PREINST)
	@echo "echo \"Stopping qos service...\"" >> $(PREINST)
	@echo "$(RC) qos stop" >> $(PREINST)
	@echo "exit 0" >> $(PREINST)
	@echo "fi" >> $(PREINST)

postinst:
	@echo "#!/bin/sh" > $(POSTINST)
	@echo "echo \"Type '$(USRSBINSCR)/rc_qos help' to see the options & settings\"" >> $(POSTINST)
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

