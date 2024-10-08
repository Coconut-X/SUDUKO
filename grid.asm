[org 0x0100]

jmp start


zero_bitmap:    db 0,1,1,1,1,1,0,   1,0,0,0,0,0,1,  1,0,0,0,0,0,1,  1,0,0,0,0,0,1,  1,0,0,0,0,0,1,  1,0,0,0,0,0,1,  0,1,1,1,1,1,0,  2 ;7x7 bitmap , 7 is height of the bitmap

one_bitmap:     db 0,0,0,1,0,0,0,   0,0,1,1,0,0,0,  0,1,0,1,0,0,0,  0,0,0,1,0,0,0,  0,0,0,1,0,0,0,  0,0,0,1,0,0,0,  0,1,1,1,1,1,0,  2 ;7x7 bitmap

two_bitmap:     db 1,1,1,1,1,1,1,   0,0,0,0,0,0,1,  0,0,0,0,0,0,1,  1,1,1,1,1,1,1,  1,0,0,0,0,0,0,  1,0,0,0,0,0,0,  1,1,1,1,1,1,1,  2 ;

three_bitmap:   db 1,1,1,1,1,1,1,   0,0,0,0,0,0,1,  0,0,0,0,0,0,1,  1,1,1,1,1,1,1,  0,0,0,0,0,0,1,  0,0,0,0,0,0,1,  1,1,1,1,1,1,1,  2 ;

four_bitmap:    db 1,0,0,0,0,0,1,   1,0,0,0,0,0,1,  1,0,0,0,0,0,1,  1,1,1,1,1,1,1,  0,0,0,0,0,0,1,  0,0,0,0,0,0,1,  0,0,0,0,0,0,1,  2 ;

five_bitmap:    db 1,1,1,1,1,1,1,   1,0,0,0,0,0,0,  1,0,0,0,0,0,0,  1,1,1,1,1,1,1,  0,0,0,0,0,0,1,  0,0,0,0,0,0,1,  1,1,1,1,1,1,1,  2 ;

six_bitmap:     db 1,1,1,1,1,1,1,   1,0,0,0,0,0,0,  1,0,0,0,0,0,0,  1,1,1,1,1,1,1,  1,0,0,0,0,0,1,  1,0,0,0,0,0,1,  1,1,1,1,1,1,1,  2 ;

seven_bitmap:   db 1,1,1,1,1,1,1,   0,0,0,0,0,1,0,  0,0,0,0,1,0,0,  0,0,0,1,0,0,0,  0,0,1,0,0,0,0,  0,1,0,0,0,0,0,  1,0,0,0,0,0,0,  2 ;

eight_bitmap:   db 1,1,1,1,1,1,1,   1,0,0,0,0,0,1,  1,0,0,0,0,0,1,  1,1,1,1,1,1,1,  1,0,0,0,0,0,1,  1,0,0,0,0,0,1,  1,1,1,1,1,1,1,  2 ;

nine_bitmap:    db 1,1,1,1,1,1,1,   1,0,0,0,0,0,1,  1,0,0,0,0,0,1,  1,1,1,1,1,1,1,  0,0,0,0,0,0,1,  0,0,0,0,0,0,1,  1,1,1,1,1,1,1,  2 ;




setDI_One:
    mov di,1
    add dx,1 ;increment y axis
    int 10h
    sub cx,5 ;decrement x axis to original position
    ret

DRAW_BITMAP:
    push bp
    mov bp,sp
    pushA
    ;mov si,zero_bitmap ;the array will be in bx
    mov si, nine_bitmap

    mov ah, 0x0c
    mov bh, 0
    mov cx, [bp+4] ;x
    mov dx, [bp+6] ;y
    dec dx
    mov al, 12


    nextRow:
        inc dx
        mov di, 1
        mov cx, [bp + 4]
        CurrentRow:
            cmp byte[si], 2
            jz exitDrawBitmap
            cmp byte[si], 1
            jnz skipPrint
            int 10h
            skipPrint:
                inc cx
                inc di
                inc si
                cmp di, 8
            jz nextRow
        jmp CurrentRow



    exitDrawBitmap:
        popA
        mov sp,bp
        pop bp

ret 4


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
    sub sp, 2 ;space for counter
    pushA
    mov si, [bp + 4] ; counter
    mov di, 0
    mov cx, [bp + 8] ;x
    mov dx, [bp + 6] ;y
    mov bh, 0
    mov al, 12

    loopDrawVertical:
        int 10h
        inc dx ;increment y axis
        dec si ;decrement counter
    jnz loopDrawVertical

    popA
    mov sp, bp
    pop bp
ret 6


DRAW_VERTICAL_GRID:

    push bp
    mov bp, sp

    mov bx,8
    push bx ;x
    push word 50 ;y
    push word 405 ;len

    mov cx,10

    loopDrawVericalGrid:

        call drawVertical
            add bx, 45
            push bx ;x
            push word 50 ;y
            push word 405 ;len

            loop loopDrawVericalGrid


    mov sp, bp
    pop bp
ret



drawHorizontal:
    mov ah, 0x0c
    push bp
    mov bp, sp
    sub sp, 2 ;space for counter
    pushA

    mov si, [bp + 4] ; counter
    mov cx, [bp + 8] ;x
    mov dx, [bp + 6] ;y
    mov bh, 0 ;page number
    mov al, 12 ;color

    loopDrawHorizontal:
        int 10h
        inc cx ;increment x axis
        dec si ;decrement counter
    jnz loopDrawHorizontal
    popA
    mov sp, bp
    pop bp
ret 6





DRAW_HORIZONTAL_GRID:
    push bp
    mov bp, sp
    mov bx,50
    push word 8 ;x
    push bx ;y
    push word 405 ;len

    mov cx,10

    loopDrawHorizontal_Grid:
        call drawHorizontal
            add bx, 45
            push word 8 ;x
            push bx ;y
            push word 405 ;len

            loop loopDrawHorizontal_Grid

    mov sp, bp
    pop bp
    ret 


DRAW_THICK_VERTICAL:

ret


DRAW_THICK_HORIZONTAL:

ret





start:
    call clear_screen
    
    mov ax, 0x12
    int 10h
   
    ;call DRAW_HORIZONTAL_GRID

    ;call DRAW_VERTICAL_GRID

   
    ; push word 50 ;y
    ; push word 50 ;x

    ; call DRAW_BITMAP



mov ax, 0x4c00
int 21h



