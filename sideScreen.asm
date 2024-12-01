
exit: db "EXIT"
mistakes: db "MISTAKES: ",0
undo: db "UNDO"
timer: db "TIMER:"
score:db "SCORE:   "
temp: db 0
level: db "DIFFICULTY: "
easy: db "EASY",0
medium: db "MEDIUM",0
hard: db "HARD",0
cst: db "CUSTOM",0

diff: db 2 ; 1 for easy, 2 for medium, 3 for hard, 4 for custom

scoreCount: db 0
mistakeCount: db 0


isHint: db 0
hintCount: DB 3
isPencil: db 0
isEraser: db 0

pencilColor: dW 0x2
eraserColor: dW 0x2
hintColor: dW 0x2

color: db 8

customSwitch: db 0

currenScore: dW 50

stack: times 81 dw 0
stackTop: dw 0

pencil: db 0x03, 0xff, 0xff, 0xc0, 0x07, 0xff, 0xff, 0xe0, 0x0e, 0x00, 0x00, 0x70, 0x1c, 0x00, 0x00, 0x38, 0x38, 0x00, 0x00, 0x1c, 0x70, 0x00, 0x1c, 0x0e, 0xe0, 0x00, 0x22, 0x07, 0xc0, 0x00, 0x71, 0x03, 0xc0, 0x00, 0xc8, 0x83, 0xc0, 0x01, 0x84, 0x43, 0xc0, 0x03, 0x02, 0x23, 0xc0, 0x06, 0x01, 0x23, 0xc0, 0x0c, 0x00, 0xa3, 0xc0, 0x18, 0x00, 0xc3, 0xc0, 0x30, 0x01, 0x83, 0xc0, 0x60, 0x03, 0x03, 0xc0, 0xc0, 0x06, 0x03, 0xc1, 0x80, 0x0c, 0x03, 0xc3, 0x00, 0x18, 0x03, 0xc2, 0x08, 0x30, 0x03, 0xc2, 0x10, 0x60, 0x03, 0xc3, 0x60, 0xc0, 0x03, 0xc3, 0xe1, 0x80, 0x03, 0xc3, 0xc3, 0x00, 0x03, 0xc3, 0xe6, 0x00, 0x03, 0xe3, 0xfc, 0x00, 0x07, 0x70, 0x00, 0x00, 0x0e, 0x38, 0x00, 0x00, 0x1c, 0x1c, 0x00, 0x00, 0x38, 0x0e, 0x00, 0x00, 0x70, 0x07, 0xff, 0xff, 0xe0, 0x03, 0xff, 0xff, 0xc0

eraser: db 0x03, 0xff, 0xff, 0xc0, 0x07, 0xff, 0xff, 0xe0, 0x0e, 0x00, 0x00, 0x70, 0x1c, 0x00, 0x00, 0x38, 0x38, 0x00, 0x38, 0x1c, 0x70, 0x00, 0x6c, 0x0e, 0xe0, 0x00, 0xc6, 0x07, 0xc0, 0x01, 0x83, 0x03, 0xc0, 0x03, 0x01, 0x83, 0xc0, 0x06, 0x00, 0xc3, 0xc0, 0x0c, 0x00, 0x63, 0xc0, 0x18, 0x00, 0x23, 0xc0, 0x30, 0x00, 0x63, 0xc0, 0x60, 0x00, 0xc3, 0xc0, 0xc0, 0x01, 0x83, 0xc1, 0xc0, 0x03, 0x03, 0xc3, 0x20, 0x06, 0x03, 0xc6, 0x10, 0x0c, 0x03, 0xc6, 0x08, 0x18, 0x03, 0xc3, 0x04, 0x30, 0x03, 0xc1, 0x82, 0x60, 0x03, 0xc0, 0xc1, 0xc0, 0x03, 0xc0, 0x61, 0x80, 0x03, 0xc0, 0x33, 0x00, 0x03, 0xc3, 0xff, 0xff, 0x03, 0xe0, 0x7f, 0xc0, 0x07, 0x70, 0x00, 0x00, 0x0e, 0x38, 0x00, 0x00, 0x1c, 0x1c, 0x00, 0x00, 0x38, 0x0e, 0x00, 0x00, 0x70, 0x07, 0xff, 0xff, 0xe0, 0x03, 0xff, 0xff, 0xc0 

