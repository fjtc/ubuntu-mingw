
GCC_PREFIX=i686-w64-mingw32
CC=$(GCC_PREFIX)-gcc
CXX=$(GCC_PREFIX)-g++
CPP=$(GCC_PREFIX)-cpp
AR=$(GCC_PREFIX)-ar
RANLIB=$(GCC_PREFIX)-ranlib

SRC_VERSION=1.7.0
SRC_PREFIX=gtest-${SRC_VERSION}
SRC_PACK=gtest-1.7.0.zip

# Target directories
TARGET_NAME=gtest-mingw-w64-i686-${SRC_VERSION}
TARGET_DIR=build/${TARGET_NAME}
TARGET_FILE=${TARGET_DIR}.deb
TARGET_LIB_DIR=../${TARGET_DIR}/usr/lib/gcc/${GCC_PREFIX}/4.8
TARGET_INCLUDE_DIR=${TARGET_LIB_DIR}/include
TARGET_DEB_DIR=$(TARGET_DIR)/DEBIAN

all: ${TARGET_FILE}

${SRC_PACK}:
	wget https://googletest.googlecode.com/files/gtest-1.7.0.zip

${SRC_PREFIX}: ${SRC_PACK}
	md5sum -c ${SRC_PACK}.md5
	unzip ${SRC_PACK}

run-configure: ${SRC_PREFIX}
	cd ${SRC_PREFIX} ; CC=${CC} AR=${AR} RANLIB=${RANLIB} CXX=${CXX} ./configure --prefix=/tmp --includedir=${TARGET_INCLUDE_DIR} --libdir=${TARGET_LIB_DIR}

run-make: run-configure
	make -C ${SRC_PREFIX} -f Makefile clean
	make -C ${SRC_PREFIX} -f Makefile

run-install: run-make
	make -C ${SRC_PREFIX} -f Makefile install

${TARGET_FILE}: run-install
	-mkdir ${TARGET_DEB_DIR}
	cp control-${GCC_PREFIX} ${TARGET_DEB_DIR}/control
	dpkg-deb --build ${TARGET_DIR}

clean:
	-rm -Rf ${SRC_PREFIX}
	-rm -Rf ${TARGET_DIR}

