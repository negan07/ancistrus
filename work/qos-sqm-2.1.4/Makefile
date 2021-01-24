include ../Rules.mak

QOS_KO			:= act_ipt.ko cls_flow.ko sch_fq_codel.ko sch_hfsc.ko
IPROUTE2DIR		:= ../$(IPROUTE2)
BINS			:= $(IPROUTE2DIR)/ip/ip $(IPROUTE2DIR)/tc/tc
STARTUP			:= rc_qos
WEB			:= ../www/$(QOS_SQM_NAME).htm

all:
	@echo "Nothing to do: run 'make install' to install."

install: control
	for D in $(TMPINSTDIR) $(ETCDIR) $(BINDIR) $(MODDIR) $(SCRDIR) $(APPDIR) $(WWWDIR); do install -m 0755 -d $$D; done
	for B in $(BINS); do $(SSTRIP) $$B; done
	cp -r $(IPROUTE2DIR)$(TMPETC)/iproute2 $(TMPINSTDIR)/iproute2 || exit 1
	install -m 0755 $(BINS) $(TMPINSTDIR) || exit 1
	install -m 0644 *.conf $(ETCDIR)
	@$(foreach Q, $(QOS_KO), install -m 0755 $(KERNEL_DIR)/net/sched/$(Q) $(MODDIR) || exit 1; $(STRIP) $(STRIPKOFLAGS) $(MODDIR)/$(Q);)
	install -m 0755 *.qos $(SCRDIR)
	install -m 0755 $(STARTUP) $(APPDIR)
	install -m 0664 $(WEB) $(WWWDIR)

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
	@echo "$(USRSBINRCAPP)/$(STARTUP) stop >/dev/null 2>&1" >> $(PREINST)
	@echo "for F in tc ip iproute2; do [ -e $(TMPDIR)/\$$F ] && rm -rf $(TMPDIR)/\$$F; done" >> $(PREINST)
	@echo "exit 0" >> $(PREINST)

postinst:
	@echo "#!/bin/sh" > $(POSTINST)
	@echo "[ ! -x $(TMPDIR)/ip -o ! -x $(TMPDIR)/tc -o ! -d $(TMPDIR)/iproute2 ] && exit 0" >> $(POSTINST)
	@echo "echo \"Updating iproute2 bins & tables...\"" >> $(POSTINST)
	@echo "mv -f $(TMPDIR)/ip $(TMPDIR)/tc $(USRSBIN)/" >> $(POSTINST)
	@echo "for D in $(USRETC) $(TMPETC); do [ -e \$$D/iproute2 ] && rm -rf \$$D/iproute2; done" >> $(POSTINST)
	@echo "cp -rf $(TMPDIR)/iproute2 $(USRETC)/" >> $(POSTINST)
	@echo "mv -f $(TMPDIR)/iproute2 $(TMPETC)/" >> $(POSTINST)
	@echo "sync" >> $(POSTINST)
	@echo "$(USRSBINRCAPP)/$(STARTUP) start >/dev/null 2>&1" >> $(POSTINST)
	@echo "[ -n \"\$$SHELL\" ] && echo \"Type '$(USRSBINRCAPP)/$(STARTUP) help' to see the options & settings\"" >> $(POSTINST)
	@echo "exit 0" >> $(POSTINST)

prerm:
	@echo "#!/bin/sh" > $(PRERM)
	@echo "$(USRSBINRCAPP)/$(STARTUP) stop >/dev/null 2>&1" >> $(PRERM)
	@echo "exit 0" >> $(PRERM)

postrm:
	@echo "#!/bin/sh" > $(POSTRM)
	@echo "ln -sf $(TMPETC)/$(RCAPPSBIN) $(USRSBINRCAPP)/$(STARTUP)" >> $(POSTRM)
	@echo "$(USRSBINRCAPP)/$(STARTUP) start >/dev/null 2>&1" >> $(POSTRM)
	@echo "exit 0" >> $(POSTRM)
endif