hint: db 0x03, 0xff, 0xff, 0xc0, 0x07, 0xff, 0xff, 0xe0, 0x0e, 0x00, 0x00, 0x70, 0x1c, 0x07, 0xe0, 0x38, 0x38, 0x1f, 0xf8, 0x1c, 0x70, 0x30, 0x0c, 0x0e, 0xe0, 0x61, 0x86, 0x07, 0xc0, 0xc6, 0x03, 0x03, 0xc1, 0x8c, 0x01, 0x83, 0xc3, 0x09, 0x80, 0xc3, 0xc3, 0x0a, 0x80, 0xc3, 0xc3, 0x06, 0x80, 0xc3, 0xc3, 0x03, 0x00, 0xc3, 0xc3, 0x02, 0x40, 0xc3, 0xc3, 0x06, 0xe0, 0xc3, 0xc1, 0x82, 0xa1, 0x83, 0xc0, 0xc3, 0x63, 0x03, 0xc0, 0x61, 0xc6, 0x03, 0xc0, 0x31, 0x0c, 0x03, 0xc0, 0x19, 0x18, 0x03, 0xc0, 0x09, 0x10, 0x03, 0xc0, 0x08, 0x10, 0x03, 0xc0, 0x07, 0xe0, 0x03, 0xc0, 0x08, 0x10, 0x03, 0xc0, 0x07, 0xe0, 0x03, 0xe0, 0x08, 0x10, 0x07, 0x70, 0x07, 0xe0, 0x0e, 0x38, 0x08, 0x10, 0x1c, 0x1c, 0x07, 0xe0, 0x38, 0x0e, 0x00, 0x00, 0x70, 0x07, 0xff, 0xff, 0xe0, 0x03, 0xff, 0xff, 0xc0

undoButton: db 0x03, 0xff, 0xff, 0xc0, 0x07, 0xff, 0xff, 0xe0, 0x0e, 0x00, 0x00, 0x70, 0x1c, 0x00, 0x00, 0x38, 0x38, 0x00, 0x00, 0x1c, 0x70, 0x00, 0x00, 0x0e, 0xe0, 0x3f, 0xf8, 0x07, 0xc0, 0x7f, 0xfc, 0x03, 0xc0, 0xe0, 0x0e, 0x03, 0xc1, 0xc0, 0x07, 0x03, 0xc3, 0x80, 0x03, 0x83, 0xc3, 0x00, 0x01, 0xc3, 0xc3, 0x00, 0x00, 0xc3, 0xc3, 0x00, 0x00, 0xc3, 0xc0, 0x00, 0x00, 0xc3, 0xc0, 0x00, 0x00, 0xc3, 0xc0, 0x00, 0x00, 0xc3, 0xc0, 0x00, 0x00, 0xc3, 0xc0, 0x00, 0x00, 0xc3, 0xc3, 0xf8, 0x00, 0xc3, 0xc3, 0xf0, 0x01, 0xc3, 0xc3, 0xe0, 0x03, 0x83, 0xc3, 0xe0, 0x07, 0x03, 0xc3, 0xf0, 0x0e, 0x03, 0xc3, 0x3f, 0xfc, 0x03, 0xe2, 0x1f, 0xf8, 0x07, 0x70, 0x00, 0x00, 0x0e, 0x38, 0x00, 0x00, 0x1c, 0x1c, 0x00, 0x00, 0x38, 0x0e, 0x00, 0x00, 0x70, 0x07, 0xff, 0xff, 0xe0, 0x03, 0xff, 0xff, 0xc0

