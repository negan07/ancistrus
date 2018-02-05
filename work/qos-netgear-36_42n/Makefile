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
	@echo "$(RC) qos stop" >> $(PREINST)
	@echo "exit 0" >> $(PREINST)

postinst:
	@echo "#!/bin/sh" > $(POSTINST)
	@echo "$(RC) qos restart" >> $(POSTINST)
	@echo "exit 0" >> $(POSTINST)

prerm:
	@echo "#!/bin/sh" > $(PRERM)
	@echo "$(RC) qos stop" >> $(PRERM)
	@echo "exit 0" >> $(PRERM)

postrm:
	@echo "#!/bin/sh" > $(POSTRM)
	@echo "ln -sf $(TMPETC)/$(RCAPPSBIN) $(USRSBINRCAPP)/$(RC_QOS)" >> $(POSTRM)
	@echo "$(RC) qos restart" >> $(POSTRM)
	@echo "exit 0" >> $(POSTRM)
endif

