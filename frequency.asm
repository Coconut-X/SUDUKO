global frequency

%include "drawNotes.asm"

;first index is the available number of ones in sudoku
frequency: dw   9,  0,  2,  1,  5,  6,  3,  8,  4



;DISPLAY 1-9 BELOW THE GRID FOR FREQUENCY


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


DRAW_FREQUENCY:

    PUSH BP
    MOV BP, SP
    PUSHA

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