countLeft: DB 50

toRemove: dw 50
;===================================================================================================
DISPLAY_TIMER_TEXT:
    PUSH BP
    MOV BP,SP
    PUSHA

    PUSH WORD 5
    PUSH WORD 55
    PUSH WORD 1
    PUSH timer
    CALL PRINT_STRING

    POPA
    MOV SP,BP
    POP BP
RET


PRINT_STRING:
    ;BP+10 = LENGTH OF STRING
    ;BP+8 = COLUMN
    ;BP+6 = ROW
    ;BP+4 = STRING

    PUSH BP
    MOV BP,SP
    PUSHA

    MOV CX, [BP+10]   ;LENGTH
    MOV SI, [BP+4]    ;STRING


    loopPrint__String:
        PUSH CX 
    
        ;SET CURSOR
        MOV AH,02h
        MOV BH,0
        MOV DH,[BP+6] ;ROW
        MOV DL,[BP+8] ;COLUMN
        ADD DL,[temp]
        INT 10h

        MOV AH, 09h                                     ;DRAW AT CURSOR POSITION
        mov AL, [SI]                                    ;LOAD CHARACTER TO DISPLAY
        MOV BH, 0
        MOV BL, [color]
        MOV CX, 1
        INT 10h

        INC SI
        INC byte [temp]

        POP CX
        LOOP loopPrint__String
    

    exitPrint__String:
        MOV byte [temp], 0
        POPA
        MOV SP,BP
        POP BP
RET 8



DISPLAY_MISTAKES:
    PUSH BP
    MOV BP,SP
    PUSHA

    PUSH WORD 10
    PUSH WORD 55
    PUSH WORD 3
    PUSH WORD mistakes
    CALL PRINT_STRING

    MOV AH,02h
    MOV BH,0
    MOV DH,03
    MOV DL,67
    INT 10h

    MOV AH, 09h                                     ;DRAW AT CURSOR POSITION
    mov AL, [mistakeCount]                                    ;LOAD CHARACTER TO DISPLAY
    ADD AL, 48
    MOV BH, 0
    MOV BL, [color]
    MOV CX, 1
    INT 10h

    POPA
    MOV SP,BP
    POP BP
RET


DISPLAY_SCORE:
    PUSH BP
    MOV BP,SP
    PUSHA

    PUSH WORD 6
    PUSH WORD 55
    PUSH WORD 7
    PUSH WORD score
    CALL PRINT_STRING

    PUSH WORD [currenScore]
    CALL printnum

    POPA
    MOV SP,BP
    POP BP
RET


DISPLAY_LEVEL_TEXT:

    PUSH BP
    MOV BP,SP
    PUSHA

    PUSH WORD 12
    PUSH WORD 55
    PUSH WORD 5
    PUSH WORD level
    CALL PRINT_STRING


    CMP byte [diff], 1
    JE easy_level
    CMP byte [diff], 2
    JE medium_level
    CMP byte [diff], 3
    JE hard_level
    CMP byte [diff], 4
    JE custom_level


    easy_level:
        PUSH WORD 4
        PUSH WORD 67
        PUSH WORD 5
        PUSH WORD easy
        CALL PRINT_STRING

        JMP exit_level_text

    medium_level:
        PUSH WORD 6
        PUSH WORD 67
        PUSH WORD 5
        PUSH WORD medium
        CALL PRINT_STRING

        JMP exit_level_text

    hard_level:
        PUSH WORD 4
        PUSH WORD 67
        PUSH WORD 5
        PUSH WORD hard
        CALL PRINT_STRING
        
        JMP exit_level_text
    

    custom_level:
        PUSH WORD 6
        PUSH WORD 67
        PUSH WORD 5
        PUSH WORD cst
        CALL PRINT_STRING

    exit_level_text:

    POPA
    MOV SP,BP
    POP BP
RET



