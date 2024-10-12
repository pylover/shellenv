PREFIX ?= /usr/local/lib


.PHONY: install
install:
	cp shellenv.sh $(PREFIX)


.PHONY: uninstall
uninstall:
	rm $(PREFIX)/shellenv.sh
