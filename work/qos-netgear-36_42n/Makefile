include ../Rules.mak

all:
	@echo "Nothing to do: run 'make install' to install."

install:
	install -m 0755 -d $(APPDIR)
	install -m 0755 rc_qos $(APPDIR)
	ln -sf rc_qos $(APPDIR)/rc_buffer_bloat

clean: 
	@echo "Nothing to clean"

