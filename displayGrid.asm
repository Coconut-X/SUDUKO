%include "sideScreen.asm"
%include"frequency.asm"
%include"sound.asm"

game_over: db 'GAME OVER',0
game_won: db 'GAME WON',0
game_lost: db 'GAME LOST',0

selected_y: dW 8
selected_x: dW 8

selected_x_index: dw 0
selected_y_index: dw 0

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

    CALL DRAW_HORIZONTAL_GRID
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

RET

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

RET

DRAW_NOTES:

RET





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
    ;mov al, 0x15                                          ;COLOR
    MOV AL,0X4

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



    ADD [selected_y],BX

    ;bottom line
    push word [selected_x]
    push word [selected_y]
    push word 45
    call DRAW_RED_HOR_LINE



    SUB [selected_y],BX

    ;left line
    push word [selected_x]
    push word [selected_y]
    push word 45
    call DRAW_RED_VER_LINE



    ;right line
    ADD WORD [selected_x],BX
    push word [selected_x]
    push word [selected_y]
    push word 45
    call DRAW_RED_VER_LINE


    SUB WORD [selected_x],BX




    POPA
    MOV SP,BP
    POP BP
RET

;====================================================================================================================================================================

old_kbisr: dW 0,0

UP:
    CMP WORD [selected_y], 8
    JG ua

    MOV WORD [selected_y], 405+8-45
    MOV WORD [selected_y_index], 8
    JMP ue

    ua:
    SUB WORD [selected_y], BX
    SUB WORD [selected_y_index], 1 ;DECREMENTING THE INDEX

    ue:
    CALL DISPLAY_ALL
    JMP FIN

DOWN:

    CMP WORD [selected_y], 405+8-45 ;SUBTRACTING THE BOX SIZE
    JL da
    MOV WORD [selected_y], 8
    MOV WORD [selected_y_index], 0
    JMP de

    da:
    ADD WORD [selected_y], BX
    ADD WORD [selected_y_index], 1 ;INCREMENTING THE INDEX

    de:
    CALL DISPLAY_ALL
    JMP FIN

RIGHT:

    CMP WORD [selected_x], 405+8-45
    JL ra
    MOV WORD [selected_x], 8
    MOV WORD [selected_x_index], 0
    JMP re

    ra:
    ADD WORD [selected_x], BX
    ADD WORD [selected_x_index], 1 ;INCREMENTING THE INDEX

    re:
    CALL DISPLAY_ALL
    JMP FIN

LEFT:

    CMP WORD [selected_x], 8
    JG la
    MOV WORD [selected_x], 405+8-45
    MOV WORD [selected_x_index], 8
    JMP le

    la:
    SUB WORD [selected_x], BX
    SUB WORD [selected_x_index], 1 ;DECREMENTING THE INDEX

    le:
    CALL DISPLAY_ALL
    JMP FIN

numPressed: dw 0

X_INDEX: dw 0
Y_INDEX: dw 0

;====================================================================================================================================================================

D: dW 0
E: DW 0

SAVE_IN_STACK:
    PUSHA

    MOV AX,[selected_y_index] 
    MOV BX,9
    MUL BX

    ADD AX,[selected_x_index]

    MOV BX,18
    MUL BX
    ;AX CONTAINS THE INDEX OF FIRST NOTE OF THE SELECTED BOX
    MOV DI,AX

    ;NOW CALCULATE THE INDEX OF ENTERED NOTE IN THE SELECTED BOX
    MOV AX, [numPressed]
    SHL AX, 1
    SUB AX, 2
    ADD DI, AX

    ;DI CONTAINS THE INDEX OF THE ENTERED NOTE IN THE SELECTED BOX

    MOV AX,[stackTop]
    MOV SI,AX
    MOV WORD [stack+SI], DI
    MOV AX,[selected_x]
    MOV WORD [stack+SI+2], AX
    MOV AX,[selected_y]
    MOV WORD [stack+SI+4], AX
    ADD WORD [stackTop], 6

    ;MOV WORD 

    POPA
RET



