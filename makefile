PREFIX=/usr/local

prog=kagami
install_loc=${PREFIX}/bin/${prog}

all:

install:
	cp ${prog} ${install_loc}
	chmod 755 ${install_loc}

uninstall:
	rm ${install_loc}
