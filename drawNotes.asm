
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
    mov al, 8                                             ;RED COLOR
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

    ; xor si,si                                               
    ; xor di,di                                               ;TO STORE THE NUMBER AT CURRENT INDEX

DRAW__ALL_BOX_NOTES:

    push bp
    mov bp,sp
    pushA

    mov bx, [bp+4]
    mov  [start_x], bx
    mov bx, [bp+6]
    mov [start_y],bx
    mov si,sudokuArray

    push word  [start_y]
    push word  [start_x]

    mov cx,9                                                ;ROW COUNT OF EACH BOX

        mov dx,9                                            ;COLUMN COUNT
        mov bx,45                                           ;DIFFERENCE BETWEEN TWO BOXES

        lab:

            
            cmp word [si], 0
            jnz Skip_
            push word  [start_y]
            push word  [start_x]

            call DRAW_BOX_NOTES
            
            Skip_:
            add [start_x],bx
            add si,2
            
            dec dx
            jnz lab

            mov dx,9                                        ;RESET COLUMN COUNT
            push bx
            mov bx,[bp+4]                                   ;RESET X
            mov [start_x], bx                               ;RESET X IN START_X
            pop bx
            add [start_y],bx                                ;INCREMENT Y

            loop lab
    
    pop word [start_x]
    pop word [start_y]

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
    mov al, 0x2                                              ;pink COLOR
    Next_Row:
        inc dx
        mov di, 1
        mov cx, [bp + 6]
        Current_Row:
            cmp byte[si], 2
            jz exitDraw_Bitmap
            cmp byte[si], 1
            jnz skip_Print
            mov al, 0x2 
            int 10h
            skip_Print:
                inc cx
                inc di
                inc si
                ; mov al,0x0
                ; int 10h
                cmp di, 26
            jz Next_Row
        jmp Current_Row

    exitDraw_Bitmap:
        popA
        mov sp,bp
        pop bp

RET 6

COUNTER: DB 0

DRAW_PINK:
    PUSH BP
    mov bp,sp
    PUSHA
    MOV BH,0
    MOV CX,[BP+4] ;X
    MOV DX,[BP+6] ;Y
    DEC DX

    mov byte [COUNTER],0
    MOV AH,0X0C
    NEXT_R:
        INC DX
        MOV DI,1
        MOV CX,[BP+4] ; reset X
        INC BYTE [COUNTER]
        CMP BYTE [COUNTER],46
        JZ FINISH
        CR:
            
            MOV AL,0X1
            INT 10h
            INC CX
            INC DI
            INC SI
            
            CMP DI,46
            JZ NEXT_R
        JMP CR
    
    FINISH:
        popA
        mov sp,bp
        pop bp

        MOV BYTE [COUNTER],0 ;RESET COUNTER

RET 4


pink_x: dw 9
pink_y: dw 9


DRAW_ALL_PINK_BOXES:
    PUSH BP
    MOV BP,SP
    PUSHA

    MOV SI,sudokuArray
    MOV CX,9

    nextPinkBoxRow:
        PUSH CX
        MOV CX,9
        
        currentPinkBoxRow:
            CMP WORD [SI],11 ;11 IS END OF SUDOKU
            JZ end_pink_boxes
            CMP WORD [SI],0
            JZ SKIP_
            PUSH WORD [pink_y]
            PUSH WORD [pink_x]
            CALL DRAW_PINK

            SKIP_:
                ADD WORD [pink_x],45
                ADD SI,2
                LOOP currentPinkBoxRow

                POP CX
                ADD WORD [pink_y],45
                MOV WORD [pink_x],9
                LOOP nextPinkBoxRow

    end_pink_boxes:

    MOV WORD [pink_x],9
    MOV WORD [pink_y],9
    POPA
    MOV SP,BP
    POP BP

RET


DRAW_SUDOKU_ARRAY:

    push bp
    mov bp,sp
    pushA

    push word [start_sudoku_x]
    push word [start_sudoku_y]
    PUSH WORD [currentNoteIndexPrint]

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

            mov si, [currentSudokuIndexPrint]
            mov di,[sudokuArray+si]                         ;GET THE NUMBER AT CURRENT INDEX
            shl di,1                                        ;MULTIPLY BY 2 TO GET THE OFFSET
            mov si, [bitmaps_large_array+di]                ;GET THE BITMAP OF THE NUMBER

            CMP DI,0
            JE skip_num

            push word [start_sudoku_y]
            push word [start_sudoku_x]
            push si


           
            call DRAW_BITMAP_LARGE

            skip_num:
            inc word [currentSudokuIndexPrint]              ;INCREMENT INDEX
            inc word [currentSudokuIndexPrint]              ;INCREMENT INDEX, TWICE BECAUSE EACH NUMBER IS 2 BYTES

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

    POP WORD [currentSudokuIndexPrint]
    pop word [start_sudoku_x]
    pop word [start_sudoku_y]

    ;MOV WORD [start_sudoku_x],18
    ;MOV WORD [start_sudoku_y],18

    popA
    mov sp,bp
    pop bp

RET 4

DRAW_PEACH_BOX:
    PUSH BP
    mov bp,sp
    PUSHA
    MOV BH,0
    MOV CX,[BP+4] ;X
    MOV DX,[BP+6] ;Y
    DEC DX

    mov byte [COUNTER],0
    MOV AH,0X0C
    next_R:
        INC DX
        MOV DI,1
        MOV CX,[BP+4] ; reset X
        INC BYTE [COUNTER]
        CMP BYTE [COUNTER],46
        JZ end_peach_box
        current_R:
            
            MOV AL,0X0
            INT 10h
            INC CX
            INC DI
            INC SI
            
            CMP DI,46
            JZ next_R
        JMP current_R
    
    end_peach_box:
        popA
        mov sp,bp
        pop bp

        MOV BYTE [COUNTER],0 ;RESET COUNTER

RET 4