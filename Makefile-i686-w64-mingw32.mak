
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

gtest-all.o: ${SRC_PREFIX}
	${CXX} -isystem ${SRC_PREFIX}/include -I${SRC_PREFIX} -pthread -c ${SRC_PREFIX}/src/gtest-all.cc
	
libgtest.a: gtest-all.o
	${AR} -rv libgtest.a gtest-all.o

${TARGET_FILE}: libgtest.a
	-mkdir ${TARGET_DEB_DIR}
	-mkdir -p ${TARGET_DEB_DIR}/usr/lib/gcc/${GCC_PREFIX}/4.8
	-mkdir -p ${TARGET_DEB_DIR}/usr/lib/gcc/${GCC_PREFIX}/4.8/include
	cp libgtest.a ${TARGET_DEB_DIR}/usr/lib/gcc/${GCC_PREFIX}/4.8
	cp -r ${SRC_PREFIX}/include/gtest ${TARGET_DEB_DIR}/usr/lib/gcc/${GCC_PREFIX}/4.8/include/gtest
	cp control-${GCC_PREFIX} ${TARGET_DEB_DIR}/control
	dpkg-deb --build ${TARGET_DIR}

clean:
	-rm -Rf *.o
	-rm -Rf *.a
	-rm -Rf ${SRC_PREFIX}
	-rm -Rf ${TARGET_DIR}

