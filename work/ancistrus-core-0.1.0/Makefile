include ../Rules.mak

BINS			:= $(PROJ_TAG)
CGI			:= $(BINS).cgi
DSLCMD			:= xdslctl
DSLCMDBIN		:= $(DSLCMD).bin
NVRAMLIB		:= libscnvram.so
SCRRCSRAM		:= $(TMPETC)/$(RCSSCR)
OBJS			:= $(GIT_NAME).o common.o $(RCAPPSBIN).o fw.o dslctl.o
SCRIPTSDIR		:= scripts
HTMDIR			:= www
INITDLANGPART		:= /config/language_CSY
INITDPART		:= mtd19
MAINWEB			:= top.js advanced.js top.html adv_index.htm
MAINCSS			:= top.css
COREWEB			:= $(PROJ_TAG)_index.htm $(PROJ_TAG)_home.htm

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
endif

all: $(BINS)

$(BINS): $(OBJS)
	$(CC) $^ $(CFLAGS) $(LDFLAGS) $(LIBS) $(CPPFLAGS) $(DEFS) -o $@

%.o : %.c
	$(CC) -c $< $(CFLAGS) -Wno-cast-align $(LDFLAGS) $(LIBS) $(CPPFLAGS) $(DEFS) -o $@

install: control
	$(SSTRIP) $(BINS)
	for D in $(TMPINSTDIR) $(ETCDIR) $(BINDIR); do install -m 0755 -d $$D; done
#	for D in $(TMPINSTDIR) $(ETCDIR) $(BINDIR) $(WWWDIR); do install -m 0755 -d $$D; done
	install -m 0755 ../$(NVRAM)/$(NVRAMLIB) $(TMPINSTDIR)
	install -m 0755 $(BINS) $(BINDIR)
	$(MAKE) -C $(SCRIPTSDIR) install || exit 1
#	cd $(HTMDIR); install -m 0664 $(MAINWEB) $(MAINCSS) $(TMPINSTDIR); install -m 0664 $(COREWEB) $(WWWDIR); cd ..
#	ln -sf $(USRSBIN)/$(PROJ_TAG) $(ETCDIR)/$(CGI)
#	ln -sf $(TMPETC)/$(CGI) $(WWWDIR)/$(CGI)

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
	@echo "[ ! -d $(USRETCINITD) ] && mkdir -m 0777 $(USRETCINITD)" >> $(PREINST)
	@echo "umount $(USRETCINITD) > /dev/null 2>&1" >> $(PREINST)
	@echo "umount $(INITDLANGPART) > /dev/null 2>&1" >> $(PREINST)
	@echo "mount -n -t jffs2 $(INITDPART) $(USRETCINITD)" >> $(PREINST)
	@echo "[ \$$? -ne 0 ] && echo \"Problem has occurred: $(INITD) partition not mounted.\" && exit 1" >> $(PREINST)
	@echo "rm -rf $(USRETCINITD)/*" >> $(PREINST)
	@echo "sync" >> $(PREINST)
	@echo "exit 0" >> $(PREINST)

postinst:
	@echo "#!/bin/sh" > $(POSTINST)
	@echo "echo \"Updating boot script ...\"" >> $(POSTINST)
	@echo "cp -f $(TMPDIR)/$(RCBOOT_NAME) $(TMPETC)/$(RCBOOT_NAME)" >> $(POSTINST)
	@echo "cat $(TMPETC)/$(RCBOOT_NAME) | grep $(GIT_NAME) > /dev/null 2>&1" >> $(POSTINST)
	@echo "[ \$$? -ne 0 ] && echo \"Problem has occurred: boot script not updated.\" && exit 1" >> $(POSTINST)
	@echo "mv -f $(TMPDIR)/$(RCBOOT_NAME) $(RCBOOT)" >> $(POSTINST)
	@echo "echo \"Updating $(NVRAMLIB) ...\"" >> $(POSTINST)
	@echo "cp -f $(LDLIB)/$(NVRAMLIB) $(TMPDIR)/$(NVRAMLIB).old" >> $(POSTINST)
	@echo "mv -f $(TMPDIR)/$(NVRAMLIB) $(LDLIB)/$(NVRAMLIB)" >> $(POSTINST)
	@echo "echo -n \"Testing nvram basic functionality...\"" >> $(POSTINST)
	@echo "nvram set libnvram=working" >> $(POSTINST)
	@echo "eval \`nvram get libnvram\`" >> $(POSTINST)
	@echo "if [ \"\$$libnvram\" != \"working\" ]; then" >> $(POSTINST)
	@echo "echo \" something wrong: reverting to original $(NVRAMLIB) ...\"" >> $(POSTINST)
	@echo "mv -f $(TMPDIR)/$(NVRAMLIB).old $(LDLIB)/$(NVRAMLIB)" >> $(POSTINST)
	@echo "exit 1" >> $(POSTINST)
	@echo "else" >> $(POSTINST)
	@echo "nvram unset libnvram" >> $(POSTINST)
	@echo "rm -f $(TMPDIR)/$(NVRAMLIB).old" >> $(POSTINST)
	@echo "echo \" looking good\"" >> $(POSTINST)
	@echo "fi" >> $(POSTINST)
	@echo "echo \"Copying conf files & $(INITD) runlevel dirtree on ram...\"" >> $(POSTINST)
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
	@echo "echo \"Linking $(DSLCMD) to core on flash...\"" >> $(POSTINST)
	@echo "mv -f $(USRSBIN)/$(DSLCMD) $(USRSBIN)/$(DSLCMDBIN)" >> $(POSTINST)
	@echo "if [ ! -x $(USRSBIN)/$(DSLCMDBIN) ]; then" >> $(POSTINST)
	@echo "echo \"Something wrong: $(DSLCMDBIN) not present...\"" >> $(POSTINST)
	@echo "exit 1" >> $(POSTINST)
	@echo "else" >> $(POSTINST)
	@echo "ln -sf $(USRSBIN)/$(PROJ_TAG) $(USRSBIN)/$(DSLCMD)" >> $(POSTINST)
	@echo "fi" >> $(POSTINST)
#	@echo "echo \"Updating main web pages & styles...\"" >> $(POSTINST)
#	@echo "for F in $(MAINWEB); do mv -f $(TMPDIR)/\$$F $(WWW)/\$$F; done" >> $(POSTINST)
#	@echo "for F in $(MAINCSS); do mv -f $(TMPDIR)/\$$F $(RCWWWCSSDIR)/\$$F; done" >> $(POSTINST)
	@echo "sync" >> $(POSTINST)
	@echo "exit 0" >> $(POSTINST)

postrm:
	@echo "#!/bin/sh" > $(POSTRM)
	@echo "echo \"Reverting to original $(DSLCMD) ...\"" >> $(POSTRM)
	@echo "mv -f $(USRSBIN)/$(DSLCMDBIN) $(USRSBIN)/$(DSLCMD)" >> $(POSTRM)
	@echo "echo \"Reverting to original $(RCAPPSBIN) ...\"" >> $(POSTRM)
	@echo "ln -sf $(RCSBINDIR)/$(RCAPP)/$(RCAPPSBIN) $(USRETC)/$(RCAPPSBIN)" >> $(POSTRM)
	@echo "ln -sf $(RCSBINDIR)/$(RCAPP)/$(RCAPPSBIN) $(TMPETC)/$(RCAPPSBIN)" >> $(POSTRM)
	@echo "exit 0" >> $(POSTRM)
endif

