;
; Provides a means to print various primitive types
;

; Input is the start address of the string, in reg bx
print_string:
	pusha				; preserve register vals on stack
	loop1:				; print each char until we encounter a null terminator
		cmp [bx], byte 0 		; is the current char the null term?
		je end			; exit the function if it was.
		call print_char ; If not, print the character
		add bx, 1 	; and move to next char	
		jmp loop1		
	end:
		popa
		ret

; input is a mem address to a char, in register bx
print_char:
	pusha

	mov al, [bx]	
	mov ah, 0x0e	; BIOS tele-type mode
	int 0x10		; print char in a1

	popa
	ret

; input is a hex number, in register dx
print_hex:
	pusha
	mov bx, 2					; 5 is location of lsd
	hex_loop:					; iterate until dx is zero
		rol dx, 4				; rotate the input param by 4 bits
		mov al, dl
		and al, 1111b			; only keep 4 bits 
		add al, '0'				; turns into text if al is in range [0-9]
		cmp al, '9'
		jle non_letter			; no need to offset
		add al, 7				; offset according to ascii chart (diff between '9' and 'A')
	non_letter:
		mov [HEX_OUT + bx], al
		inc bx
		cmp bx, 5
		jle hex_loop

	mov bx, HEX_OUT				; print str pointed to
	call print_string 			; bx is param
	popa
	ret

; global vars
HEX_OUT: db '0x0000',0
