#include "util.h"

// Copies size number of BYTES from src to dst
void mem_copy(char* src, char* dst, int size) {
	int i;
	for(i = 0; i < size; i++)
		*(dst + i) = *(src + i);
}

void int_to_ascii(int input, char out[]) {
	int i = 0;
	int neg = 0;
	if(input < 0) {
		neg = 1;	// set negative flag	
		input *= -1;	// make int positive
		i++;		// move to next str position
	} 
	while(input != 0) {
		out[i] = input % 10 + '0';
		input -= input % 10;
		input /= 10;
		i++;
	}
	i++;
	out[i] = '\0';
	// The output string now needs to be reversed
	int j;
	int end = i - 1;
	for(j = 0; j < i; j++) {
		char tmp = out[j];
		out[j] = out[end];
		out[end] = tmp;
		end--;
	}
}
