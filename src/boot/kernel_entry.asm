; Ensures that we jump straight into the kernel's entry function.
[bits 32]					; We're in protected mode now
[extern _start]				; Declare that we will be referencing the external symbol 'main'.
							; The linker will substitute the final address
call _start		; invoke main() in our C kernel
jmp $			; hang eternally when we return from kernel
