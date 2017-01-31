include ../Rules.mak

LIBS = libscnvram.so

DEFS +=
CFLAGS += -W -Wall -Werror

ifeq ($(BOOT_NAND_FLASH),1)
DEFS += -DBOOT_NAND_FLASH
endif

ifeq ($(TR069),1)
DEFS += -DTR069
endif

ifeq ($(LOCAL),1)
DEFS += -DLOCAL=1 -DLROOT=\"$(PREFIX)\"
else
CFLAGS += -Os -s
endif

ifeq ($(DEBUG),1)
DEFS += -DTEST
CFLAGS += -g
endif

all: $(LIBS)

libscnvram.so: nvram.o nvram_lock.o
	$(CC) $(CFLAGS) $(DEFS) -shared -Wl,-soname,$@ $^ -o $@ 
	$(STRIP) $@

nvram.o: nvram.c
	$(CC) $(CFLAGS) $(DEFS) -c -fPIC $^ -o $@
	$(STRIP) $(STRIPFLAGS) $@

nvram_lock.o: nvram_lock.c
	$(CC) $(CFLAGS) $(DEFS) -c -fPIC $^ -o $@
	$(STRIP) $(STRIPFLAGS) $@

install:
	cp -f $(LIBS) $(LIBDIR)

clean:
	rm -rf *~ *.o *.so $(LIBS)

