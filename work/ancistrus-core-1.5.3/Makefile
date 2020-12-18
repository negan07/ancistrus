include ../Rules.mak

BINS			:= $(PROJ_TAG)
CGI			:= $(BINS).cgi
DSLINFO			:= $(PROJ_TAG)dslinfo
CONF			:= profile
SCRRCSRAM		:= $(TMPETC)/$(RCSSCR)
OBJS			:= $(GIT_NAME).o common.o $(RCAPPSBIN).o fw.o dslctl.o cgi.o
SCRIPTSDIR		:= scripts
HTMDIR			:= ../www
INITDLANGPART		:= /config/language_CSY
INITDPART		:= mtd19
COREWEB			:= $(PROJ_TAG)*

CFLAGS			+= -W -Wall -Werror -Wbad-function-cast -Wcast-align -Wcast-qual -Wmissing-prototypes -Wstrict-prototypes -Wnested-externs -Wpointer-arith -Wredundant-decls -Wshadow -Winline
LDFLAGS			:= -L../$(NVRAM)
LIBS			:= -lscnvram
CPPFLAGS		:= -I../$(NVRAM)
DEFS			:= #-DPROJNAME=\"$(PROJECT_NAME)\" -DPROJTARGET=\"$(PROJECT_TARGET)\" -DPROJFOUNDER=\"$(PROJECT_FOUNDER)\" -DPROJPLOT=\"$(PROJECT_PLOT)\" -DHOMEPAGE=\"$(GITHUB_DIR)\" -DLICENSE=\"$(PROJECT_LICENSE)\"

ifdef LOCAL
DEFS			+= -DLOCAL=1 -DLROOT=\"$(PREFIX)\"
else
CFLAGS			+= -Os
endif

ifdef DEBUG
DEFS			+= -DDEBUG=1 -DTMPETC=\"$(RECEIVE_DIR)\"
COREWEB			+= openssh.htm qos-sqm.htm opkg.htm opkg_select.htm
endif

all: $(BINS)

$(BINS): $(OBJS)
	$(CC) $^ $(CFLAGS) $(LDFLAGS) $(LIBS) $(CPPFLAGS) $(DEFS) -o $@
%.o : %.c
	$(CC) -c $< $(CFLAGS) -Wno-cast-align $(LDFLAGS) $(LIBS) $(CPPFLAGS) $(DEFS) -o $@

install: control
	$(SSTRIP) $(BINS)
	for D in $(TMPINSTDIR) $(ETCDIR) $(BINDIR) $(WWWDIR); do install -m 0755 -d $$D; done
	install -m 0755 ../$(NVRAM)/$(RCNVRAMSO) $(TMPINSTDIR)
	install -m 0755 $(BINS) $(BINDIR)
	$(MAKE) -C $(SCRIPTSDIR) install || exit 1
	cd $(HTMDIR); install -m 0664 $(RCMAINWEB) $(RCMAINCSS) $(TMPINSTDIR); install -m 0664 $(COREWEB) $(WWWDIR); cd ..
	ln -sf $(USRSBIN)/$(PROJ_TAG) $(ETCDIR)/$(CGI)
	ln -sf $(TMPETC)/$(CGI) $(WWWDIR)/$(CGI)
	ln -sf $(TMPDIR)/$(DSLINFO) $(WWWDIR)/$(DSLINFO)
	ln -sf $(TMPDIR)/nvram $(WWWDIR)/nvram

clean:
	rm -f *~ *.o *.so $(BINS)

ifndef BUILD
control:
else
PREINST			:= $(CTRL_DIR)/preinst
POSTINST		:= $(CTRL_DIR)/postinst
POSTRM			:= $(CTRL_DIR)/postrm

control: preinst postinst postrm

