include ../Rules.mak

GIT_EXEC	:= $(shell echo $(GIT_NAME) | head -c 3)

BINS		:= $(GIT_EXEC)
OBJS		:= $(GIT_NAME).o

CFLAGS		+= -W -Wall -Werror -Wbad-function-cast -Wcast-align -Wcast-qual -Wmissing-prototypes -Wstrict-prototypes -Wnested-externs -Wpointer-arith -Wredundant-decls -Wshadow -Winline
LDFLAGS		:= -L../$(NVRAM)
LIBS		:= -lscnvram
CPPFLAGS	:= -I../$(NVRAM)
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

$(BINS): $(OBJS)
	$(CC) $(CFLAGS) $(LDFLAGS) $(LIBS) $(CPPFLAGS) $(DEFS) $^ -o $@

%.o : %.c
	$(CC) $(CFLAGS) $(LDFLAGS) $(LIBS) $(CPPFLAGS) $(DEFS) -c $< -o $@

install:
	$(SSTRIP) $(BINS)
	install -m 0755 -d $(BINDIR)
	install -m 0755 $(BINS) $(BINDIR)

clean:
	rm -f *~ *.o *.so $(BINS)

