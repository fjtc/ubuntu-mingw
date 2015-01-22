# This is free and unencumbered software released into the public domain.
# 
# Anyone is free to copy, modify, publish, use, compile, sell, or
# distribute this software, either in source code form or as a compiled
# binary, for any purpose, commercial or non-commercial, and by any
# means.
# 
# In jurisdictions that recognize copyright laws, the author or authors
# of this software dedicate any and all copyright interest in the
# software to the public domain. We make this dedication for the benefit
# of the public at large and to the detriment of our heirs and
# successors. We intend this dedication to be an overt act of
# relinquishment in perpetuity of all present and future rights to this
# software under copyright law.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR
# OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
# ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
# OTHER DEALINGS IN THE SOFTWARE.
#
# For more information, please refer to <http://unlicense.org>
DST_DIR=packages

help: 
	echo Run 'make stage-1' to compile all basic libraries
	echo Run 'make stage-2' to compile all libraries that depends on stage-1 libraries

stage-1: make.zlib make.gtest
	echo Install all stage-1 packages before start stage-2

stage-2: make.openssl

make.zlib:
	make -f Makefile-base LIB_NAME=zlib DST_DIR=${DST_DIR} install

make.gtest:
	make -f Makefile-base LIB_NAME=gtest DST_DIR=${DST_DIR} install

make.openssl:
	make -f Makefile-base LIB_NAME=openssl DST_DIR=${DST_DIR} install

clean:
	make -C zlib clean
	make -C gtest clean
	make -C openssl clean

