%include "sideScreen.asm"
%include"frequency.asm"
%include"sound.asm"


clear_screen:
    mov ah, 0x06                                    ; Scroll up function
    mov al, 0                                       ; Number of lines to scroll (0 = clear entire screen)
    mov bh, 0x0                                    ; Video page and attribute (07h = normal text)
    ;mov bh,01111111b
    mov cx, 0x0000                                  ; Upper-left corner of the screen (row 0, col 0)
    mov dx, 0xffff                                  ; Lower-right corner (row 24, col 79)
    int 0x10                                        ; Call BIOS interrupt 10h to clear the screen
RET                                                 ; Return from subroutine


clear_left_half_of_screen:
    PUSHA
    PUSH ES

    PUSH word 0xA000
    POP ES

    MOV AL, 0x02
    MOV DX, 0x3C4
    OUT DX, AL

    MOV AL, 0x0F
    MOV DX, 0x3C5
    OUT DX, AL

    XOR DI, DI
    XOR AX, AX
    MOV BX, 413

    clear_row:
        MOV CX, 26
        REP STOSW

        ADD DI, 28
        DEC BX
        JNZ clear_row

    POP ES
    POPA
    RET




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
    mov al, 0x2

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
RET 0


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
    mov al, 0x2                                          ;COLOR

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
    PUSHA    

    call DRAW_HORIZONTAL_GRID

    CALL DRAW_VERTICAL_GRID

    CALL DRAW_THICK_HORIZONTAL

    CALL DRAW_THICK_VERTICAL

    POPA
    MOV SP,BP
    POP BP

RET 



;///////////////////////////////////////////////////////////////

DRAW_THICK_VERTICAL:

    push word 7 
    push word 7
    push word 407
    call DRAW_VERTICAL_LINE

    push word 142 
    push word 7
    push word 407
    call DRAW_VERTICAL_LINE

    push word 277 
    push word 7
    push word 407
    call DRAW_VERTICAL_LINE

    push word 412
    push word 7
    push word 407
    call DRAW_VERTICAL_LINE



   
ret


DRAW_THICK_HORIZONTAL:

    push word 7 
    push word 7
    push word 407
    call DRAW_HORIZONTAL_LINE

    push word 7 
    push word 142
    push word 407
    call DRAW_HORIZONTAL_LINE

    push word 7 
    push word 277
    push word 407
    call DRAW_HORIZONTAL_LINE


    push word 7 
    push word 412
    push word 407
    call DRAW_HORIZONTAL_LINE


ret

DRAW_NOTES:

RET
;/////////////////////////////////////////////////////////////////


selected_y: dW 8
selected_x: dW 8



DRAW_RED_HOR_LINE:
    mov ah, 0x0c
    push bp
    mov bp, sp
    sub sp, 2                                           ;SPACE FOR COUNTER
    pushA

    mov si, [bp + 4]                                    ;COUNTER
    mov cx, [bp + 8]                                    ;X
    mov dx, [bp + 6]                                    ;Y
    mov bh, 0                                           ;PAGE NUMBER
    mov al, 0x4                                          ;COLOR

    loopDrawHorRedLine:
        int 10h
        inc cx                                          ;INCREMENT X AXIS
        dec si                                          ;DECREMENT COUNTER
    jnz loopDrawHorRedLine
    popA
    mov sp, bp
    pop bp
RET 6



DRAW_RED_VER_LINE:
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
    mov al, 0x4

    loopDrawVerRedLine:
        int 10h
        inc dx                                      ;INCREMENT Y AXIS
        dec si                                      ;DECREMENT COUNTER
    jnz loopDrawVerRedLine

    popA
    mov sp, bp
    pop bp
RET 6



DRAW_SELECTED_BOX_OUTLINE:
    PUSH BP
    MOV BP,SP
    PUSHA

    PUSH CS
    POP DS

    ;draw a 45x45 pixel box, just outline of pink color

    MOV BX,45

    ;top line MAKE IT THICK
    push word [selected_x]
    push word [selected_y]
    push word 45
    call DRAW_RED_HOR_LINE

    ADD WORD [selected_y],1
    PUSH WORD [selected_x]
    PUSH WORD [selected_y]
    PUSH WORD 45
    CALL DRAW_RED_HOR_LINE

    SUB WORD [selected_y],1


    ADD [selected_y],BX

    ;bottom line
    push word [selected_x]
    push word [selected_y]
    push word 45
    call DRAW_RED_HOR_LINE

    SUB WORD [selected_y],1
    PUSH WORD [selected_x]
    PUSH WORD [selected_y]
    PUSH WORD 45
    CALL DRAW_RED_HOR_LINE

    ADD WORD [selected_y],1

    SUB [selected_y],BX

    ;left line
    push word [selected_x]
    push word [selected_y]
    push word 45
    call DRAW_RED_VER_LINE

    ADD WORD [selected_x],1
    push word [selected_x]
    push word [selected_y]
    push word 45
    call DRAW_RED_VER_LINE

    SUB WORD [selected_x],1

    ;right line
    ADD WORD [selected_x],BX
    push word [selected_x]
    push word [selected_y]
    push word 45
    call DRAW_RED_VER_LINE

    SUB WORD [selected_x],1
    PUSH WORD [selected_x]
    PUSH WORD [selected_y]
    PUSH WORD 45
    CALL DRAW_RED_VER_LINE

    ADD WORD [selected_x],1
    SUB WORD [selected_x],BX


   

    POPA
    MOV SP,BP
    POP BP
