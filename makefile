# install location
PREFIX=/usr/local
BIN=bin
MAN=share/man/man1

PROG=kagami

install: ${PROG} ${PROG}.1
	install -m 755 $< ${PREFIX}/${BIN}

${PROG}.1:
	mkdir -p ${PREFIX}/${MAN}
	./gen-manpage > $@ && gzip < $@ > ${PREFIX}/${MAN}/$@.gz || :
	rm $@

uninstall: ${PROG}
	rm -rf ${PREFIX}/${BIN}/$<
	rm -rf ${PREFIX}/${MAN}/$<*