DISPLAY_SIDE_SCREEN:
    PUSH BP
    MOV BP,SP
    PUSHA

    CALL DISPLAY_TIMER_TEXT
    ;CALL DISPLAY_EXIT_BUTTON
    CALL DISPLAY_MISTAKES
    ;CALL DISPLAY_UNDO_BUTTON
    CALL DISPLAY_LEVEL_TEXT
    CALL DISPLAY_SCORE


    PUSH WORD 450
    PUSH WORD 300
    PUSH WORD 32
    PUSH WORD 32
    PUSH WORD [pencilColor]
    PUSH pencil
    CALL printfont

    PUSH WORD 450
    PUSH WORD 350
    PUSH WORD 32
    PUSH WORD 32
    PUSH WORD [eraserColor]
    PUSH eraser
    CALL printfont


    PUSH WORD 450
    PUSH WORD 250
    PUSH WORD 32
    PUSH WORD 32
    PUSH WORD [hintColor]
    PUSH hint
    CALL printfont


    PUSH WORD 450
    PUSH WORD 200
    PUSH WORD 32
    PUSH WORD 32
    PUSH WORD 0X2
    PUSH undoButton
    CALL printfont



; OL:

; MOV CX,7

; I1:

;     PUSH WORD 400
;     PUSH WORD 450
;     CALL DRAW_PEACH_BOX

;     PUSH WORD 400
;     PUSH WORD 510
;     CALL DRAW_PEACH_BOX

;     PUSH WORD 400
;     PUSH WORD 560
;     CALL DRAW_PEACH_BOX

;     ;CALL correctSound

; LOOP I1


; MOV CX,7

; I2:
;     push WORD 450
;     PUSH WORD 400
;     PUSH WORD 32
;     PUSH WORD 32
;     PUSH WORD 0X2
;     push firework
;     CALL printfont

;     push WORD 510
;     PUSH WORD 400
;     PUSH WORD 32
;     PUSH WORD 32
;     PUSH WORD 0X2
;     push firework
;     CALL printfont

;     push WORD 560
;     PUSH WORD 400
;     PUSH WORD 32
;     PUSH WORD 32
;     PUSH WORD 0X2
;     push firework
;     CALL printfont

; LOOP I2

; JMP OL

;CALL DISPLAY_FIREWORK 
   

    CALL DISPLAY_HINT_COUNT

    POPA
    MOV SP,BP
    POP BP
RET

DISPLAY_FIREWORK:

MOV CX,50
PUSH CX

OL:

MOV CX,7

I1:

    PUSH WORD 300
    PUSH WORD 250
    CALL DRAW_PEACH_BOX

    PUSH WORD 300
    PUSH WORD 310
    CALL DRAW_PEACH_BOX

    PUSH WORD 300
    PUSH WORD 360
    CALL DRAW_PEACH_BOX

    ;CALL correctSound

LOOP I1


MOV CX,7

I2:
    push WORD 250
    PUSH WORD 300
    PUSH WORD 32
    PUSH WORD 32
    PUSH WORD 0X2
    push firework
    CALL printfont

    push WORD 310
    PUSH WORD 300
    PUSH WORD 32
    PUSH WORD 32
    PUSH WORD 0X2
    push firework
    CALL printfont

    push WORD 370
    PUSH WORD 300
    PUSH WORD 32
    PUSH WORD 32
    PUSH WORD 0X2
    push firework
    CALL printfont


    CALL DRAW_TIME

LOOP I2



POP CX
LOOP OL

RET 




DISPLAY_HINT_COUNT:
    PUSHA

    ADD BYTE [hintCount], 48

    PUSH WORD 1
    PUSH WORD 61
    PUSH WORD 16
    PUSH hintCount
    CALL PRINT_STRING

    SUB BYTE [hintCount], 48

    POPA

RET



