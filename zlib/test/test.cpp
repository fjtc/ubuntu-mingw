
#include <zlib.h>

int main(int argc, char **argv) {
	int retval;
	z_stream strm;
	
	memset(&strm, 0, sizeof(z_stream));
	retval = deflateInit(&strm, Z_DEFAULT_COMPRESSION);

	return retval;
}

