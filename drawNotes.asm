[org 0x0100]

%include "bitMaps.asm"

DRAW_BITMAP:                                                ;DRAWS A SINGLE BITMAP
    push bp
    mov bp,sp
    pushA
    
    mov si, [bp+4]                                          ;SI = BITMAP TO BE DRAWN

    mov ah, 0x0c ;0x0c                                      ;TELETYPE FUNCTION
    mov bh, 0
    mov cx, [bp+6]                                          ;X COORDINATE
    mov dx, [bp+8]                                          ;Y COORDINATE
    dec dx                                                 ;Y COORDINATE - 1, BECAUSE WE WILL INC DX IN NEXT ROW
    mov al, 12                                             ;RED COLOR
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

RET 6




; DRAW_BITMAP:                                                ;DRAWS A SINGLE BITMAP
;     push bp
;     mov bp,sp
;     pushA
    
;     mov si, [bp+4]                                          ;SI = BITMAP TO BE DRAWN
;     dec si                                                  ;DECREMENT SI BECAUSE WE WILL INC SI IN NEXT ROW

;     mov ah, 0x0c ;0x0c                                      ;TELETYPE FUNCTION
;     mov bh, 0
;     mov cx, [bp+6]                                          ;X COORDINATE
;     mov dx, [bp+8]                                          ;Y COORDINATE
;     dec dx                                                  ;Y COORDINATE - 1, BECAUSE WE WILL INC DX IN NEXT ROW
;     mov al, 12                                              ;RED COLOR
;     nextRow:
;         inc dx                                              ;BRINGS TO FIRST ROW WHEN RUNS FIRST TIME
;         inc si                                              ;BRINGS TO FIRST ROW WHEN RUNS FIRST TIME

;         mov cx, [bp + 6]                                    ;X COORDINATE reset
;         cmp byte[si], 1010101b                              ;EXIT IF THE END OF THE BITMAP
;         jz exitDrawBitmap

;         CurrentRow:
;             shl byte [si], 1
;             jnc skipPrint
           
            
;             int 0x10

;             skipPrint:
                
;                 inc cx
;                 cmp byte [si], 0                                ;IF THE END OF THE ROW
;                 jz nextRow
;         jmp CurrentRow

;     exitDrawBitmap:
;         popA
;         mov sp,bp
;         pop bp

; RET 6



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
   
    xor si,si                                               ;OFFSET FOR NOTES1
    xor di,di                                               ;TO STORE THE NUMBER AT CURRENT INDEX

    mov bx,10                                               ;DIFFERENCE BETWEEN X COORDINATES FROM LEFT OF ONE NUMBER TO LEFT OF THE NUMBER NEXT TO IT, SAME FOR Y

        mov cx,3                                            ;ROW COUNT

            mov dx,3                                        ;COLUMN COUNT
        PrintRow:
            push word  [start_y]
            push word  [start_x]

            mov si, [currentNoteIndexPrint]
            mov di,[notes1+si]                              ;GET THE NUMBER AT CURRENT INDEX

            shl di,1                                        ;MULTIPLY BY 2 TO GET THE OFFSET
            mov si, [bitMaps_Small+di]                      ;GET THE BITMAP OF THE NUMBER
        
            push si 
            inc word [currentNoteIndexPrint]                ;INCREMENT INDEX
            inc word [currentNoteIndexPrint]                ;INCREMENT INDEX, TWICE BECAUSE EACH NUMBER IS 2 BYTES
            call DRAW_BITMAP
      
            add [start_x],bx

            dec dx
            jnz PrintRow
            mov dx,3                                        ;RESET COLUMN COUNT

            push bx
            mov bx,[bp+4]                                   ;RESET X
            mov [start_x], bx                               ;RESET X IN START_X
            pop bx

            add [start_y],bx                                ;INCREMENT Y 

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

    xor si,si                                               ;OFFSET FOR NOTES1
    xor di,di                                               ;TO STORE THE NUMBER AT CURRENT INDEX

    pushA

    mov bx, [bp+4]
    mov  [start_x], bx
    mov bx, [bp+6]
    mov [start_y],bx

    mov cx,9                                                ;ROW COUNT OF EACH BOX

        mov dx,9                                            ;COLUMN COUNT
        mov bx,45                                           ;DIFFERENCE BETWEEN TWO BOXES

        lab:
            push word  [start_y]
            push word  [start_x]
            
            call DRAW_BOX_NOTES
            add [start_x],bx
            dec dx
            jnz lab

            mov dx,9                                        ;RESET COLUMN COUNT

            push bx
            mov bx,[bp+4]                                   ;RESET X
            mov [start_x], bx                               ;RESET X IN START_X
            pop bx

            add [start_y],bx                                ;INCREMENT Y

            loop lab
    
    popA
    mov sp,bp
    pop bp

    mov word [currentNoteIndexPrint],0                      ;RESET INDEX

