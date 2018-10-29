include ../Rules.mak

SCRIPTS			:= betterspeedtest.sh netperfrunner.sh
WEB			:= ../www/$(NETWORKTEST_NAME).htm

all:
	@echo "Nothing to do: run 'make install' to install."

install:
	for D in $(BINDIR) $(SCRDIR) $(WWWDIR); do install -m 0755 -d $$D; done
	install -m 0755 ../$(NETPERF)/$(NETPERF)/src/netperf $(BINDIR)
	install -m 0755 *.sh $(SCRDIR)
	install -m 0664 $(WEB) $(WWWDIR)
	for F in $(SCRIPTS); do ln -sf $(NETWORKTEST_NAME).sh $(SCRDIR)/$$F; done

clean: 
	@echo "Nothing to clean"

