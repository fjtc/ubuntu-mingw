
GCC_PREFIX=i686-w64-mingw32
CC=$(GCC_PREFIX)-gcc
CXX=$(GCC_PREFIX)-g++
CPP=$(GCC_PREFIX)-cpp
AR=$(GCC_PREFIX)-ar
RANLIB=$(GCC_PREFIX)-ranlib
CFLAGS=-m32

SRC_VERSION=1.0.1l
SRC_PREFIX=openssl-${SRC_VERSION}
SRC_PACK=openssl-1.0.1l.tar.gz

# Target directories
TARGET_NAME=openssl-mingw-w64-i686-${SRC_VERSION}
TARGET_DIR=build/${TARGET_NAME}
TARGET_FILE=${TARGET_DIR}.deb
TARGET_LIB_DIR=${TARGET_DIR}/usr/lib/gcc/${GCC_PREFIX}/4.8
TARGET_INCLUDE_DIR=${TARGET_LIB_DIR}/include
TARGET_DEB_DIR=$(TARGET_DIR)/DEBIAN
TMP_DIR=${PWD}/build/${GCC_PREFIX}.tmp

all: ${TARGET_FILE}

${SRC_PACK}:
	wget https://www.openssl.org/source/openssl-1.0.1l.tar.gz

${SRC_PREFIX}: ${SRC_PACK}
	md5sum -c ${SRC_PACK}.md5
	tar -xzf ${SRC_PACK}

configure: ${SRC_PREFIX}
	-make -C ${SRC_PREFIX} clean
	cd ${SRC_PREFIX}; ./Configure --cross-compile-prefix=${GCC_PREFIX}- --prefix=${TMP_DIR} zlib no-shared mingw

compile: configure
	make -C ${SRC_PREFIX} install

${TARGET_FILE}: compile
	-mkdir -p ${TARGET_DEB_DIR}
	-mkdir -p ${TARGET_LIB_DIR}
	-mkdir -p ${TARGET_INCLUDE_DIR}
	cp ${TMP_DIR}/lib/*.a ${TARGET_LIB_DIR}
	cp -R ${TMP_DIR}/include/openssl ${TARGET_INCLUDE_DIR}/openssl
	cp control-${GCC_PREFIX} ${TARGET_DEB_DIR}/control
	dpkg-deb --build ${TARGET_DIR}

clean:
	make -C ${SRC_PREFIX} clean
	-rm -Rf ${TMP_DIR}
	-rm -Rf ${TARGET_DIR}

