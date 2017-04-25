include ../Rules.mak

GIT_EXEC	:= $(shell echo $(GIT_NAME) | head -c 3)

RCS		:= rcS
BINS		:= $(GIT_EXEC)
OBJS		:= $(GIT_NAME).o

CFLAGS		+= -W -Wall -Werror -Wbad-function-cast -Wcast-align -Wcast-qual -Wmissing-prototypes -Wstrict-prototypes -Wnested-externs -Wpointer-arith -Wredundant-decls -Wshadow -Winline
LDFLAGS		:= -L../$(NVRAM)
LIBS		:= -lscnvram
CPPFLAGS	:= -I../$(NVRAM)
DEFS		:= -DPROJNAME=\"$(PROJECT_NAME)\" -DPROJTARGET=\"$(PROJECT_TARGET)\" -DPROJFOUNDER=\"$(PROJECT_FOUNDER)\" -DPROJPLOT=\"$(PROJECT_PLOT)\" -DHOMEPAGE=\"$(GITHUB_DIR)\" -DLICENSE=\"$(PROJECT_LICENSE)\"

ifdef LOCAL
DEFS		+= -DLOCAL=1 -DLROOT=\"$(PREFIX)\"
else
CFLAGS		+= -Os
endif

ifdef DEBUG
DEFS		+= -DDEBUG=1
endif

ifeq ($(BOOT_NAND_FLASH),1)
DEFS		+= -DBOOT_NAND_FLASH
endif

all: $(BINS)

$(BINS): $(OBJS)
	$(CC) $^ $(CFLAGS) $(LDFLAGS) $(LIBS) $(CPPFLAGS) $(DEFS) -o $@

%.o : %.c
	$(CC) -c $< $(CFLAGS) $(LDFLAGS) $(LIBS) $(CPPFLAGS) $(DEFS) -o $@

install: control
	$(SSTRIP) $(BINS)
	install -m 0755 -d $(ETCDIR)
	install -m 0755 -d $(BINDIR)
	install -m 0755 $(RCS) $(ETCDIR)
	install -m 0755 $(BINS) $(BINDIR)

clean:
	rm -f *~ *.o *.so $(BINS)

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
	@echo "if [ ! -f $(USRETC)/$(RCS).orig ]; then" >> $(PREINST)
	@echo "echo \"Backup original $(RCS) startup script ($(RCS).orig)...\"" >> $(PREINST)
	@echo "[ -f $(USRETC)/$(RCS) ] && cp -f $(USRETC)/$(RCS) $(USRETC)/$(RCS).orig" >> $(PREINST)
	@echo "fi" >> $(PREINST)
	@echo "exit 0" >> $(PREINST)

postinst:
	@echo "#!/bin/sh" > $(POSTINST)
	@echo "echo \"Updating root login passwd...\"" >> $(POSTINST)
	@echo "echo \"root:\`anc nvram rget http_password\`\" | chpasswd" >> $(POSTINST)
	@echo "echo \"Disabling non superuser login...\"" >> $(POSTINST)
	@echo "touch $(TMPETC)/nologin" >> $(POSTINST)
	@echo "exit 0" >> $(POSTINST)

prerm:
	@echo "#!/bin/sh" > $(PRERM)
	@echo "echo \"Make sure $(RCS) backup is present...\"" >> $(PRERM)
	@echo "if [ -f $(USRETC)/$(RCS).orig ]; then" >> $(PRERM)
	@echo "exit 0" >> $(PRERM)
	@echo "else" >> $(PRERM)
	@echo "echo \"$(RCS) Backup not present: can't uninstall...\"" >> $(PRERM)
	@echo "exit 1" >> $(PRERM)
	@echo "fi" >> $(PRERM)

postrm:
	@echo "#!/bin/sh" > $(POSTRM)
	@echo "echo \"Push back original $(RCS) startup script...\"" >> $(POSTRM)
	@echo "[ -f $(USRETC)/$(RCS).orig ] && mv -f $(USRETC)/$(RCS).orig $(USRETC)/$(RCS)" >> $(POSTRM)
	@echo "rm -f $(TMPETC)/nologin" >> $(POSTRM)
	@echo "exit 0" >> $(POSTRM)
endif

