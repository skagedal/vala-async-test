VALAC=valac
VALAFLAGS=--target-glib=2.36

all: async-client async-server

async-client: async-client.vala async-interface.vala
	$(VALAC) -o $@ $^ $(VALAFLAGS) --pkg gio-2.0

async-server: async-server.vala async-interface.vala
	$(VALAC) -o $@ $^ $(VALAFLAGS) --pkg gio-2.0

	
