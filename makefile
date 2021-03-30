PREFIX=/usr/local

prog=kagami

all: ${prog}

install: ${prog}
	install -m 755 $< ${PREFIX}/bin

uninstall:
	rm ${PREFIX}/bin/${prog}
