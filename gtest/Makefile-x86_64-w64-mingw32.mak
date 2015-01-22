
GCC_PREFIX=x86_64-w64-mingw32
CC=$(GCC_PREFIX)-gcc
CXX=$(GCC_PREFIX)-g++
CPP=$(GCC_PREFIX)-cpp
AR=$(GCC_PREFIX)-ar
RANLIB=$(GCC_PREFIX)-ranlib
CFLAGS=-m64

SRC_VERSION=1.7.0
SRC_PREFIX=gtest-${SRC_VERSION}
SRC_PACK=gtest-1.7.0.zip

# Target directories
TARGET_NAME=gtest-mingw-w64-x86_64-${SRC_VERSION}-dev
TARGET_DIR=build/${TARGET_NAME}
TARGET_FILE=${TARGET_DIR}.deb
TARGET_LIB_DIR=${TARGET_DIR}/usr/lib/gcc/${GCC_PREFIX}/4.8
TARGET_INCLUDE_DIR=${TARGET_LIB_DIR}/include
TARGET_DEB_DIR=$(TARGET_DIR)/DEBIAN
TMP_DIR=${TARGET_DIR}.tmp

all: ${TARGET_FILE}

${SRC_PACK}:
	wget https://googletest.googlecode.com/files/gtest-1.7.0.zip

${SRC_PREFIX}: ${SRC_PACK}
	md5sum -c ${SRC_PACK}.md5
	unzip -o ${SRC_PACK}

${TMP_DIR}:
	-mkdir -p ${TMP_DIR}

${TMP_DIR}/gtest-all.o: ${SRC_PREFIX} ${TMP_DIR}
	${CXX} ${CFLAGS} -isystem ${SRC_PREFIX}/include -I${SRC_PREFIX} -pthread -c ${SRC_PREFIX}/src/gtest-all.cc -o $@
	
libgtest.a: ${TMP_DIR}/gtest-all.o
	${AR} -rv ${TMP_DIR}/libgtest.a ${TMP_DIR}/gtest-all.o

${TARGET_FILE}: libgtest.a
	-mkdir -p ${TARGET_DEB_DIR}
	-mkdir -p ${TARGET_LIB_DIR}
	-mkdir -p ${TARGET_INCLUDE_DIR}
	cp ${TMP_DIR}/libgtest.a ${TARGET_LIB_DIR}
	cp -r ${SRC_PREFIX}/include/gtest ${TARGET_INCLUDE_DIR}
	cp control-${GCC_PREFIX} ${TARGET_DEB_DIR}/control
	dpkg-deb --build ${TARGET_DIR}

clean:
	-rm -Rf ${TMP_DIR}
	-rm -Rf ${TARGET_DIR}

