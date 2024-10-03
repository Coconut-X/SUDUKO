[org 0x100]

jmp start

horizontalOffset: dw 0
verticalOffset: dw 0
lineLength: dw 0 ;both vertical or horizonral height/length

clear_screen:
    mov ah, 0x06       ; Scroll up function
    mov al, 0          ; Number of lines to scroll (0 = clear entire screen)
    mov bh, 0x07       ; Video page and attribute (07h = normal text)
    mov cx, 0x0000     ; Upper-left corner of the screen (row 0, col 0)
    mov dx, 0x184F     ; Lower-right corner (row 24, col 79)
    int 0x10           ; Call BIOS interrupt 10h to clear the screen
    ret                ; Return from subroutine

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
	
	
drawLineVertical:

	; pop word [lineLength]
	; pop word [verticalOffset]
	; pop word [horizontalOffset]
	
	push ax
	mov ax, 0x7f00; white bg 
	
	mov cx, [lineLength] 
	mov si, [verticalOffset]
	add si, [horizontalOffset]
	
	;add si,2
	
	it1:
		mov word[es:si], ax
		add si,264
		loop it1
	

	pop ax 
ret


drawLineHorizontal:
	
	
	push ax
	mov ax, 0x7f00; white bg 
	
	mov cx, [lineLength] 
	mov si, [verticalOffset]
	add si, [horizontalOffset]
	
	
	it2:
		mov word[es:si], ax
		add si,2
		loop it2
	

	pop ax 
ret

	


start:

MOV AX, 0x0054
INT 0x10

	mov ax, 0xb800
	mov es,ax
	mov si,0


	call clear_screen
	
	call changecolor


	mov word [horizontalOffset],4 ;2 offset 
	mov word [verticalOffset], 1320 ; offset 5 characters from top 5*264  
	mov word [lineLength],60 ; in characters
	
	; ;;push cx
	; push word [horizontalOffset]
	; push word [verticalOffset]
	; push word [lineLength]
	
	;call drawLineVertical
	call drawLineHorizontal
	
	


mov ax,0x4c00
int 21h