CALCULATE_BYTE:
    PUSH BP
    MOV BP,SP
    PUSHA

    CMP BYTE [isPencil], 1
    JNE notPencil

    CALL SAVE_IN_STACK

    MOV AX,[selected_y_index] 
    MOV BX,9
    MUL BX

    ADD AX,[selected_x_index]

    MOV BX,18
    MUL BX
    ;AX CONTAINS THE INDEX OF FIRST NOTE OF THE SELECTED BOX
    MOV DI,AX
    ; ;PUSH DI
    ; ;CALL printnum
    ; ; MOV AH,00
    ; ; INT 16H
    ; ;==STORE IN STACK==
    ; MOV SI,[stackTop]
    ; MOV WORD [stack+SI], DI
    ; ;ADD WORD [stackTop], 2
    ; ;STORE SELECTED X AND Y INDEX IN STACK
    ; MOV AX,[selected_x]
    
    ; MOV WORD [stack+SI+2], AX
    ; MOV AX,[selected_y]
    ; MOV WORD [stack+SI-4], AX
    ; ADD WORD [stackTop], 6 ;
    ;================

    MOV AX, [numPressed]
    SHL AX, 1
    SUB AX, 2
    ADD DI, AX
    ADD AX, 2
    SHR AX, 1

    MOV WORD [notes1+DI], AX

    ;CALL correctSound
    ;DISPLAY NOTES
    PUSH WORD 17
    PUSH WORD 17
    CALL DRAW__ALL_BOX_NOTES


    JMP correct

    notPencil:

    MOV AX,[selected_y_index]
    MOV BX,9
    MUL BX

    ADD AX,[selected_x_index]
    SHL AX,1

    MOV DI,AX

    ;IF NUMBER IS NOT ZEROO JUMP TO SKIP
    MOV AX,[sudokuArray+DI]
    CMP AX,0
    JNE correct


    MOV AX,[numPressed]
    CMP [solutionArray+DI],AX

    JNE skip_insert_and_play_invalid_sound

    PUSH AX             ; UPDATE FREQUENCY
    CALL update_Frequency

    CALL correctSound

    PUSH word [numPressed]
    PUSH word [selected_x_index]
    PUSH word [selected_y_index]
    CALL SET_VALUE

    ADD WORD [currenScore],7

    PUSH WORD [selected_y]
    PUSH WORD [selected_x]
    CALL DRAW_PINK

    CALL DRAW_GRID

    CALL DRAW_SELECTED_BOX_OUTLINE

    CALL DISPLAY_SIDE_SCREEN

    PUSH WORD 18
    PUSH WORD 18
    CALL DRAW_SUDOKU_ARRAY
    ;CALL DISPLAY_ALL
    CALL DRAW_FREQUENCY
    DEC BYTE [countLeft]

    CMP BYTE [countLeft], 0
    JE GAME_WON

    CALL DISPLAY_SIDE_SCREEN
    jmp correct

    skip_insert_and_play_invalid_sound:
    CALL incorrectSound
    INC BYTE [mistakeCount]
    
    SUB WORD [currenScore], 5
    CALL DISPLAY_SIDE_SCREEN
    CMP BYTE [mistakeCount], 4
    JE GAME_LOST

    correct:

    POPA
    MOV SP, BP
    POP BP
RET

;====================================================================================================================================================================
GAME_WON:

    CALL clear_screen

    PUSH WORD 9
    PUSH WORD 35
    PUSH WORD 10
    PUSH WORD game_over
    CALL PRINT_STRING

    PUSH WORD 8
    PUSH WORD 35
    PUSH WORD 12
    PUSH WORD game_won
    CALL PRINT_STRING




RET

GAME_LOST:

    CALL clear_screen

    PUSH WORD 9
    PUSH WORD 35
    PUSH WORD 10
    PUSH WORD game_over
    CALL PRINT_STRING

    PUSH WORD 9
    PUSH WORD 35
    PUSH WORD 12
    PUSH WORD game_lost
    CALL PRINT_STRING

    ;JMP START

RET

;====================================================================================================================================================================

h_pressed:
    call buttonPressedSound
    CALL HINT
    JMP FIN

p_pressed:
    call buttonPressedSound
    CALL PENCIL
    JMP FIN

e_pressed:
    call buttonPressedSound
    CALL ERASER
    JMP FIN

enter_Pressed:
    CALL ENTERR
    CMP BYTE [countLeft], 0
    JE GAME_WON
    JMP FIN

u_pressed:
    CALL UNDO
    JMP FIN