printfont:
    ; [BP + 14] POS_X
    ; [BP + 12] POS_Y
    ; [BP + 10] WIDTH
    ; [BP + 08] HEIGHT
    ; [BP + 06] COLOR
    ; [BP + 04] ADDRESS
    PUSH BP
    MOV BP, SP
    SUB SP, 4
    ; [BP - 02] PIXEL_COUNT
    ; [BP - 04] CURR_FONT_BYTE

    PUSHA

    MOV AL, [BP + 10]
    MUL byte [BP + 8]
    MOV [BP - 2], AX

    MOV SI, [BP + 4]
    MOV BL, [SI]
    MOV [BP - 4], BL

    MOV DI, 0

    MOV AH, 0x0C
    MOV AL, [BP + 6]
    MOV BX, 0
    MOV CX, [BP + 14]
    MOV DX, [BP + 12]

drawfont:
    SHL byte [BP - 4], 1
    JNC skip_pixel

    INT 0x10

skip_pixel:
    INC DI
    TEST DI, 7
    JNZ skip_load

    INC SI
    MOV BL, [SI]
    MOV [BP - 4], BL

    XOR BX, BX

skip_load:
    INC CX

    CMP DI, [BP + 10]
    JNE same_row

    MOV CX, [BP + 14]
    INC DX
    XOR DI, DI

same_row:
    DEC word [BP - 2]
    JNZ drawfont

    POPA
    
    MOV SP, BP
    POP BP

    RET 12


HINT:
    PUSHA

    ;MOV WORD [hintColor],0x15
    ;CALL DISPLAY_SIDE_SCREEN

    CMP WORD [hintCount],0
    JZ Av
    JMP hintWasOff

    Av:
    CMP BYTE [isHint],0
    MOV WORD [hintColor],0x2
    CALL DISPLAY_SIDE_SCREEN
    jmp hintLimitReached


    ;HINT WAS OFF
    hintWasOff:
    CMP BYTE [isHint],0
    JNZ hintWasOn
    MOV BYTE [isHint],1
    MOV WORD [hintColor],0x7
    ;TURN OFF PENCIL AND ERASER
    MOV BYTE [isPencil],0
    MOV WORD [pencilColor],0x2
    MOV BYTE [isEraser],0
    MOV WORD [eraserColor],0x2
    ;DEC WORD [hintCount]
    JMP hintLimitReached


    ;HINT WAS ON
    hintWasOn:
        MOV BYTE [isHint],0
        MOV WORD [hintColor],0x2
        
    
    hintLimitReached:
    CALL DISPLAY_SIDE_SCREEN
    POPA

RET


PENCIL:
    PUSHA
    CMP BYTE [isPencil],0
    JNZ pencilWasOn

    pencilWasOff:
        MOV BYTE [isPencil],1
        MOV WORD [pencilColor],0x7
        ;WHEN PENCIL IS ON, ERASER SHOULD BE OFF
        MOV BYTE [isEraser],0
        MOV BYTE [isHint],0
        MOV WORD [eraserColor],0x2
        MOV WORD [hintColor],0x2
        JMP pencil_end

    pencilWasOn:
        MOV BYTE [isPencil],0
        MOV WORD [pencilColor],0x2
    
    pencil_end:
    CALL DISPLAY_SIDE_SCREEN
    POPA
RET

ERASER:
    PUSHA
    CMP BYTE [isEraser],0
    JNZ eraserWasOn

    eraserWasOff:
        MOV BYTE [isEraser],1
        MOV WORD [eraserColor],0x7
        ;WHEN ERASER IS ON, PENCIL SHOULD BE OFF
        MOV BYTE [isPencil],0
        MOV BYTE [isHint],0
        MOV WORD [pencilColor],0x2
        MOV WORD [pencilColor],0x2
        JMP eraser_end

    eraserWasOn:
        MOV BYTE [isEraser],0
        MOV WORD [eraserColor],0x2

    eraser_end:
    CALL DISPLAY_SIDE_SCREEN
    POPA
RET