preinst:
	@echo "#!/bin/sh" > $(PREINST)
	@echo "[ -d $(USRETCINITDRCSD) ] && [ -d $(USRETCINITDPRE) ] && [ -d $(USRETCINITDPOST) ] && exit 0" >> $(PREINST)
	@echo "echo \"Preparing $(CORE_WORK) package installation...\"" >> $(PREINST)
	@echo "echo" >> $(PREINST)
	@echo "echo \"Mounting $(INITD) runlevel startup partition...\"" >> $(PREINST)
	@echo "rm -rf $(USRETCINITD)/" >> $(PREINST)
	@echo "mkdir -m 0777 $(USRETCINITD)" >> $(PREINST)
	@echo "for U in $(USRETCINITD) $(INITDLANGPART); do umount \$$U >/dev/null 2>&1; done" >> $(PREINST)
	@echo "mknod /dev/$(INITDPART) c 90 38" >> $(PREINST)
	@echo "flash_eraseall -j /dev/$(INITDPART)" >> $(PREINST)
	@echo "mount -n -t jffs2 $(INITDPART) $(USRETCINITD)" >> $(PREINST)
	@echo "[ \$$? -ne 0 ] && echo \"Problem has occurred: $(INITD) partition not mounted.\" && exit 1" >> $(PREINST)
	@echo "sync" >> $(PREINST)
	@echo "exit 0" >> $(PREINST)

