include ../Rules.mak

all:
	@echo "Nothing to do: run 'make install' to install."

install: control
	install -m 0755 -d $(SCRDIR)
	install -m 0755 *.sh $(SCRDIR)

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
	@echo "killall -9 betterspeedtest.sh > /dev/null 2>&1" >> $(PREINST)
	@echo "killall -9 netperfrunner.sh > /dev/null 2>&1" >> $(PREINST)
	@echo "exit 0" >> $(PREINST)

prerm:
	@echo "#!/bin/sh" > $(PRERM)
	@echo "killall -9 betterspeedtest.sh > /dev/null 2>&1" >> $(PRERM)
	@echo "killall -9 netperfrunner.sh > /dev/null 2>&1" >> $(PRERM)
	@echo "exit 0" >> $(PRERM)

endif

