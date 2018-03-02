include ../Rules.mak

STARTUP			:= rc_qos

all:
	@echo "Nothing to do: run 'make install' to install."

install: control
	install -m 0755 -d $(APPDIR)
	@if [ -f $(STARTUP) ] && [ -x $(STARTUP) ]; then \
	$(SSTRIP) $(STARTUP); \
	install -m 0755 $(STARTUP) $(APPDIR); \
	ln -sf $(STARTUP) $(APPDIR)/rc_buffer_bloat; \
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
	@echo "$(USRSBINRCAPP)/$(STARTUP) stop >/dev/null 2>&1" >> $(PREINST)
	@echo "exit 0" >> $(PREINST)

postinst:
	@echo "#!/bin/sh" > $(POSTINST)
	@echo "$(USRSBINRCAPP)/$(STARTUP) start >/dev/null 2>&1" >> $(POSTINST)
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

