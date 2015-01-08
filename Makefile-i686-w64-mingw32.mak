
PREFIX=i686-w64-mingw32
CC=$(PREFIX)-gcc
CXX=$(PREFIX)-g++
CPP=$(PREFIX)-cpp
AR=$(PREFIX)-ar
RANLIB=$(PREFIX)-ranlib
BUILD_DIR=$(PREFIX)/build
DEB_DIR=$(PREFIX)/deb
ZLIB_TITLE=zlib-1.2.8

all: run-install

${ZLIB_TITLE}.tar.gz:
	wget http://zlib.net/${ZLIB_TITLE}.tar.gz
	md5sum -c ${ZLIB_TITLE}.tar.gz.md5

${ZLIB_TITLE}: ${ZLIB_TITLE}.tar.gz
	tar -xzf ${ZLIB_TITLE}.tar.gz

run-configure: ${ZLIB_TITLE}
	cd ${ZLIB_TITLE} ; CC=${CC} AR=${AR} RANLIB=${RANLIB} ./configure --static

run-make: run-configure
	make -C ${ZLIB_TITLE} -f Makefile

run-install: run-make
	cd zlib-1.2.8
	make -C ${ZLIB_TITLE} -f Makefile install prefix=../${BUILD_DIR}

zlib-dev-mingw-w64-i686.deb:
	mkdir ${DEB_DIR}/
	cp ${BUILD_DIR}/include 



