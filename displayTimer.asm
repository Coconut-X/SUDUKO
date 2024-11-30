%include "displayGrid.asm"

global minute_unit, minute_tens, seconds_unit, seconds_tens

minute_unit:    db  0
minute_tens:    db	0
seconds_unit:   db	0
seconds_tens:   db	0
minutes:        db  0
seconds:        db  0
tickcount:      dw  0 

DRAW_TIME:

    PUSH BP
    MOV BP, SP
    PUSH ES
    PUSHA

    ;CALL DRAW_SELECTED_BOX_OUTLINE

    ;SET CURSOR POSITION COLUMN 70 ROW 1
    mov ah, 02h
    mov bh, 0
    mov dh, 1
    mov dl, 70
    INT 10h

    ; DISPLAY MINUTES UNITS 
    mov al, [cs:minutes]
    mov ah, 0
    mov bl, 10                          ; Load 10 into register BL
    div bl                              ; Divide by 10, AL = remainder (units), AH = quotient (tens)
    add al, 0x30                        ; Convert units to ASCII
    mov [cs:minute_unit], al            ; Save units digit

    ;DISPLAY AT CURSOR POSITION
    PUSH ax
    mov ah, 09h
    mov al, [cs:minute_unit]
    mov bh, 0
    mov bl, 0X7
    mov cx, 1
    INT 10h

    ; NOW DISPLAY MINUTE TENS AT ONE COLUMN BEFORE

    ;SET CURSOR POSITION COLUMN 72 ROW 1
    mov ah, 02h
    mov bh, 0
    mov dh, 1
    mov dl, 72
    INT 10h

    POP AX

    mov al, ah                          ; AH contains the tens
    add al, 0x30                        ; Convert tens to ASCII
    mov [cs:minute_tens], al            ; Save tens digit

    ;DISPLAY AT CURSOR POSITION
    mov ah, 09h
    mov al, [cs:minute_tens]
    mov bh, 0
    mov bl, 0X7
    mov cx, 1
    int 10h

    ; DISPLAY COLON

    ;SET CURSOR POSITION COLUMN 74 ROW 1
    mov ah, 02h
    mov bh, 0
    mov dh, 1
    mov dl, 74
    INT 10h

    mov al, ':'
    mov ah, 09h
    mov bh, 0
    mov bl, 0X7
    mov cx, 1
    INT 10h


    ; DISPLAY SECONDS UNITS
    mov al, [cs:seconds]
    mov ah, 0
    mov bl, 10                          ; Load 10 into register BL
    div bl                              ; Divide by 10, AL = remainder (units), AH = quotient (tens)
    add al, 0x30                        ; Convert units to ASCII
    mov [cs:seconds_unit], al           ; Save units digit

    PUSH ax
    ;SET CURSOR POSITION COLUMN 76 ROW 1
    mov ah, 02h
    mov bh, 0
    mov dh, 1
    mov dl, 76
    INT 10h

    ;DISPLAY AT CURSOR POSITION
    mov ah, 09h
    mov al, [cs:seconds_unit]
    mov bh, 0
    mov bl, 0X7
    mov cx, 1
    INT 10h

    

    ; NOW DISPLAY SECONDS TENS AT ONE COLUMN BEFORE

    ;SET CURSOR POSITION COLUMN 78 ROW 1
    mov ah, 02h
    mov bh, 0
    mov dh, 1

    mov dl, 78
    int 10h

    POP ax

    mov al, ah                          ; AH contains the tens
    add al, 0x30                        ; Convert tens to ASCII
    mov [cs:seconds_tens], al           ; Save tens digit

    ;DISPLAY AT CURSOR POSITION
    mov ah, 09h
    mov al, [cs:seconds_tens]
    mov bh, 0
    mov bl, 0X7
    mov cx, 1
    INT 10h



    POPA
    POP ES
    MOV SP, BP
    POP BP

RET



incrementSeconds:
    inc byte [cs:seconds]
    mov word [cs:tickcount], 0

                                            ; Check if seconds overflow
    cmp byte [cs:seconds], 60
    jl no_minute_increment                  ; If seconds < 60, skip minute increment

                                            ; Reset seconds and increment minutes
    mov byte [cs:seconds], 0
    inc byte [cs:minutes]

no_minute_increment:
    
RET


incrementTimer:
    push ax
                                            ; Increment tick count and check if 18 ticks passed (approximately 1 second)
    inc word [cs:tickcount]
    cmp word [cs:tickcount], 18
    jl no_second_increment                  ; If tickcount < 18, skip second increment

    call incrementSeconds

no_second_increment:
    ; Draw the updated time
    call DRAW_TIME

    ; Acknowledge interrupt
    mov al, 0x20
    out 0x20, al

    pop ax
    
IRET


TIMER_START:

    xor ax, ax 
    mov es, ax                              ; point es to IVT base 
    cli                                     ; disable interrupts 
    mov word [es:8*4], incrementTimer       ; store offset at n*4 
    mov [es:8*4+2], cs                      ; store segment at n*4+2 
    sti                                     ; enable interrupts 
 
    mov dx, TIMER_START                     ; end of resident portion 
    add dx, 15                              ; round up to next para 
    mov cl, 4 
    shr dx, cl                              ; number of paras  
    ; mov ax, 0x3100                        ; terminate and stay resident 
    ; int 0x21
    
RET
