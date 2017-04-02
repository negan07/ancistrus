include ../Rules.mak

QOS_KO := act_ipt.ko sch_fq_codel.ko cls_flow.ko

all:
	@echo "Nothing to do: run 'make install' to install."

install:
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

