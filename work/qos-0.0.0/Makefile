include ../Rules.mak

all:
	@echo "Run 'make install' to install."

install:
#	install -m 0755 -d $(ETCDIR)/qos
#	install -m 0644 qos.conf $(ETCDIR)/qos
	install -m 0644 qos.conf $(ETCDIR)
	install -m 0755 *.sh *.qos rc* $(BINDIR)

clean: 
	@echo "Nothing to clean"

