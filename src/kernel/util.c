#include "util.h"

// Copies size number of BYTES from src to dst
void _mem_cpy(char* src, char* dst, int size) {
	int i;
	for(i = 0; i < size; i++)
		*(dst + i) = *(src + i);
}
