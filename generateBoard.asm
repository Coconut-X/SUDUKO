
SUDOKU_BOARD:
    DW 0,0,0,0,0,0,0,0,0,
    DW 0,0,0,0,0,0,0,0,0,
    DW 0,0,0,0,0,0,0,0,0,
    DW 0,0,0,0,0,0,0,0,0,
    DW 0,0,0,0,0,0,0,0,0,
    DW 0,0,0,0,0,0,0,0,0,
    DW 0,0,0,0,0,0,0,0,0,
    DW 0,0,0,0,0,0,0,0,0,
    DW 0,0,0,0,0,0,0,0,0, ; 10 is the end of the board

randNum: dw 4

FOUND_EXIT:
    MOV BYTE [FOUND], 1
    POPA
    MOV SP, BP
    POP BP
RET 6


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
    JE  FOUND_EXIT

    DEC AX
    JNZ next_index_subGrid

    MOV AX, 3
    ADD SI, 12

next_index_subGrid:
    ADD SI, 2
    LOOP check_valid_subGrid

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

    MOV BX, 10
    SUB BX, 1

    OR BX, BX
    JNZ read_tsc
    
    INC BX

read_tsc:
    RDTSC

    ADD AX, [seed]
    MOV [seed], AX

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

printnum: push bp 
 mov bp, sp 
 push es 
 push ax 
 push bx 
 push cx 
 push dx 
 push di 
 mov ax, 0xb800 
 mov es, ax ; point es to video base 
 mov ax, [bp+4] ; load number in ax 
 mov bx, 10 ; use base 10 for division 
 mov cx, 0 ; initialize count of digits 
nextdigit: mov dx, 0 ; zero upper half of dividend 
 div bx ; divide by 10 
 add dl, 0x30 ; convert digit into ascii value 
 push dx ; save ascii value on stack 
 inc cx ; increment count of values 
 cmp ax, 0 ; is the quotient zero 
 jnz nextdigit ; if no divide it again 
 mov di, 3996 ; position cursor at start of line

 nextpos: pop dx ; remove a digit from the stack 
 mov dh, 0EH ; use normal attribute 
 mov [es:di], dx ; print char on screen 
 add di, 2 ; move to next screen location 
 loop nextpos ; repeat for all digits on stack
 pop di 
 pop dx 
 pop cx 
 pop bx 
 pop ax 
 pop es 
 pop bp 
 ret 2 


INDEX: DW 220




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



PRINT_FIRST_ROW:
    PUSH BP 
    MOV BP,SP
    PUSHA

    MOV AX, 0XB800
    MOV ES,AX
    MOV DI, [INDEX]
    ADD WORD [INDEX], 160

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
RET 2






DISPLAY_ALL_ROWS:
    PUSH BP
    MOV BP,SP
    PUSHA

    MOV WORD [INDEX],220

    MOV AX,0XB800
    MOV ES,AX

    MOV SI, SUDOKU_BOARD
    MOV CX, 9

    LP:
    PUSH SI
    CALL PRINT_FIRST_ROW
    ADD SI, 18
    LOOP LP

    POPA
    MOV SP,BP
    POP BP
RET




update_row:
    INC AX ; GOT TO NEXT ROW
    MOV BX, 0 ; RESET COLUMN
    CMP AX, 9
    JE finish

    ;CALL DISPLAY_ALL_ROWS
   
    MOV WORD [COUNT], 0
   ; JAE finish
    jmp updated



finish:
    MOV BP, [bp_val]
    MOV SP, [sp_val]
    JMP done

COUNT: DW 0

DEBUG_DISPLAY_BOARD:
    PUSH BP
    MOV BP, SP
    PUSHA

    MOV SI, SUDOKU_BOARD
    MOV CX, 9       ; Number of rows

    ROWLOOP:
        PUSH SI
        CALL PRINT_FIRST_ROW
        ADD SI, 18
        LOOP ROWLOOP

    POPA
    MOV SP, BP
    POP BP
RET


