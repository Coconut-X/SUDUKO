;  [org 0x100]

;  jmp start

%include"pixel_data.asm"
;%include"real.asm"

changecolor:
	mov ax, 0x4000
	mov bx, 0
	mov si, 0
	
	iterator:
		mov word[es:si + bx], ax
		add bx, 2
		cmp bx, 11352
		;cmp bx, 264
		jnz iterator
		
ret
	

print_welcome_screen:
		pushA
	;call clear_screen
	mov dx, 03c8h; DAC write index register
	mov al, 0 ; Start at color index 0
	out dx, al
	mov dx, 03C9h; DAC data register
	mov cx, 768 ; 256 colors 3 (RGB)
	;mov cx,450
	mov si, frontScreen_palette_data

	set_welcome_palette_loop:

		lodsb
		out dx, al
		loop set_welcome_palette_loop

	;Plot pixels
	mov cx, 16000
	;Number of pixels (320x200)
	mov si, frontScreen_pixel_data
	;Index for pixel data
	xor di, di
	;Start at the beginning of video memory
	rep movsb
	popA
	ret


; movtoDiffscreen:
; 	mov ax, 0x12
; 	int 0x10

; 	ret


; start:

; mov ax, 0x13
; int 0x10
; ; Set ES to video memory segment
; mov ax, 0xa000
; mov es, ax


; call print_welcome_screen

; mov ax,0x4c00
; int 21h


