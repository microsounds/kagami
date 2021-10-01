PREFIX=/usr/local
PROG=kagami

install: ${PROG} ${PROG}.1
	install -m 755 $< ${PREFIX}/bin

${PROG}.1:
	mkdir -p ${PREFIX}/share/man/man1
	./gen-manpage > ${PREFIX}/share/man/man1/$@

uninstall: ${PROG}
	rm -rf ${PREFIX}/share/man/man1/$<.1
	rm -rf ${PREFIX}/bin/$<
