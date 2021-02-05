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
FAVICON			:= favicon.png
FAVICONCODE		:= "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"

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
	@echo -n $(FAVICONCODE) | base64 -d > $(WWWDIR)/$(FAVICON) || exit 1
	ln -sf $(USRSBIN)/$(PROJ_TAG) $(ETCDIR)/$(CGI)
	ln -sf $(TMPETC)/$(CGI) $(WWWDIR)/$(CGI)
	ln -sf $(TMPDIR)/$(DSLINFO) $(WWWDIR)/$(DSLINFO)
	ln -sf $(TMPDIR)/nvram.zip $(WWWDIR)/nvram.zip

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

