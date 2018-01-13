include ../Rules.mak

QOS_KO			:= act_ipt.ko cls_flow.ko sch_fq_codel.ko
RC_QOS			:= rc_qos

all:
	@echo "Nothing to do: run 'make install' to install."

install: control
	install -m 0755 -d $(ETCDIR)
	install -m 0755 -d $(MODDIR)
	install -m 0755 -d $(SCRDIR)
	install -m 0755 -d $(APPDIR)
	install -m 0644 *.conf $(ETCDIR)
	@$(foreach Q, $(QOS_KO), install -m 0755 $(KERNEL_DIR)/net/sched/$(Q) $(MODDIR) || exit 1; $(STRIP) $(STRIPKOFLAGS) $(MODDIR)/$(Q);)
	install -m 0755 *.qos $(SCRDIR)
	install -m 0755 $(RC_QOS) $(APPDIR)

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
	@echo "[ \`anc nvram rget qos_enable\` -eq 1 ] && echo \"Restarting qos service...\" && $(RC) qos restart" >> $(POSTINST)
	@echo "echo \"Type '$(USRSBINRCAPP)/$(RC_QOS) help' to see the options & settings\"" >> $(POSTINST)
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

