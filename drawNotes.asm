[org 0x0100]

jmp start


%include "bitMaps.asm"




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

    mov bx, [bp+4]
    mov  [start_x], bx

    mov bx, [bp+6]
    mov [start_y],bx
   
   

    mov bx,10

    mov cx,3 ;ROW COUNT

        PrintRow:
            push word  [start_y]
            push word  [start_x]
            push one_bitmap
            call DRAW_BITMAP
            
            add [start_x],bx
            ;;;;;;;;;;;;;;;;;;;;;;;;;;
            push word  [start_y]
            push word  [start_x]
            push nine_bitmap
            call DRAW_BITMAP
            
            add [start_x],bx
            ;;;;;;;;;;;;;;;;;;;;;;;;;;
            push word  [start_y]
            push word  [start_x]

            push three_bitmap
            call DRAW_BITMAP
            
            ;;;;;;;;;;;;;;;;;;;;;;;
            mov bx,[bp+4]   ;reser x
            mov [start_x], bx

            add [start_y],bx


            loop PrintRow


pop word [start_y]
pop word [start_x]

popA
mov sp,bp
pop bp

RET




clear_screen:
    mov ah, 0x06       ; Scroll up function
    mov al, 0          ; Number of lines to scroll (0 = clear entire screen)
    mov bh, 0x07       ; Video page and attribute (07h = normal text)
    mov cx, 0x0000     ; Upper-left corner of the screen (row 0, col 0)
    mov dx, 0x184F     ; Lower-right corner (row 24, col 79)
    int 0x10           ; Call BIOS interrupt 10h to clear the screen
    ret                ; Return from subroutine




start:
    call clear_screen
    
    mov ax, 0x12
    int 10h
   
   
    push word 10 ;y
    push word 10 ;x
    ;push nine_bitmap

    ;call DRAW_BITMAP

    call DRAW_BOX_NOTES


mov ax, 0x4c00
int 21h
