PREFIX=/usr/local
PROG=kagami

all: ${PROG}

install: ${PROG}
	mkdir -p ${PREFIX}/man/man1
	./gen-manfile > ${PREFIX}/man/man1/$<.1
	install -m 755 $< ${PREFIX}/bin

uninstall: ${PROG}
	rm -rf ${PREFIX}/man/man1/$<.1
	rm -rf ${PREFIX}/bin/$<
