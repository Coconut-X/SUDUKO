[org 0x100]
;jmp a
JMP START
%include "bitMaps.asm"
;%include "randomNumber.asm"

DISPLAY_FOUND:
    PUSH BP
    MOV BP,SP
    PUSHA

    MOV AX, 0XB800
    MOV ES,AX
    MOV DI, 220

    MOV AH, 0EH
    MOV AL, 'Y'
    MOV [ES:DI], AX

    POPA
    MOV SP,BP
    POP BP

    jmp exit
RET

DISPLAY_NOT_FOUND:
    PUSH BP
    MOV BP,SP
    PUSHA

    MOV AX, 0XB800
    MOV ES,AX
    MOV DI, 220

    MOV AH, 0EH
    MOV AL, 'N'
    MOV [ES:DI], AX

    

    POPA
    MOV SP,BP
    POP BP

    jmp exit
RET



SUDOKU_BOARD:
    DW 0,0,0,0,0,0,0,0,0,
    DW 0,0,0,0,0,0,0,0,0,
    DW 0,0,0,0,0,0,0,0,0,
    DW 0,0,0,0,0,0,0,0,0,
    DW 0,0,0,0,0,0,0,0,0,
    DW 0,0,0,0,0,0,0,0,0,
    DW 0,0,0,0,0,0,0,0,0,
    DW 0,0,0,0,0,0,0,0,0,
    DW 0,0,0,0,0,0,0,0,0, 10 ; 10 is the end of the board

randNum: dw 4


SET_VALUE:
    PUSH BP
    MOV BP, SP
    PUSHA 

    MOV AX, [BP+4]                  ; GET ROW
    MOV BX, 9
    MUL BX                          ; ANS IN AX
    ADD AX, [BP+6]                  ; ADD COLUMN
    SHL AX, 1                       ; MULTIPLY BY 2
    MOV SI,AX                       ; SI = OFFSET
    MOV BX, [BP+8]                  ; GET VALUE
    MOV [SUDOKU_BOARD+SI], BX       ; SET VALUE

    POPA
    MOV SP, BP
    POP BP
RET 6

FOUND: DB 0

FOUND_EXIT:
    MOV BYTE [FOUND], 1
    POPA
    MOV SP, BP
    POP BP
RET 6

IS_VALID_NUMBER_FOR_CURRENT_CELL:
    PUSH BP
    MOV BP, SP
    PUSHA

    MOV AX, [BP+4]                  ; GET ROW
    MOV BX, 9
    MUL BX                          ; ANS IN AX
    ;ADD AX, [BP+6]                  ; ADD COLUMN , by index
    SHL AX, 1                       ; MULTIPLY BY 2
    MOV SI,AX                       ; SI = OFFSET
    MOV BX, [BP+8]                  ; GET VALUE (NOT INSERTED YET)


    

    ;CHECK THAT ROW
    MOV CX, 9
    MOV DI, SI
    MOV DX, 0
    ROW_LOOP:
        CMP DX, 0
        JNE ROW_LOOP_END
        CMP [SUDOKU_BOARD+DI], BX
        ;JE ROW_LOOP_END
        JE FOUND_EXIT
        ADD DI, 2
        LOOP ROW_LOOP
    ROW_LOOP_END:

    ; CHECK THAT COLUMN
    MOV CX, 9
    MOV DI, [BP+6]
    SHL DI, 1
    MOV DX, 0
    COLUMN_LOOP:
        CMP DX, 0
        JNE COLUMN_LOOP_END
        CMP [SUDOKU_BOARD+DI], BX
        ;JE COLUMN_LOOP_END
        JE FOUND_EXIT
        ADD DI, 18
        LOOP COLUMN_LOOP
    COLUMN_LOOP_END:

    

    ; CHECK 3X3

    MOV AX, [BP + 4]
    MOV CX, 3
    DIV CL
    
    XOR AH, AH
    MOV CL, 3 * 9
    MUL CL
    MOV SI, AX

    MOV AX, [BP + 6]
    MOV CL, 3
    DIV CL

    XOR AH, AH
    MOV CL, 3
    MUL CL
    ADD SI, AX
    SHL SI, 1

    MOV AX, 3
    MOV CX, 9

    MOV BX,SUDOKU_BOARD
    MOV DX, [BP+8]

