; A boot sector that boots a C kernel in a 32-bit protected mode
[org 0x7c00]
KERNEL_OFFSET equ 0x1000	; This is the memory offset to which we will load our kernel

	mov[BOOT_DRIVE], dl		; BIOS stores our boot drive in dl, so it's 
							; best to remember this for later
	mov bp, 0x9000			; Set-up the stack
	mov sp, bp
	
	mov bx, MSG_REAL_MODE	; Announce that we are starting booting from 16-bit real mode
	call print_string		; print with BIOS interrupt

	call load_kernel		; Load Mr. Kernel

	call switch_to_pm		; Switch to 32-bit mode, no going back to 16 from here on

	jmp $					; spinlock

; Include some dope-ass routines
%include "print_bios.asm"
%include "disk_load.asm"
%include "gdt.asm"
%include "print_pm.asm"
%include "switch_to_pm.asm"

[bits 16]

; load_kernel, this is done in 16-bit mode (duh)
load_kernel:
	mov bx, MSG_LOAD_KERNEL			; Print a message indicating that we're loading the kernel
	call print_string				; print with BIOS

	mov bx, KERNEL_OFFSET			; Set up params for the disk_load routine such that we load
	mov dh, 2						; the first 15 sectors (excluding the boot sector) from the boot
	mov dl, [BOOT_DRIVE]			; disk (which is out kernel code) to address KERNEL_OFFSET
	call disk_load

	ret

[bits 32]
; This is where we arrive after switching to and initializing protected mode

BEGIN_PM:
	
	mov ebx, MSG_PROT_MODE			; Use our 32-bit print routine to announce that we're in protected mode
	call print_string_pm
	
	call KERNEL_OFFSET				; Now jump to the address of out loaded kernel code!
									
	jmp $							; spin around and around


; Global vars
BOOT_DRIVE		db 0
MSG_REAL_MODE	db "Started in 16-bit Real Mode", 0
MSG_PROT_MODE   db "Successfully landed in 32-bit Protected Mode", 0
MSG_LOAD_KERNEL db "Loading kernel into memory.", 0

; Bootsector padding
times 510-($-$$) db 0
dw 0xaa55