RET


EDGE_DISP:
    CALL DISPLAY_ALL

    JMP FIN

old_kbisr: dW 0,0

UP:
    PUSH WORD [selected_y]
    PUSH WORD [selected_x]
    CALL DRAW_PEACH_BOX

    CMP WORD [selected_y], 8
    JLE EDGE_DISP
    SUB WORD [selected_y], BX 
    CALL DISPLAY_ALL
    JMP FIN

DOWN:
    PUSH WORD [selected_y]
    PUSH WORD [selected_x]
    CALL DRAW_PEACH_BOX

    CMP WORD [selected_y], 405+8-45 ;SUBTRACTING THE BOX SIZE
    JGE EDGE_DISP
    ADD WORD [selected_y], BX 
    CALL DISPLAY_ALL
    JMP FIN


RIGHT:
    PUSH WORD [selected_y]
    PUSH WORD [selected_x]
    CALL DRAW_PEACH_BOX

    CMP WORD [selected_x], 405+8-45
    JGE EDGE_DISP
    ADD WORD [selected_x], BX
    CALL DISPLAY_ALL
    JMP FIN

LEFT:
    PUSH WORD [selected_y]
    PUSH WORD [selected_x]
    CALL DRAW_PEACH_BOX

    CMP WORD [selected_x], 8
    JLE EDGE_DISP
    SUB WORD [selected_x], BX
    CALL DISPLAY_ALL
    JMP FIN

KEYBOARD_MOVEMENT:
    PUSHA
    MOV BX,45

    PUSH CS
    POP DS

    ;CALL DISPLAY_ALL

    IN AL, 60H

    CMP AL, 0X48
	JZ UP
	CMP AL, 0X4B
	JZ LEFT
	CMP AL, 0X50
	JZ DOWN
	CMP AL,0X4D
	JZ RIGHT

    FIN:

    ;CALL DRAW_SELECTED_BOX_OUTLINE
    PUSH DS
    POP DS

    POPA
    JMP FAR [CS:old_kbisr]

    IRET

DISPLAY_ALL:
    ;CALL clear_left_half_of_screen

    ; PUSH WORD [selected_y]
    ; PUSH WORD [selected_x]
    ; CALL DRAW_PEACH_BOX

    CALL movingAcrossBoardSound

    CALL DRAW_ALL_PINK_BOXES
    CALL DRAW_GRID
    ; PUSH WORD 18
    ; PUSH WORD 18
    ; CALL DRAW_SUDOKU_ARRAY
    push word 17
    push word 17
    call DRAW__ALL_BOX_NOTES
    CALL DRAW_AVAILABLE_NUMBERS
    CALL DRAW_SELECTED_BOX_OUTLINE
RET



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
    MOV [sudokuArray+SI], BX       ; SET VALUE

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
        CMP [sudokuArray+DI], BX
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
        CMP [sudokuArray+DI], BX
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

    MOV BX,sudokuArray
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





FILL_FIRST_ROW:
    PUSH BP
    MOV BP,SP
    PUSHA

    MOV CX,9
    MOV DI,sudokuArray
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

            MOV WORD [sudokuArray+SI], AX
            ADD SI,2

    LOOP GET_ONE_NUM


    POPA
    MOV SP,BP
    POP BP

RET

sp_val: dw 0
bp_val: dw 0



update_row:
    INC AX ; GOT TO NEXT ROW
    MOV BX, 0 ; RESET COLUMN
    CMP AX, 9
    JE finish
    jmp updated



finish:
    MOV BP, [bp_val]
    MOV SP, [sp_val]
    JMP done


GENERATE_BOARD:
    PUSH BP
    MOV BP,SP
    PUSHA

  
    MOV AX, [BP+4]          ; ROW
    MOV BX, [BP+6]          ; COLUMN
    CMP BX, 9               ; If the column CROSSED END, move to the next row
    JAE update_row
    updated:

 


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
   
    MOV CX, 0

    POPA
    MOV SP,BP
    POP BP
    RET 4

FOUND: DB 0



generateBoard:

    MOV WORD [sp_val], SP ;STORE CURRENT SP TO EXIT AFTER ONE SOLUTION FOUND
    MOV WORD [bp_val], BP ;STORE CURRENT BP TO EXIT AFTER ONE SOLUTION FOUND



    CALL FILL_FIRST_ROW

    PUSH WORD 0
    PUSH WORD 1
    CALL GENERATE_BOARD

    done:

ret
