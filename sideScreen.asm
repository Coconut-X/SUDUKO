
exit: db "EXIT"
mistakes: db "MISTAKES: 1/3"
undo: db "UNDO"
timer: db "TIMER:"
temp: db 0
level: db "DIFFICULTY: EASY"

color: db 8

;UNDO_ICON: DB 	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,	0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,	0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,	0,0,0,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,	0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,	0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,	0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,	0,0,0,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,0,	0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,0,	0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,0,	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,0,	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,0,	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,0,	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,0,	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,0,	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,0,	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,0,	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,0,	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,0,	0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,	0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,	0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,	2	

UNDO_ICON: DB 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,	1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,	1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,	1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,	1,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,	1,0,0,0,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,	1,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,1,	1,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,1,	1,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,1,	1,0,0,0,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,0,1,	1,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,0,1,	1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,0,1,	1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,0,1,	1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,0,1,	1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,0,1,	1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,0,1,	1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,0,1,	1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,0,1,	1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,0,1,	1,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,1,	1,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,1,	1,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,1,	1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,	1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,	1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,	2

; DRAW_ICONS:

;     push bp
;     mov bp,sp
;     pushA
    
;     mov si, [bp+4]                                          ;SI = BITMAP TO BE DRAWN

;     mov ah, 0x0c ;0x0c                                      ;TELETYPE FUNCTION
;     mov bh, 0
;     mov cx, [bp+6]                                          ;X COORDINATE
;     mov dx, [bp+8]                                          ;Y COORDINATE
;     dec dx                                                  ;Y COORDINATE - 1, BECAUSE WE WILL INC DX IN NEXT ROW
;     mov al, 0x2                                              ;pink COLOR
;     Next_Row:
;         inc dx
;         mov di, 1
;         mov cx, [bp + 6]
;         Current_Row:
;             cmp byte[si], 2
;             jz exitDraw_Bitmap
;             cmp byte[si], 1
;             jnz skip_Print
;             mov al, 0x2 
;             int 10h
;             skip_Print:
;                 inc cx
;                 inc di
;                 inc si
;                 ; mov al,0x0
;                 ; int 10h
;                 cmp di, 26
;             jz Next_Row
;         jmp Current_Row

;     exitDraw_Bitmap:
;         popA
;         mov sp,bp
;         pop bp

; RET 6



DRAW_ICONS:

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
    Next__Row:
        inc dx
        mov di, 1
        mov cx, [bp + 6]
        Current__Row:
            cmp byte[si], 2
            jz exitDraw__Bitmap
            cmp byte[si], 1
            jnz skip__Print
            mov al, 0x2 
            int 10h
            skip__Print:
                inc cx
                inc di
                inc si
                ; mov al,0x0
                ; int 10h
                cmp di, 26
            jz Next__Row
        jmp Current__Row

    exitDraw__Bitmap:
        popA
        mov sp,bp
        pop bp

RET 6




DISPLAY_TIMER_TEXT:
    PUSH BP
    MOV BP,SP
    PUSHA

    MOV CX, 6                                           ;LENGTH OF STRING
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
        MOV BL, [color]                                      ;COLOR
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
        MOV BL, [color]
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

    MOV CX, 13                                           ;LENGTH OF STRING
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
        MOV BL, [color]
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
        MOV BL, [color]
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

DISPLAY_LEVEL_TEXT:

    PUSH BP
    MOV BP,SP
    PUSHA

    MOV CX, 16                                           ;LENGTH OF STRING
    MOV SI, level

    loop_level_text:
        PUSH CX 

        MOV AH, 02h                                     ;SET CURSOR POSITION
        MOV BH, 0
        MOV DH, 20                                      ;ROW
        MOV DL, 55                                      ;COLUMN
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
        LOOP loop_level_text

    MOV byte [temp], 0

    POPA
    MOV SP,BP
    POP BP
ret



DISPLAY_SIDE_SCREEN:
    PUSH BP
    MOV BP,SP
    PUSHA

    CALL DISPLAY_TIMER_TEXT
    CALL DISPLAY_EXIT_BUTTON
    CALL DISPLAY_MISTAKES
    ;CALL DISPLAY_UNDO_BUTTON
    CALL DISPLAY_LEVEL_TEXT

    PUSH WORD 350
    PUSH WORD 470
    PUSH UNDO_ICON
    CALL DRAW_ICONS


    POPA
    MOV SP,BP
    POP BP
RET
