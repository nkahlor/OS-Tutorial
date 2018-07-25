; load DH sectors to ES:BX from drive DL (fun, right?)
disk_load:
	push dx				; Store DX on stack so later we can recall
						; how many sectors were requested to be read
	mov ah, 0x02		; BIOS read sector function
	mov al, dh			; Read DH sectors
	mov ch, 0x00		; Select cylinder 0
	mov dh, 0x00		; Select head 0
	mov cl, 0x02		; Start reading from the second sector (just after the boot sector)

	int 0x13			; Trigger BIOS interrupt
	
	jc disk_error		; Jump if error

	pop dx				; Put our buddy DX back where he belongs
	cmp dh, al			; if AL (sectors read) != DH (sectors requested)
	jne disk_error		; display error message
	ret					; else we good fam

disk_error:
	mov bx, DISK_ERROR_MSG
	call print_string		; BIOS function
	jmp $

; Variables
DISK_ERROR_MSG	db "Disk read error...", 0