UNDO:

    CMP WORD [stackTop], 0
    JE exit_UNDO

    ;=================================
    ;GET THE INDEX OF LAST ENTERED NOTE
    MOV DX,0
    MOV AX,[stackTop]
    MOV DI,AX
    MOV AX,[stack+DI-6]

    ;CALCULATE CELL INDEX of 9x9 SUDOKU BOARD
    ;AX CONTAINS THE INDEX OF LAST ENTERED NOTE, INDEX IS IN BYTES
    MOV BX,18
    DIV BX

    MOV DI,AX
    SHL DI,1

    ;CHECK IF NUMBER IN ARRAY IS NOT ZERO
    MOV AX,[sudokuArray+DI]
    CMP AX,0
    JE start_undo

    SUB WORD [stackTop], 6
    JMP exit_UNDO



    start_undo:
    ;==============================


    ;SUB WORD [stack]
    SUB WORD [stackTop], 2
    MOV AX,[stackTop]
    MOV DI,AX
    MOV AX,[stack+DI]
    PUSH AX ;------------

    SUB WORD [stackTop], 2
    MOV AX,[stackTop]
    MOV DI,AX
    MOV AX,[stack+DI]
    PUSH AX ;------------
    CALL DRAW_PEACH_BOX

    SUB WORD [stackTop], 2
    MOV AX,[stackTop]
    MOV DI,AX
    MOV AX,[stack+DI]
    MOV DI,AX
    MOV WORD [notes1+DI], 0
   

    PUSH WORD 17
    PUSH WORD 17
    CALL DRAW__ALL_BOX_NOTES

    CALL DRAW_GRID

    CALL DRAW_SELECTED_BOX_OUTLINE

    exit_UNDO:

RET

ENTERR:
    PUSHA

;;===F O R  H I N T ===
    CMP BYTE [hintCount], 0
    JE exit_Hint

    CMP BYTE [isHint], 1
    JNE exit_Hint


    MOV AX,[selected_y_index]
    MOV BX,9
    MUL BX

    ADD AX,[selected_x_index]
    SHL AX,1
    MOV DI,AX

    ;IF NUMBER IS NOT ZEROO JUMP TO END
    MOV AX,[sudokuArray+DI]
    CMP AX,0
    JNE exit_Hint


    ;ELSE DISPLAY THE NUMBER AT THE CURRENT SELECTED BOX

    MOV AX, [selected_y_index]
    MOV BX, 9
    MUL BX
    ADD AX, [selected_x_index]
    SHL AX, 1
    MOV SI, AX
    MOV AX, [solutionArray+SI]
    MOV [sudokuArray+SI], AX

    PUSH AX
    CALL update_Frequency

    DEC BYTE [countLeft]

    DEC BYTE [hintCount]
    SUB WORD [currenScore], 3
    CALL DISPLAY_SIDE_SCREEN
    CALL correctSound



    ;DRAW PINK BOX AT THE CURRENT SELECTED BOX
    PUSH WORD [selected_y]
    PUSH WORD [selected_x]
    CALL DRAW_PINK

    PUSH WORD 18
    PUSH WORD 18
    CALL DRAW_SUDOKU_ARRAY

    CALL DRAW_FREQUENCY

    CALL DRAW_GRID

    CALL DRAW_SELECTED_BOX_OUTLINE
    

exit_Hint:

;=== H I N T  E N D ===

;=== F O R  E R A S E R ===

    CMP BYTE [isEraser], 1
    JNE exit_Eraser


    ;GET CURR Y AND X, SET THE NOTES OF THAT BOX TO ZERO

    MOV AX,[selected_y_index]
    MOV BX,9
    MUL BX

    ADD AX,[selected_x_index]


    ;CHECK IF THE NUMBER IS NOT ZERO THEN DO NOTHING

    ;;;;;;;;;;;;;;;;;;;;;;;;;
    ;MOV DI,AX
    SHL AX,1
    MOV DI,AX

    CMP WORD [sudokuArray+DI],0
    JNE exit_Eraser

    SHR AX,1
    ;;;;;;;;;;;;;;;;;;;;;;;

    ;SHL AX,1

    ;NOW GET STARTING INDEX OF NOTE OF THAT BOX BY MULTIPLYING AX BY 18

    MOV BX,18
    MUL BX

    MOV DI,AX

    ;NOW SET THE NOTES OF THAT BOX TO ZERO

    MOV CX,9
    MOV SI,DI

    ERASE_NOTES:
        MOV WORD [notes1+SI],0
        ADD SI,2
    LOOP ERASE_NOTES

    ;DRAW PEACH BOX AT THE CURRENT SELECTED BOX

    ;CALL clear_screen

    PUSH WORD [selected_y]
    PUSH WORD [selected_x]
    CALL DRAW_PEACH_BOX

    push word 17
    push word 17
    call DRAW__ALL_BOX_NOTES

    CALL DRAW_GRID

    CALL DRAW_SELECTED_BOX_OUTLINE

    exit_Eraser:

    POPA

