[org 0x0100]

jmp start

clear_screen:
    mov ah, 0x06       ; Scroll up function
    mov al, 0          ; Number of lines to scroll (0 = clear entire screen)
    mov bh, 0x07       ; Video page and attribute (07h = normal text)
    mov cx, 0x0000     ; Upper-left corner of the screen (row 0, col 0)
    mov dx, 0x184F     ; Lower-right corner (row 24, col 79)
    int 0x10           ; Call BIOS interrupt 10h to clear the screen
    ret                ; Return from subroutine


drawVertical:
    mov ah, 0x0c
    push bp
    mov bp, sp
    sub sp, 2
    pushA
    mov si, [bp + 4] ; counter
    mov di, 0
    mov cx, [bp + 8]
    mov dx, [bp + 6]
    mov bh, 0
    mov al, 12

    reloop:
        int 10h
        inc dx
        dec si
    jnz reloop
    popA
    mov sp, bp
    pop bp
ret 6


drawHorizontal:
    mov ah, 0x0c
    push bp
    mov bp, sp
    sub sp, 2
    pushA
    mov si, [bp + 4] ; counter
    mov di, 0
    mov cx, [bp + 8]
    mov dx, [bp + 6]
    mov bh, 0
    mov al, 12

    reloop1:
        int 10h
        inc cx
        dec si
    jnz reloop1
    popA
    mov sp, bp
    pop bp
ret 6


start:
    call clear_screen
    
    mov ax, 0x13
    int 10h

    push word 150 ;x
    push word 150 ;y
    push word 50 ;len
    call drawVertical

    push word 150 ;x
    push word 150 ;y
    push word 50 ;len
    call drawHorizontal

    mov ax, 0x4c00
    int 21h