GENERATE_BOARD:
    PUSH BP
    MOV BP,SP
    PUSHA

    PUSH WORD [COUNT]
    ;PUSH WORD [BP+6]      ; COLUMN
    CALL printnum
    INC WORD [COUNT]
    MOV AX, [BP+4]          ; ROW
    MOV BX, [BP+6]          ; COLUMN
    CMP BX, 9               ; If the column CROSSED END, move to the next row
    JAE update_row
    updated:

    CALL DISPLAY_ALL_ROWS


    MOV CX,0
    try_num:
        INC CX
        CMP CX, 10
        JZ backtrack        ; IF ALL NUMBERS TRIED, BACKTRACK

        PUSH CX
        PUSH BX
        PUSH AX
        MOV BYTE [FOUND], 0
        CALL IS_VALID_NUMBER_FOR_CURRENT_CELL

        CMP BYTE [FOUND], 1
        JE try_num

        PUSH CX
        PUSH BX
        PUSH AX
        CALL SET_VALUE
        ;MOV CX,0

        ; CMP WORD [SUDOKU_BOARD+18*9-2], 0 ;if last cell is not zero, then we have found the solution
        ; JNE finish

        INC BX  ; MOVE TO NEXT COLUMN
        PUSH BX
        PUSH AX
        CALL GENERATE_BOARD
        DEC BX
        PUSH WORD 0
        PUSH BX 
        PUSH AX
        CALL SET_VALUE

        JMP try_num

    backtrack:
        ;SET CURRENT CX TO ZERO
        ;DEC BX
    DEC WORD  [COUNT]
    MOV CX, 0
    ;DEC BX
    ;MOV AX, [BP+4]          ; ROW
    ; PUSH WORD 0
    ; PUSH BX
    ; PUSH AX
    ; CALL SET_VALUE      ; SET PREVIOUS CELL TO ZERO

    e:
    POPA
    MOV SP,BP
    POP BP
    RET 4

FOUND: DB 0

endIT:
    POPA
    MOV SP,BP
    POP BP
    RET 4


FILL_SINGLE_ROW: ;FILLS ONE OF THE ROW PUSHED TO IT AND INSERTS IF VALID, THIS DOESNT GO TO NEXT ROW
    PUSH BP
    MOV BP,SP
    PUSHA

    ;;FUNCTION WORKS RECURSION, TEST FROM 1 TO 9, IF VALID INSERT, ELSE TRY NEXT NUMBER, IF NO NUMBER WORKS, BACKTRACK

        MOV CX,0

    ;get col and row

        MOV AX, [BP+4]          ; ROW
        MOV BX, [BP+6]          ; COLUMN

        ; PUSH BX 
        ; CALL printnum

        CMP BX,9
        JE done

       ; CALL DISPLAY_ALL_ROWS

    try_:
        INC CX
        CMP CX, 10
        JZ back             ; IF ALL NUMBERS TRIED, BACKTRACK
        
        MOV BYTE [FOUND], 0

        PUSH CX
        PUSH BX
        PUSH AX
        CALL IS_VALID_NUMBER_FOR_CURRENT_CELL

        CMP BYTE [FOUND], 1
        JE try_

        PUSH CX
        PUSH BX
        PUSH AX
        CALL SET_VALUE

        INC BX  ; MOVE TO NEXT COLUMN
        PUSH BX
        PUSH AX
        CALL FILL_SINGLE_ROW

    back:

    ;SET CURRENT CX TO ZERO
    MOV CX, 0
    
    DEC BX
    MOV AX, [BP+4]          ; ROW
   
    POPA
    MOV SP,BP
    POP BP
    RET 2



generateBoard:

    MOV WORD [sp_val], SP ;STORE CURRENT SP TO EXIT AFTER ONE SOLUTION FOUND
    MOV WORD [bp_val], BP ;STORE CURRENT BP TO EXIT AFTER ONE SOLUTION FOUND



    CALL FILL_FIRST_ROW

    PUSH WORD 0
    PUSH WORD 1
    CALL GENERATE_BOARD

    done:

ret



    

  



