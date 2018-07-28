#include "idt.h"

void set_idt_gate(int n, u32 handler) {
	idt_entries[n].base_lo = low_16(handler);
	idt_entries[n].sel = KERNEL_CS;
	idt_entries[n].always0 = 0; // imagine that...
	idt_entries[n].flags = 0x8E; // documentation demands it I suppose...
	idt_entries[n].base_hi = high_16(handler);
}

void set_idt() {
	idt_ptr.base = (u32) &idt_entries;  // make the pointer point :^)
	idt_ptr.limit = IDT_SIZE * sizeof(idt_entry_t) - 1;

	// Load the pointer!
	// lidt stands for load interrupt descriptor table, for obvious reasons this
	// needs to be done in assembly.
	__asm__ __volatile__("lidt (%0)" : : "r" (&idt_ptr));	
}
