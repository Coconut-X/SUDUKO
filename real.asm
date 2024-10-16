[org 0x0100]

jmp START


%include "drawNotes.asm"

clear_screen:
    mov ah, 0x06                                    ; Scroll up function
    mov al, 0                                       ; Number of lines to scroll (0 = clear entire screen)
    mov bh, 0x07                                    ; Video page and attribute (07h = normal text)
    mov cx, 0x0000                                  ; Upper-left corner of the screen (row 0, col 0)
    mov dx, 0x184F                                  ; Lower-right corner (row 24, col 79)
    int 0x10                                        ; Call BIOS interrupt 10h to clear the screen
RET                                                 ; Return from subroutine


DRAW_VERTICAL_LINE:
    mov ah, 0x0c
    push bp
    mov bp, sp
    sub sp, 2                                       ;SPACE FOR COUNTER
    pushA
    mov si, [bp + 4]                                ;COUNTER
    mov di, 0
    mov cx, [bp + 8]                                ;X
    mov dx, [bp + 6]                                ;Y
    mov bh, 0
    mov al, 12

    loopDrawVerticalLine:
        int 10h
        inc dx                                      ;INCREMENT Y AXIS
        dec si                                      ;DECREMENT COUNTER
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
    sub sp, 2                                           ;SPACE FOR COUNTER
    pushA

    mov si, [bp + 4]                                    ;COUNTER
    mov cx, [bp + 8]                                    ;X
    mov dx, [bp + 6]                                    ;Y
    mov bh, 0                                           ;PAGE NUMBER
    mov al, 12                                          ;COLOR

    loopDrawHorizontalLine:
        int 10h
        inc cx                                          ;INCREMENT X AXIS
        dec si                                          ;DECREMENT COUNTER
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
   
    ; push word 17
    ; push word 17
    ; call DRAW__ALL_BOX_NOTES

    push word 5
    push word 5
    call DRAW_HORIZONTAL_GRID

    push word 5
    push word 5
    call DRAW_VERTICAL_GRID


    push word 18
    push word 18
    call DRAW_SUDOKU_ARRAY

    ; push word 17
    ; push word 17
    ; call DRAW__ALL_BOX_NOTES
   



mov ax, 0x4c00
int 21h