RET

;====================================================================================================================================================================

KEYBOARD_MOVEMENT:
    PUSHA
    MOV BX,45

    PUSH CS
    POP DS

    IN AL, 60H

    CMP AL, 35
    JZ h_pressed

    ;CMP WITH p
    CMP AL, 25
    JZ p_pressed

    ;CMP WITH e
    CMP AL, 18
    JZ e_pressed

    ;CMP WITH u
    CMP AL, 22
    JZ u_pressed

    ;CMO WITH ENTER
    CMP AL, 28
    JZ enter_Pressed



    CMP AL, 0X48
	JZ UP
	CMP AL, 0X4B
	JZ LEFT
	CMP AL, 0X50
	JZ DOWN
	CMP AL,0X4D
	JZ RIGHT

    CMP AL, 0
    JL FIN

    CMP AL, 10
    JG FIN

    SUB AL, 1
    MOV [numPressed], AL
    CALL CALCULATE_BYTE
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    FIN:

    PUSH DS
    POP DS

    POPA
    JMP FAR [CS:old_kbisr]

IRET

DISPLAY_ALL:
    CALL movingAcrossBoardSound
    CALL DRAW_GRID

    push word 17
    push word 17
    call DRAW__ALL_BOX_NOTES

    CALL DRAW_AVAILABLE_NUMBERS
    CALL DRAW_SELECTED_BOX_OUTLINE

    PUSH WORD 18
    PUSH WORD 18
    CALL DRAW_SUDOKU_ARRAY

RET

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
    CMP AX,0
    JL notSet
    MOV BX, 9
    MUL BX                          ; ANS IN AX
    ADD AX, [BP+6]                  ; ADD COLUMN
    CMP AX,0
    JL notSet
    SHL AX, 1                       ; MULTIPLY BY 2
    MOV SI,AX                       ; SI = OFFSET
    MOV BX, [BP+8]                  ; GET VALUE
    MOV [sudokuArray+SI], BX       ; SET VALUE


    notSet:
    POPA
    MOV SP, BP
    POP BP
RET 6

;========================================= B O A R D  G E N E R A T I O N ==============================================

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
randNum: dw 4

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


GenRandNumBig:
    ; [BP + 6] LOWER_BOUND
    ; [BP + 4] UPPER_BOUND
    PUSH BP
    MOV BP, SP

    PUSH AX
    PUSH BX
    PUSH DX

    MOV BX, 81
    SUB BX, 1

    OR BX, BX
    JNZ read_tsc_big

    INC BX

read_tsc_big:
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


REMOVE_N_NUMBERS:
    PUSH BP
    MOV BP,SP
    PUSHA

    MOV CX, [BP+4]

    MOV DI, 0
    REMOVE_NUMBERS:
        CALL GenRandNumBig
        MOV AX, [randNum]
        SHL AX, 1

        MOV DI, AX
        CMP WORD [sudokuArray+DI], 0
        JE REMOVE_NUMBERS               ; IF ALREADY REMOVED, TRY AGAIN

        MOV WORD [sudokuArray+DI], 0
        INC DI
    LOOP REMOVE_NUMBERS

    POPA
    MOV SP,BP
    POP BP

RET 2


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




DIVIDE_BY_ZERO:
    PUSHA

    CALL incorrectSound
    CALL incorrectSound
    CALL incorrectSound
    CALL incorrectSound

    MOV AL, 0x20
    OUT 0x20, AL

    POPA

IRET

COPY_TO_SOLUTION:
    PUSH BP
    MOV BP,SP
    PUSHA

    MOV SI,0
    MOV DI,0
    MOV CX,81
    COPY_LOOP:
        MOV AX, [sudokuArray+SI]
        MOV [solutionArray+DI], AX
        ADD SI, 2
        ADD DI, 2
    LOOP COPY_LOOP

    POPA
    MOV SP,BP
    POP BP
RET
