[bits 32]
; Constants
VIDEO_MEMORY equ 0xb8000
WHITE_ON_BLACK equ 0x0f

; prints a null-terminated string pointed to by edx register
print_string_pm:
	pusha
	mov edx, VIDEO_MEMORY		; set edx to start of video mem
	
	print_string_pm_loop:
		mov al, [ebx]			; store the char at ebx in al
		mov ah, WHITE_ON_BLACK	; store the attributes in ah

		cmp al, 0				; if (al == 0), we're at the end
		je done	; which means we're done

		mov[edx], ax			; store char and attributes at current char cell
		
		add ebx, 1				; increment to next char in string
		add edx, 2				; move to next char cell in vid mem
		
		jmp print_string_pm_loop	; loop around to print next char

done:
	popa
	ret
