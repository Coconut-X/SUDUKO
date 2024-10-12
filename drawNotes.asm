[org 0x0100]

jmp start



%include "bitMaps.asm"



clear_screen:
    mov ah, 0x06       ; Scroll up function
    mov al, 0          ; Number of lines to scroll (0 = clear entire screen)
    mov bh, 0x07       ; Video page and attribute (07h = normal text)
    mov cx, 0x0000     ; Upper-left corner of the screen (row 0, col 0)
    mov dx, 0x184F     ; Lower-right corner (row 24, col 79)
    int 0x10           ; Call BIOS interrupt 10h to clear the screen
RET                    ; Return from subroutine


DRAW_BITMAP: ;receives nine_bitmap
    push bp
    mov bp,sp
    pushA
    ;mov si,zero_bitmap ;the array will be in bx
    mov si, [bp+4] ;si=nine bitmap

    mov ah, 0x0c
    mov bh, 0
    mov cx, [bp+6] ;x
    mov dx, [bp+8] ;y
    dec dx
    mov al, 12

    nextRow:
        inc dx
        mov di, 1
        mov cx, [bp + 6]
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

ret 6



DRAW_BOX_NOTES:

    push bp
    mov bp,sp
    pushA

    push word  [start_y]
    push word  [start_x]

    mov bx, [bp+4]
    mov  [start_x], bx
    mov bx, [bp+6]
    mov [start_y],bx
   
    mov bx,10 ;DIFFERENCE BETWEEN X COORDINATES FROM LEFT OF ONE NUMBER TO LEFT OF THE NUMBER NEXT TO IT, SAME FOR Y

        mov cx,3 ;ROW COUNT

            mov dx,3 ;COLUMN COUNT
        PrintRow:
            push word  [start_y]
            push word  [start_x]
            push one_bitmap
            call DRAW_BITMAP
            add [start_x],bx

            dec dx
            jnz PrintRow
            mov dx,3 ; RESET COLUMN COUNT

            push bx
            mov bx,[bp+4]   ;RESET X
            mov [start_x], bx ;RESET X IN START_X
            pop bx

            add [start_y],bx ;INCREMENT Y 


            loop PrintRow
    pop word [start_x]
    pop word [start_y]

    popA
    mov sp,bp
    pop bp

RET 4



DRAW__ALL_BOX_NOTES:

    push bp
    mov bp,sp
    pushA

    mov bx, [bp+4]
    mov  [start_x], bx
    mov bx, [bp+6]
    mov [start_y],bx

    mov cx,9 ;ROW COUNT

        mov dx,9 ;COLUMN COUNT
        mov bx,45 ;DIFFERENCE BETWEEN TWO BOXES

        lab:
            push word  [start_y]
            push word  [start_x]
            
            call DRAW_BOX_NOTES
            add [start_x],bx
            dec dx
            jnz lab

            mov dx,9 ; RESET COLUMN COUNT

            push bx
            mov bx,[bp+4] ; RESET X
            mov [start_x], bx ;RESET X IN START_X
            pop bx

            add [start_y],bx ;INCREMENT Y

            loop lab
    
    popA
    mov sp,bp
    pop bp

RET 4






start:
    call clear_screen
    
    mov ax, 0x12
    int 10h
   
    push word 10 ;y
    push word 10 ;x
    call DRAW__ALL_BOX_NOTES


mov ax, 0x4c00
int 21h