check_valid_subGrid:
    CMP [BX + SI], DL
    JE near FOUND_EXIT

    DEC AX
    ;SUB AX,2
    JNZ next_index_subGrid

    MOV AX, 3
    ADD SI, 12

next_index_subGrid:
    ;INC SI
    ADD SI, 2
    LOOP check_valid_subGrid
   
    ;;;;;;;;;;;;;;;

    POPA
    MOV SP, BP
    POP BP
RET 6
    


seed:   dw 0



GenRandNum:

    ; [BP + 6] LOWER_BOUND
    ; [BP + 4] UPPER_BOUND
    PUSH BP
    MOV BP, SP

    PUSH AX
    PUSH BX
    PUSH DX

    MOV BX, 9
    SUB BX, 1

    OR BX, BX
    JZ read_tsc
    
    INC BX

read_tsc:
    RDTSC

    ADD AX, [seed]
    INC word [seed]

    XOR DX, DX
    
    DIV BX

    ADD DX, 1
    MOV [randNum], DX

     POP DX
    POP BX
    POP AX

    MOV SP, BP
    POP BP

RET 




printnumEdited:
    PUSH BP
    MOV BP,SP
    pushA
    
        mov ax, [BP+4]

        add al, 48
        MOV AH, 0EH
        MOV DI, [BP+6]
        MOV [ES:DI], AX
        ; mov bh, 0
        ; mov cx, 1
        ; mov ah, 0Eh
        ; int 0x10


    popA
    MOV SP,BP
    POP BP
ret 4




PRINT_FIRST_ROW:
    PUSH BP 
    MOV BP,SP
    PUSHA

    MOV AX, 0XB800
    MOV ES,AX
    MOV DI, 220

    MOV CX,9
    MOV SI,0
    MOV BX,[BP+4]
    AB:

    PUSH DI
    PUSH WORD [BX+SI]
    CALL printnumEdited
    ADD SI,2
    ADD DI,4

    LOOP AB

    POPA
    MOV SP,BP
    POP BP
RET

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


DRAW_SUDOKU_ARRAY:

    ; MOV AX, 0XB800
    ; MOV ES, AX
    ; MOV AH, 0EH
    ; MOV AL,'A'
    ; MOV DI,10
    ; MOV [ES:DI], AX
    ; RET 4

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

        ; inc word [currentSudokuIndexPrint]              ;INCREMENT INDEX
        ; inc word [currentSudokuIndexPrint]              ;INCREMENT INDEX, TWICE BECAUSE EACH NUMBER IS 2 BYTES

        loop_Print_Sudoku_Row:

            mov si, [currentSudokuIndexPrint]
            mov di,[SUDOKU_BOARD+si]                         ;GET THE NUMBER AT CURRENT INDEX
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

    pop word [start_sudoku_x]
    pop word [start_sudoku_y]
    popA
    mov sp,bp
    pop bp

RET 4




; VALUES: DB 1,2,3,4,5,6,7,8,9 
; VALUES_SIZE: DB 9





FILL_FIRST_ROW:
    PUSH BP
    MOV BP,SP
    PUSHA

    MOV CX,9
    MOV DI,SUDOKU_BOARD
    MOV SI,0

    GET_ONE_NUM:

        GET_RAN:
            CALL GenRandNum
            ;check if it is present in first row of SUDOKU_BOARD
            MOV AX, [randNum]
            ;CMP WORD [randNum], [DI]
            CMP AX, [DI+0]
            JE GET_RAN

            CMP AX, [DI+2]
            JE GET_RAN

            CMP AX, [DI+4]
            JE GET_RAN

            CMP AX, [DI+6]
            JE GET_RAN

            CMP AX, [DI+8]
            JE GET_RAN

            CMP AX, [DI+10]
            JE GET_RAN

            CMP AX, [DI+12]
            JE GET_RAN

            CMP AX, [DI+14]
            JE GET_RAN

            CMP AX, [DI+16]
            JE GET_RAN

            MOV WORD [SUDOKU_BOARD+SI], AX
            ADD SI,2



    LOOP GET_ONE_NUM


    POPA
    MOV SP,BP
    POP BP

