[org 0x0100]

jmp START


%include "drawNotes.asm"

clear_screen:
    mov ah, 0x06       ; Scroll up function
    mov al, 0          ; Number of lines to scroll (0 = clear entire screen)
    mov bh, 0x07       ; Video page and attribute (07h = normal text)
    mov cx, 0x0000     ; Upper-left corner of the screen (row 0, col 0)
    mov dx, 0x184F     ; Lower-right corner (row 24, col 79)
    int 0x10           ; Call BIOS interrupt 10h to clear the screen
RET                    ; Return from subroutine





DRAW_VERTICAL_LINE:
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

    loopDrawVerticalLine:
        int 10h
        inc dx ;increment y axis
        dec si ;decrement counter
    jnz loopDrawVerticalLine

    popA
    mov sp, bp
    pop bp
ret 6


DRAW_VERTICAL_GRID:

    push bp
    mov bp, sp

    mov bx,8
    push bx ;x
    push word 8 ;y
    push word 405 ;len

    mov cx,10

    loopDrawVericalGrid:

        call DRAW_VERTICAL_LINE
            add bx, 45
            push bx ;x
            push word 8 ;y
            push word 405 ;len

            loop loopDrawVericalGrid


    mov sp, bp
    pop bp
ret



DRAW_HORIZONTAL_LINE:
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

    loopDrawHorizontalLine:
        int 10h
        inc cx ;increment x axis
        dec si ;decrement counter
    jnz loopDrawHorizontalLine
    popA
    mov sp, bp
    pop bp
ret 6





DRAW_HORIZONTAL_GRID:
    push bp
    mov bp, sp
    mov bx,8
    push word 8 ;x
    push bx ;y
    push word 405 ;len

    mov cx,10

    loopDrawHorizontal_Grid:
        call DRAW_HORIZONTAL_LINE
            add bx, 45
            push word 8 ;x
            push bx ;y
            push word 405 ;len

            loop loopDrawHorizontal_Grid

    mov sp, bp
    pop bp
    ret 



;///////////////////////////////////////////////////////////////

DRAW_THICK_VERTICAL:

ret

DRAW_THICK_HORIZONTAL:

ret

DRAW_NOTES:

RET
;/////////////////////////////////////////////////////////////////




START:
    call clear_screen
    
    mov ax, 0x12
    int 10h
   
    call DRAW_HORIZONTAL_GRID

    call DRAW_VERTICAL_GRID

   
    push word 17 ;y
    push word 17 ;x
    call DRAW__ALL_BOX_NOTES




mov ax, 0x4c00
int 21h



