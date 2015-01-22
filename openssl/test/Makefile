

all: check

test-i686-w64-mingw32.exe:
	make -f Makefile-base GCC_PREFIX=i686-w64-mingw32

test-x86_64-w64-mingw32.exe: 
	make -f Makefile-base GCC_PREFIX=x86_64-w64-mingw32
	
check: test-i686-w64-mingw32.exe test-x86_64-w64-mingw32.exe
	file test-i686-w64-mingw32.exe
	file test-x86_64-w64-mingw32.exe

clean:
	-rm *.exe