RET

sp_val: dw 0
bp_val: dw 0

y_greater_than_8:
    ;INC AX
    ADD AX, 2 ; GOTO NEXT ROW
    MOV BX, 0 ; RESET COL COUNT
    ; PUSH WORD 18
    ; PUSH WORD 18
    ; CALL DRAW_SUDOKU_ARRAY
    
    RET


FINISH_BOARD:
    MOV BP,[bp_val]
    MOV SP, [sp_val]
    JMP done


;rec_curr:


GENERATE_BOARD:
    PUSH BP
    MOV SP,BP
    PUSHA

    PUSH WORD 18
    PUSH WORD 18
    CALL DRAW_SUDOKU_ARRAY
    ;;;;;;;;;;;;;;;;;;;;;

    ; MOV SI,SUDOKU_BOARD
    ; ;ADD SI, 18

    ; PUSH SI
    ; CALL PRINT_FIRST_ROW

    ;;;;;;;;;;;;;

    MOV AX, [BP+4]          ; ROW
    MOV BX, [BP+6]          ; COL

    CMP BX, 8 ; IF END OF COL
    JA y_greater_than_8


    CMP word [SUDOKU_BOARD+162], 0
    JNZ FINISH_BOARD




    MOV CX ,0               ; CURRENT NUM TO BE TESTED
    try_num:
        INC CX

        CMP CX, 10
        JZ ret_curr

        PUSH CX
        PUSH BX
        PUSH AX
        MOV BYTE [FOUND],0

        CALL IS_VALID_NUMBER_FOR_CURRENT_CELL

        CMP BYTE [FOUND], 1
        jE try_num ;IF ALREADY PRESENT TRY NEXT NUMBER

        ;ELSE SET THE NUMBER AND CALL GENERATE_BOARD

        PUSH CX             ;PUSH VALUE
        PUSH BX             ;PUSH COL
        PUSH AX             ;PUSH ROW

        CALL SET_VALUE

        ADD BX, 1           ;INCREMENT COL
        PUSH BX             ; PUSH COL
        PUSH AX             ; PUSH ROW

        CALL GENERATE_BOARD
        SUB BX,1

        JMP FINISH_BOARD  

        ret_curr:
            POPA
            MOV SP,BP
            POP BP
            RET 4  




START:

    MOV WORD [sp_val], SP ;STORE CURRENT SP TO EXIT AFTER ONE SOLUTION FOUND
    MOV WORD [bp_val], BP ;STORE CURRENT BP TO EXIT AFTER ONE SOLUTION FOUND
    
    MOV AX, 0X12
    INT 10H

    ; PUSH WORD 18
    ; PUSH WORD 18
    ; CALL DRAW_SUDOKU_ARRAY

    CALL FILL_FIRST_ROW

    PUSH WORD 0 ;COL
    PUSH WORD 1 ;ROW
    CALL GENERATE_BOARD


    done:

    ; MOV SI,SUDOKU_BOARD
    ; ;ADD SI, 18

    ; PUSH SI
    ; CALL PRINT_FIRST_ROW

   

    PUSH WORD 18
    PUSH WORD 18
    CALL DRAW_SUDOKU_ARRAY


    ; PUSH WORD 2 ; VALUE
    ; PUSH WORD 3 ; COLUMN
    ; PUSH WORD 1 ; ROW
    ; CALL IS_VALID_NUMBER_FOR_CURRENT_CELL
    ; CMP BYTE [FOUND], 1
    ; JE DISPLAY_FOUND
    ; ;jne DISPLAY_NOT_FOUND
    ; call DISPLAY_NOT_FOUND

    ;CALL DISPLAY_FOUND
    ;CALL DISPLAY_NOT_FOUND

    exit:

        AZ:
            JMP AZ

    MOV AX, 0X4C00
    INT 21H