include ../../Rules.mak

PRETAG			:= _pre
POSTTAG			:= _post
OPTIONAL		:= opt
CONF			:= profile
RCSSCRIPTS		:= $(RCSSCR)
BINSCRIPTS		:= led.sh guiinfo.sh pem_gen.sh wol.sh renew_crt.sh
APPSCRIPTS		:= rc_printserver
KSCRIPTS		:= kernelprocskill.sh
SSCRIPTS		:= 
FSCRIPTS		:= 
CSCRIPTS		:= 
USCRIPTS		:= 
DISPRE			:= rc_disable$(PRETAG)
PRESERVS		:= check_conn check_fw dnrd dnshj apple iserver ntp potcounter printk schedule show_mem_log syslogd xCloud led_ctrl

all:
	@echo "Nothing to do: run 'make install' to install."

install:
	for D in $(TMPINSTDIR) $(SCRDIR) $(ETCDIR) $(INITDIR) $(RCSDIR) $(PREDIR) $(POSTDIR) $(FWDIR) $(SCHDIR) $(USBSERVDIR); do install -m 0755 -d $$D; done
	install -m 0755 $(BINSCRIPTS) $(SCRDIR)
	install -m 0755 $(RCSSCRIPTS) $(APPSCRIPTS) $(TMPINSTDIR)
	install -m 0755 $(CONF) $(ETCDIR)
	for V in $(KSCRIPTS) $(SSCRIPTS) $(FSCRIPTS) $(CSCRIPTS) $(USCRIPTS); do install -m 0755 $$V $(INITDIR); done
	for W in K S F; do install -m 0755 $${W}$(OPTIONAL)* $(INITDIR); done
	install -m 0755 *$(PRETAG) $(PREDIR)
	install -m 0755 *$(POSTTAG) $(POSTDIR)
	I=1; for K in $(KSCRIPTS); do printf -v I "%02d" $$I; ln -sf ../$$K $(RCSDIR)/K$$I$$K; let I++; done
#	J=1; for S in $(SSCRIPTS); do printf -v J "%02d" $$J; ln -sf ../$$S $(RCSDIR)/S$$J$$S; let J++; done
#	L=1; for F in $(FSCRIPTS); do printf -v L "%02d" $$L; ln -sf ../$$F $(FWDIR)/F$$L$$F; let L++; done
#	M=1; for C in $(CSCRIPTS); do printf -v M "%02d" $$M; ln -sf ../$$C $(SCHDIR)/C$$M$$C; let M++; done
#	N=1; for U in $(USCRIPTS); do printf -v N "%02d" $$N; ln -sf ../$$U $(USBSERVDIR)/U$$N$$U; let N++; done
	for Z in K S; do ln -sf ../$${Z}$(OPTIONAL).sh $(RCSDIR)/$${Z}99$(OPTIONAL).sh; done
	ln -sf ../F$(OPTIONAL).sh $(FWDIR)/F99$(OPTIONAL).sh
	for P in $(PRESERVS); do ln -sf $(DISPRE) $(PREDIR)/$${P}$(PRETAG); done

clean: 
	@echo "Nothing to clean"