postinst:
	@echo "#!/bin/sh" > $(POSTINST)
	@echo "if [ -f $(TMPDIR)/$(RCBOOT_NAME) ]; then" >> $(POSTINST)
	@echo "echo \"Updating boot script ...\"" >> $(POSTINST)
	@echo "cp -f $(TMPDIR)/$(RCBOOT_NAME) $(TMPETC)/$(RCBOOT_NAME)" >> $(POSTINST)
	@echo "cat $(TMPETC)/$(RCBOOT_NAME) | grep $(GIT_NAME) >/dev/null 2>&1" >> $(POSTINST)
	@echo "[ \$$? -ne 0 ] && echo \"Problem has occurred: boot script not updated.\" && exit 1" >> $(POSTINST)
	@echo "mv -f $(TMPDIR)/$(RCBOOT_NAME) $(RCBOOT)" >> $(POSTINST)
	@echo "fi" >> $(POSTINST)
	@echo "if [ -f $(TMPDIR)/$(RCNVRAMSO) ]; then" >> $(POSTINST)
	@echo "echo \"Updating $(RCNVRAMSO) ...\"" >> $(POSTINST)
	@echo "cp -f $(LDLIB)/$(RCNVRAMSO) $(TMPDIR)/$(RCNVRAMSO).old" >> $(POSTINST)
	@echo "mv -f $(TMPDIR)/$(RCNVRAMSO) $(LDLIB)/$(RCNVRAMSO)" >> $(POSTINST)
	@echo "echo -n \"Testing nvram basic functionality...\"" >> $(POSTINST)
	@echo "nvram set libnvram=working" >> $(POSTINST)
	@echo "eval \`nvram get libnvram\`" >> $(POSTINST)
	@echo "	if [ \"\$$libnvram\" != \"working\" ]; then" >> $(POSTINST)
	@echo "	echo \" something wrong: reverting to original $(RCNVRAMSO) ...\"" >> $(POSTINST)
	@echo "	mv -f $(TMPDIR)/$(RCNVRAMSO).old $(LDLIB)/$(RCNVRAMSO)" >> $(POSTINST)
	@echo "	exit 1" >> $(POSTINST)
	@echo "	else" >> $(POSTINST)
	@echo "	nvram unset libnvram" >> $(POSTINST)
	@echo "	rm -f $(TMPDIR)/$(RCNVRAMSO).old" >> $(POSTINST)
	@echo "	echo \" looking good\"" >> $(POSTINST)
	@echo "	fi" >> $(POSTINST)
	@echo "fi" >> $(POSTINST)
	@echo "echo \"Copying $(INITD) runlevel dirtree & conf files on ram...\"" >> $(POSTINST)
	@echo "cp -rf $(USRETCINITD) $(USRETC)/$(CONF) $(TMPETC)/" >> $(POSTINST)
	@echo "echo \"Linking rc services to core on ram...\"" >> $(POSTINST)
	@echo "ln -sf $(USRSBIN)/$(PROJ_TAG) $(TMPETC)/$(RCAPPSBIN)" >> $(POSTINST)
	@echo "sync" >> $(POSTINST)
	@echo "echo -n \"Testing $(RCAPPSBIN) functionality...\"" >> $(POSTINST)
	@echo "$(USRSBINRCAPP)/rc_show_mem_log start" >> $(POSTINST)
	@echo "sleep 3" >> $(POSTINST)
	@echo "ps | grep rc_show_mem_log | grep -v grep" >> $(POSTINST)
	@echo "if [ \$$? -eq 0 ]; then" >> $(POSTINST)
	@echo "killall -9 rc_show_mem_log" >> $(POSTINST)
	@echo "echo \" something wrong: reverting to original $(RCAPPSBIN) ...\"" >> $(POSTINST)
	@echo "ln -sf $(RCSBINDIR)/$(RCAPP)/$(RCAPPSBIN) $(TMPETC)/$(RCAPPSBIN)" >> $(POSTINST)
	@echo "exit 1" >> $(POSTINST)
	@echo "else" >> $(POSTINST)
	@echo "echo \" looking good\"" >> $(POSTINST)
	@echo "echo \"Linking rc services to core on flash...\"" >> $(POSTINST)
	@echo "ln -sf $(USRSBIN)/$(PROJ_TAG) $(USRETC)/$(RCAPPSBIN)" >> $(POSTINST)
	@echo "fi" >> $(POSTINST)
	@echo "if [ ! -x $(USRSBIN)/$(RCDSLCMDBIN) ]; then" >> $(POSTINST)
	@echo "echo \"Linking $(RCDSLCMD) to core on flash...\"" >> $(POSTINST)
	@echo "mv -f $(USRSBIN)/$(RCDSLCMD) $(USRSBIN)/$(RCDSLCMDBIN)" >> $(POSTINST)
	@echo "	if [ ! -x $(USRSBIN)/$(RCDSLCMDBIN) ]; then" >> $(POSTINST)
	@echo "	echo \"Something wrong: $(RCDSLCMDBIN) not present...\"" >> $(POSTINST)
	@echo "	exit 1" >> $(POSTINST)
	@echo "	else" >> $(POSTINST)
	@echo "	ln -sf $(USRSBIN)/$(PROJ_TAG) $(USRSBIN)/$(RCDSLCMD)" >> $(POSTINST)
	@echo "	fi" >> $(POSTINST)
	@echo "fi" >> $(POSTINST)
	@echo "echo \"Updating rc services...\"" >> $(POSTINST)
	@echo "[ -x $(TMPDIR)/rc_printserver ] && mv -f $(TMPDIR)/rc_printserver $(USRSBINRCAPP)/rc_printserver" >> $(POSTINST)
	@echo "echo \"Updating main web pages & styles...\"" >> $(POSTINST)
	@echo "for F in $(RCMAINWEB); do [ -f $(TMPDIR)/\$$F ] && mv -f $(TMPDIR)/\$$F $(WWW)/\$$F; done" >> $(POSTINST)
	@echo "for F in $(RCMAINCSS); do [ -f $(TMPDIR)/\$$F ] && mv -f $(TMPDIR)/\$$F $(RCWWWCSSDIR)/\$$F; done" >> $(POSTINST)
	@echo "ln -sf $(USRSBIN)/$(PROJ_TAG) $(TMPETC)/$(CGI)" >> $(POSTINST)
	@echo "sync" >> $(POSTINST)
	@echo "exit 0" >> $(POSTINST)

postrm:
	@echo "#!/bin/sh" > $(POSTRM)
	@echo "echo \"Reverting to original $(RCDSLCMD) ...\"" >> $(POSTRM)
	@echo "mv -f $(USRSBIN)/$(RCDSLCMDBIN) $(USRSBIN)/$(RCDSLCMD)" >> $(POSTRM)
	@echo "echo \"Reverting to original $(RCAPPSBIN) ...\"" >> $(POSTRM)
	@echo "ln -sf $(RCSBINDIR)/$(RCAPP)/$(RCAPPSBIN) $(USRETC)/$(RCAPPSBIN)" >> $(POSTRM)
	@echo "ln -sf $(RCSBINDIR)/$(RCAPP)/$(RCAPPSBIN) $(TMPETC)/$(RCAPPSBIN)" >> $(POSTRM)
	@echo "echo \"Ram cleanup ...\"" >> $(POSTRM)
	@echo "rm -rf $(TMPETC)/$(INITD)/" >> $(POSTRM)
	@echo "exit 0" >> $(POSTRM)
endif

