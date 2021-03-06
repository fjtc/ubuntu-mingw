
GCC_PREFIX=x86_64-w64-mingw32
CC=$(GCC_PREFIX)-gcc
CXX=$(GCC_PREFIX)-g++
CPP=$(GCC_PREFIX)-cpp
AR=$(GCC_PREFIX)-ar
RANLIB=$(GCC_PREFIX)-ranlib

ZLIB_VERSION=1.2.8
ZLIB_PREFIX=zlib-${ZLIB_VERSION}

# Target directories
TARGET_NAME=libz-mingw-w64-x86-64-${ZLIB_VERSION}-dev
TARGET_DIR=build/${TARGET_NAME}
TARGET_FILE=${TARGET_DIR}.deb
TARGET_LIB_DIR=../${TARGET_DIR}/usr/lib/gcc/${GCC_PREFIX}/4.8
TARGET_INCLUDE_DIR=${TARGET_LIB_DIR}/include
TARGET_DEB_DIR=$(TARGET_DIR)/DEBIAN

all: ${TARGET_FILE}

${ZLIB_PREFIX}.tar.gz:
	wget http://zlib.net/${ZLIB_PREFIX}.tar.gz
	md5sum -c ${ZLIB_PREFIX}.tar.gz.md5

${ZLIB_PREFIX}: ${ZLIB_PREFIX}.tar.gz
	tar -xzf ${ZLIB_PREFIX}.tar.gz

run-configure: ${ZLIB_PREFIX}
	cd ${ZLIB_PREFIX} ; CC=${CC} AR=${AR} RANLIB=${RANLIB} ./configure --static --prefix=/tmp --includedir=${TARGET_INCLUDE_DIR} --libdir=${TARGET_LIB_DIR}

run-make: run-configure
	make -C ${ZLIB_PREFIX} -f Makefile clean
	make -C ${ZLIB_PREFIX} -f Makefile

run-install: run-make
	make -C ${ZLIB_PREFIX} -f Makefile install

${TARGET_FILE}: run-install
	-mkdir ${TARGET_DEB_DIR}
	cp control-${GCC_PREFIX} ${TARGET_DEB_DIR}/control
	dpkg-deb --build ${TARGET_DIR}

clean:
	-rm -Rf ${ZLIB_PREFIX}
	-rm -Rf ${TARGET_DIR}

