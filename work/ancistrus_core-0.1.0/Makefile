include ../Rules.mak

GIT_EXEC	:= $(shell echo $(GIT_NAME) | head -c 3)
BINS		:= $(GIT_EXEC)

CFLAGS		+= -W -Wall -Werror -Wbad-function-cast -Wcast-align -Wcast-qual -Wmissing-prototypes -Wstrict-prototypes -Wnested-externs -Wpointer-arith -Wredundant-decls -Wshadow -Winline
LDFLAGS		:= -L../$(NVRAM) -lscnvram
INCLUDES	:= -I../$(NVRAM)
DEFS		:= -DPROJFOUNDER=\"$(PROJECT_FOUNDER)\" -DPROJNAME=\"$(PROJECT_NAME)\" -DPROJPLOT=\"$(PROJECT_PLOT)\" \
-DPROJTARGET=\"$(PROJECT_TARGET)\" -DHOMEPAGE=\"$(GITHUB_DIR)\"

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

$(GIT_EXEC): $(GIT_NAME).c
	$(CC) $(GIT_NAME).c $(CFLAGS) $(LDFLAGS) $(INCLUDES) $(DEFS) -o $@
	$(SSTRIP) $@

install: 
	cp -f $(BINS) $(BINDIR)

clean: 
	rm -f *~ *.o *.so $(BINS)

