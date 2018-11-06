include ../Rules.mak

WEB			:= ../www/$(NETWORKTEST_NAME).htm

all:
	@echo "Nothing to do: run 'make install' to install."

install:
	for D in $(BINDIR) $(SCRDIR) $(WWWDIR); do install -m 0755 -d $$D; done
	install -m 0755 ../$(NETPERF)/$(NETPERF)/src/netperf $(BINDIR)
	install -m 0755 *.sh $(SCRDIR)
	install -m 0664 $(WEB) $(WWWDIR)

clean: 
	@echo "Nothing to clean"

