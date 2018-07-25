; GDT
gdt_start:

gdt_null:					; mandatory null descriptor
	dd 0x0					; dd-> define double word (4 bytes)
	dd 0x0
; the above section is 8 bytes

gdt_code:					; the code segment descriptor
	; base=0x0, limit=0xfffff
	; 1st flags: (present)1 (privilege)00 (descriptor type)1 -> 1001b
	; type flags: (code)1 (conforming)0 (readable)1 (accessed)0 -> 1010b
	; 2nd flags: (granularity)1 (32-bit default)1 (64-bit seg) 0 (AVL) -> 1100b
	dw 0xffff				; limit (bits 0-15)
	dw 0x0					; base (bits 0-15)
	db 0x0					; base (bits 16-23)
	db 10011010b			; 1st flags . type flags
	db 11001111b			; 2nd flags . limit (bits 16-19)
	db 0x0					; base (bits 24-31)

gdt_data:					; the data segment descriptor
	; same as code segment except for type flags:
	; type flags: (code)0 (expand down)0 (writable)1 (accessed)0 -> 0010b
	dw 0xffff				; limit (bits 0-15)
	dw 0x0					; base (bits 0-15)
	db 0x0					; base (bits 16-23)
	db 10010010b			; 1st flags . type flags
	db 11001111b			; 2nd flags . limit (bits 16-19)
	db 0x0					; base (bits 24-31)

gdt_end:		; the reason for putting a label at the end of the GDT is 
				; to have the assembler calculate the size of the GDT
				; for the descriptor below

; GDT descriptor
gdt_descriptor:
	dw gdt_end - gdt_start - 1		; Size of out GDT, always less 1 of true size
	dd gdt_start					; start address of our GDT

; Define some handy constants for the GDT segment descriptor offsets. These are what 
; segment registers must contain when in protected mode. For example, when we set
; DS = 0x10 in PM, the CPU knows what we mean is to use the segment described at offset 0x10
; (i.e. 16 bytes) in our GDT, which in out case is the DATA segment (0x0 -> NULL; 0x08 -> CODE; 0x10 -> DATA)
CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start

