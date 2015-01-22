
all: compile


compile:
	make -C zlib
	make -C gtest
	make -C openssl

clean:
	make -C zlib clean
	make -C gtest clean
	make -C openssl clean

