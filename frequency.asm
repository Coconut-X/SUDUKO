global frequency

%include "drawNotes.asm"

;first index is the available number of ones in sudoku
frequency: dw   9,9,9,9,9,9,9,9,9


;DISPLAY 1-9 BELOW THE GRID FOR FREQUENCY


;DECREMENT FREQUENCY OF THE GIVEN NUMBER

update_Frequency:
    PUSH BP
    MOV BP, SP
    PUSHA

    MOV AX,[BP+4]
    DEC AX
    MOV SI,AX
    SHL SI,1
    DEC WORD [frequency+SI]

    CALL DRAW_FREQUENCY

    POPA
    MOV SP, BP
    POP BP

RET 2




SET_FREQUENCY:
    ;LOOP THROUGH sudokuArray, pick a number, increment the frequency array at corresponding index
    ;frequency array is 0 indexed, so 1 will be at index 0, 2 at index 1, 3 at index 2 and so on
    ;if number picked is zero, skip it

    PUSH BP
    MOV BP, SP
    PUSHA

    MOV DI, 0   
    MOV CX, 81

    Set_Frequency_Loop:
        MOV AX, [sudokuArray+DI]
        CMP AX, 0
        JE Skip_Frequency
        DEC AX
        MOV SI,AX
        SHL SI,1
        DEC WORD [frequency+SI]
        Skip_Frequency:
        ADD DI, 2
        LOOP Set_Frequency_Loop

    POPA
    MOV SP, BP
    POP BP

RET
        




DRAW_AVAILABLE_NUMBERS:

    PUSH BP
    MOV BP, SP
    PUSHA

    MOV BX,18
    MOV DI,2
    MOV CX,10
    
    Draw_Available_Loop:
        PUSH WORD 430
        PUSH BX
        MOV SI,[bitmaps_large_array+DI]
        PUSH SI
        CALL DRAW_BITMAP_LARGE
        ADD BX,45
        ADD DI,2
        LOOP Draw_Available_Loop

    POPA
    MOV SP,BP
    POP BP

    CALL DRAW_FREQUENCY

RET


CLEAR_ROW:
   PUSHA
    PUSH ES

    PUSH word 0xA000
    POP ES

    MOV AL, 0x02
    MOV DX, 0x3C4
    OUT DX, AL

    MOV AL, 0x0F  ;this is the color of the background
    MOV DX, 0x3C5;this is the port to write to
    OUT DX, AL

    MOV DI, 36800
    XOR AX, AX
    ;MOV BX, 100

    clear_rowl:
        MOV CX, 800
        REP STOSW

        ;ADD DI, 28
        ;DEC BX
        JNZ clear_rowl
    
    POP ES
    POPA
RET

DRAW_FREQUENCY:

    PUSH BP
    MOV BP, SP
    PUSHA

    CALL CLEAR_ROW

    MOV BX, 27
    MOV CX, 10
    MOV DI, 0

    Draw_Frequency_Loop:
        PUSH WORD 460
        PUSH BX

        MOV SI,[frequency+DI]
        SHL SI,1
        MOV SI,[bitMaps_Freq+SI]
        PUSH SI

        ADD DI,2
        ADD BX, 45
        CALL DRAW_BITMAP

        LOOP Draw_Frequency_Loop


    POPA
    MOV SP, BP
    POP BP


RET