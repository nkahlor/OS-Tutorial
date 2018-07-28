#ifndef _IDT_H_
#define _IDT_H_

#include "types.h"

#define KERNEL_CS 0x08
#define IDT_SIZE 256	// there are a max of 256 interrupts

/* If you see types you don't recognize, check out types.h */

struct idt_entry_t {
	u16 base_lo;	// lower 16 bits of address to jump to when interrupt fires
	u16 sel;	// kernel segment selector
	u8 always0;	// this is always 0
	u8 flags;	// See documentation
	u16 base_hi	// upper 16 bits of address to jump to
} __attribute__((packed));
typedef struct idt_entry_t idt_entry_t;

// A pointer to the array of interrupt handlers defined below.
// Assembly instruction 'lidt' will read it
struct idt_ptr_t {
	u16 limit;
	u32 base;
} __attribute__((packed));
typedef struct idt_ptr_t idt_ptr_t;

idt_entry_t idt_entries[IDT_SIZE];
idt_ptr_t idt_ptr;

// Function prototypes
void set_idt_gate(int n, u32 handler);
void set_idt();

#endif
