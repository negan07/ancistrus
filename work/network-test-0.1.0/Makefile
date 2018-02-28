include ../Rules.mak

all:
	@echo "Nothing to do: run 'make install' to install."

install: control
	install -m 0755 -d $(BINDIR)
	install -m 0755 -d $(SCRDIR)
	install -m 0755 *.sh $(SCRDIR)
	install -m 0755 ../$(NETPERF)/$(NETPERF)/src/netperf $(BINDIR)

clean: 
	@echo "Nothing to clean"

ifndef BUILD
control:
else
PREINST			:= $(CTRL_DIR)/preinst
PRERM			:= $(CTRL_DIR)/prerm

control: preinst prerm

preinst:
	@echo "#!/bin/sh" > $(PREINST)
	@echo "for P in \"netperf\" \"betterspeedtest.sh\" \"netperfrunner.sh\"; do killall -9 \$$P > /dev/null 2>&1; done" >> $(PREINST)
	@echo "exit 0" >> $(PREINST)

prerm:
	@echo "#!/bin/sh" > $(PRERM)
	@echo "for P in \"netperf\" \"betterspeedtest.sh\" \"netperfrunner.sh\"; do killall -9 \$$P > /dev/null 2>&1; done" >> $(PRERM)
	@echo "exit 0" >> $(PRERM)

endif

