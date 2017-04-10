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

install:
	$(SSTRIP) $(BINS)
	install -m 0755 -d $(ETCDIR)
	install -m 0755 -d $(BINDIR)
	install -m 0755 $(RCS) $(ETCDIR)
	install -m 0755 $(BINS) $(BINDIR)

clean:
	rm -f *~ *.o *.so $(BINS)

