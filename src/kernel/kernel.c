#include "../drivers/screen.h"
#include "util.h"
#include "../cpu/isr.h"
#include "../cpu/idt.h"

void _start() {
	// gotta make interrupts available first thing	
	isr_install();

	clear_screen();
	print("Kernel Entry\n\n");
	
	__asm__ __volatile__("int $2");
	__asm__ __volatile__("int $3");
}

