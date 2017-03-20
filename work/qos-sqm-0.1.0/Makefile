include ../Rules.mak

all:
	@echo "Nothing to do: run 'make install' to install."

install:
	install -m 0755 -d $(ETCDIR)
	install -m 0755 -d $(SCRDIR)
	install -m 0755 -d $(APPDIR)
	install -m 0644 *.conf $(ETCDIR)
	install -m 0755 *.qos $(SCRDIR)
	install -m 0755 rc_qos $(APPDIR)

clean: 
	@echo "Nothing to clean"

