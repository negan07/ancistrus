include ../Rules.mak

all:
	@echo "Nothing to do: run 'make install' to install."

install:
	install -m 0755 -d $(BINDIR)/scripts
	install -m 0755 *.qos $(BINDIR)/scripts
	install -m 0755 *.conf *.sh rc_qos $(BINDIR)/rc_app

clean: 
	@echo "Nothing to clean"

