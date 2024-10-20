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
RET 6


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
RET


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
RET 6





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
RET 



DRAW_GRID:

    PUSH BP
    MOV BP,SP    
    
    push word 5
    push word 5
    call DRAW_HORIZONTAL_GRID

    push word 5
    push word 5
    call DRAW_VERTICAL_GRID

    MOV SP,BP
    POP BP

RET 



;///////////////////////////////////////////////////////////////

DRAW_THICK_VERTICAL:

   
ret


DRAW_THICK_HORIZONTAL:

ret

DRAW_NOTES:

RET
;/////////////////////////////////////////////////////////////////





