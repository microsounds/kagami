PREFIX=/usr/local
PROG=kagami

install: ${PROG} ${PROG}.1.gz
	install -m 755 $< ${PREFIX}/bin

${PROG}.1.gz:
	mkdir -p ${PREFIX}/share/man/man1
	./gen-manpage | gzip > ${PREFIX}/share/man/man1/$@

uninstall: ${PROG}
	rm -rf ${PREFIX}/share/man/man1/$<*
	rm -rf ${PREFIX}/bin/$<*
