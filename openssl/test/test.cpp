
#include <openssl/sha.h>
#include <openssl/ssl.h>

int main(int argc, char **argv) {
	int retval;
	
	// libcrypto
	SHA256_CTX state;
	retval = SHA256_Init(&state);
	
	// libssl
	SSL ssl;
	retval = SSL_SRP_CTX_init(&ssl);
	
	return retval;
}

