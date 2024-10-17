
exit: db "EXIT"
mistakes: db "MISTAKES:"
undo: db "UNDO"
timer: db "TIMER:"
temp: db 0


DISPLAY_TIMER_TEXT:
    PUSH BP
    MOV BP,SP
    PUSHA

    MOV CX, 6                                          ;LENGTH OF STRING
    MOV SI, timer

    loop_timer_text:
        PUSH CX 

        MOV AH, 02h                                     ;SET CURSOR POSITION
        MOV BH, 0
        MOV DH, 1                                       ;ROW
        MOV DL, 55                                      ;COLUMN
        ADD DL,[temp]
        INT 10h

        MOV AH, 09h                                     ;DRAW AT CURSOR POSITION
        mov AL, [SI]                                    ;LOAD CHARACTER TO DISPLAY
        MOV BH, 0
        MOV BL, 12
        MOV CX, 1
        INT 10h

        INC SI
        INC byte [temp]

        POP CX
        LOOP loop_timer_text

    MOV byte [temp], 0

    POPA
    MOV SP,BP
    POP BP
RET




DISPLAY_UNDO_BUTTON:
    PUSH BP
    MOV BP,SP
    PUSHA

    MOV CX, 4                                           ;LENGTH OF STRING
    MOV SI, undo

    loop_undo_button:
        PUSH CX 

        MOV AH, 02h                                     ;SET CURSOR POSITION
        MOV BH, 0
        MOV DH, 10                                      ;ROW
        MOV DL, 55                                      ;COLUMN
        ADD DL,[temp]
        INT 10h

        MOV AH, 09h                                     ;DRAW AT CURSOR POSITION
        mov AL, [SI]                                    ;LOAD CHARACTER TO DISPLAY
        MOV BH, 0
        MOV BL, 12
        MOV CX, 1
        INT 10h

        INC SI
        INC byte [temp]

        POP CX
        LOOP loop_undo_button

    MOV byte [temp], 0

    POPA
    MOV SP,BP
    POP BP
RET



DISPLAY_MISTAKES:
    PUSH BP
    MOV BP,SP
    PUSHA

    MOV CX, 9                                           ;LENGTH OF STRING
    MOV SI, mistakes

    loop_mistakes:
        PUSH CX 

        MOV AH, 02h                                     ;SET CURSOR POSITION
        MOV BH, 0
        MOV DH, 5                                       ;ROW
        MOV DL, 55                                      ;COLUMN
        ADD DL,[temp]
        INT 10h

        MOV AH, 09h                                     ;DRAW AT CURSOR POSITION
        mov AL, [SI]                                    ;LOAD CHARACTER TO DISPLAY
        MOV BH, 0
        MOV BL, 12
        MOV CX, 1
        INT 10h

        INC SI
        INC byte [temp]

        POP CX
        LOOP loop_mistakes

    MOV byte [temp], 0

    POPA
    MOV SP,BP
    POP BP
RET


DISPLAY_EXIT_BUTTON:
    PUSH BP
    MOV BP,SP
    PUSHA

    MOV CX, 4                                           ;LENGTH OF STRING
    MOV SI, exit

    loop_exit_button:
        PUSH CX 

        MOV AH, 02h                                     ;SET CURSOR POSITION
        MOV BH, 0
        MOV DH, 15                                      ;ROW
        MOV DL, 55                                      ;COLUMN
        ADD DL,[temp]
        INT 10h

        MOV AH, 09h                                     ;DRAW AT CURSOR POSITION
        mov AL, [SI]                                    ;LOAD CHARACTER TO DISPLAY
        MOV BH, 0
        MOV BL, 12
        MOV CX, 1
        INT 10h

        INC SI
        INC byte [temp]

        POP CX
        LOOP loop_exit_button
    
    MOV byte [temp], 0

    POPA
    MOV SP,BP
    POP BP
RET


DISPLAY_SIDE_SCREEN:
    PUSH BP
    MOV BP,SP
    PUSHA


    CALL DISPLAY_TIMER_TEXT
    CALL DISPLAY_EXIT_BUTTON
    CALL DISPLAY_MISTAKES
    CALL DISPLAY_UNDO_BUTTON

    POPA
    MOV SP,BP
    POP BP
RET