RET 4


DRAW_BITMAP_LARGE:

    push bp
    mov bp,sp
    pushA
    
    mov si, [bp+4]                                          ;SI = BITMAP TO BE DRAWN

    mov ah, 0x0c ;0x0c                                      ;TELETYPE FUNCTION
    mov bh, 0
    mov cx, [bp+6]                                          ;X COORDINATE
    mov dx, [bp+8]                                          ;Y COORDINATE
    dec dx                                                  ;Y COORDINATE - 1, BECAUSE WE WILL INC DX IN NEXT ROW
    mov al, 12                                              ;RED COLOR
    Next_Row:
        inc dx
        mov di, 1
        mov cx, [bp + 6]
        Current_Row:
            cmp byte[si], 2
            jz exitDraw_Bitmap
            cmp byte[si], 1
            jnz skip_Print
            int 10h
            skip_Print:
                inc cx
                inc di
                inc si
                cmp di, 26
            jz Next_Row
        jmp Current_Row

    exitDraw_Bitmap:
        popA
        mov sp,bp
        pop bp

RET 6


DRAW_SUDOKU_ARRAY:

    push bp
    mov bp,sp
    pushA

    push word [start_sudoku_x]
    push word [start_sudoku_y]

    mov bx, [bp+4]
    mov [start_sudoku_x],bx
    mov bx, [bp+6]
    mov [start_sudoku_y],bx

    xor si,si                                               ;OFFSET FOR SUDOKU
    xor di,di                                               ;TO STORE THE NUMBER AT CURRENT INDEX

    mov bx, 45                                              ;DIFFERENCE BETWEEN TWO BOXES
    mov cx,9                                                ;ROW COUNT
        mov dx,9                                            ;COLUMN COUNT

        loop_Print_Sudoku_Row:
            push word [start_sudoku_y]
            push word [start_sudoku_x]

            mov si, [currentSudokuIndexPrint]
            mov di,[sudokuArray+si]                         ;GET THE NUMBER AT CURRENT INDEX
            shl di,1                                        ;MULTIPLY BY 2 TO GET THE OFFSET
            mov si, [bitmaps_large_array+di]                ;GET THE BITMAP OF THE NUMBER

            push si
            inc word [currentSudokuIndexPrint]              ;INCREMENT INDEX
            inc word [currentSudokuIndexPrint]              ;INCREMENT INDEX, TWICE BECAUSE EACH NUMBER IS 2 BYTES
            call DRAW_BITMAP_LARGE

            add [start_sudoku_x],bx
            dec dx
            jnz loop_Print_Sudoku_Row

            mov dx,9                                        ;RESET COLUMN COUNT
            push bx
            mov bx,[bp+4]                                   ;RESET X
            mov [start_sudoku_x], bx                        ;RESET X IN START_X
            pop bx

            add [start_sudoku_y],bx                         ;INCREMENT Y

            loop loop_Print_Sudoku_Row

    pop word [start_sudoku_x]
    pop word [start_sudoku_y]

    popA
    mov sp,bp
    pop bp

RET 4
