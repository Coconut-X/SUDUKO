; [org 0x0100] 
; global minute_unit, minute_tens, seconds_unit, seconds_tens

; minute_unit:    db  0
; minute_tens:    db	0
; seconds_unit:   db	0
; seconds_tens:   db	0
; minutes:        db  0
; seconds:        db  0
; tickcount:      dw  0 

; ; display a tick count on the top right of screen 
; jmp  start 

; DRAW_TIME:
;     push bp
;     mov bp, sp
;     push es
;     pushA

;     ; Set ES to point to video memory
;     mov ax, 0xb800
;     mov es, ax

;     ; Display minute units first
;     mov al, [cs:minutes]
;     mov ah, 0
;     mov bl, 10             ; Load 10 into register BL
;     div bl                 ; Divide by 10, AL = remainder (units), AH = quotient (tens)
    
;     add al, 0x30           ; Convert units to ASCII
;     mov [cs:minute_unit], al  ; Save units digit
;     mov di, 72             ; Position for the units of minutes (column 72)
;     shl di,1               ; Multiply DI by 2 for video memory addressing
;     mov [es:di], al        ; Display minute units
;     mov byte [es:di+1], 0x07  ; Set the color attribute (white on black)

;     ; Now display minute tens at one column before
;     mov al, ah             ; AH contains the tens
;     add al, 0x30           ; Convert tens to ASCII
;     mov [cs:minute_tens], al  ; Save tens digit
;     mov di, 70             ; Position for the tens of minutes (column 70)
;     shl di,1               ; Multiply DI by 2 for video memory addressing
;     mov [es:di], al        ; Display minute tens
;     mov byte [es:di+1], 0x07  ; Set the color attribute (white on black)

;     ; Display colon
;     mov di, 74             ; Position for the colon (column 74)
;     shl di,1
;     mov al, ':'
;     mov [es:di], al        ; Display colon
;     mov byte [es:di+1], 0x07  ; Set the color attribute (white on black)

;     ; Display second units first
;     mov al, [cs:seconds]
;     mov ah, 0
;     mov bl, 10             ; Load 10 into register BL
;     div bl                 ; Divide by 10, AL = remainder (units), AH = quotient (tens)

;     add al, 0x30           ; Convert units to ASCII
;     mov [cs:seconds_unit], al ; Save units digit
;     mov di, 78             ; Position for the units of seconds (column 78)
;     shl di,1
;     mov [es:di], al        ; Display second units
;     mov byte [es:di+1], 0x07  ; Set the color attribute (white on black)

;     ; Now display second tens at one column before
;     mov al, ah             ; AH contains the tens
;     add al, 0x30           ; Convert tens to ASCII
;     mov [cs:seconds_tens], al ; Save tens digit
;     mov di, 76             ; Position for the tens of seconds (column 76)
;     shl di,1
;     mov [es:di], al        ; Display second tens
;     mov byte [es:di+1], 0x07  ; Set the color attribute (white on black)

;     popA
;     pop es
;     mov sp, bp
;     pop bp

;     ret


; incrementSeconds:
;     inc byte [cs:seconds]
;     mov word [cs:tickcount], 0

; RET

; incrementMinutes:
;     inc byte [cs:minutes]
;     mov byte [cs:seconds],0

; RET

; incrementTimer:

;     push ax

;     inc word [cs:tickcount]
;     cmp word [cs:tickcount], 18
;     jz incrementSeconds

;     cmp byte [cs:seconds],60
;     jz incrementMinutes

;     call DRAW_TIME

;     mov al, 0x20
;     out 0x20, al

;     pop ax
;     iret



; start:        xor  ax, ax 
;               mov  es, ax             ; point es to IVT base 
;               cli                     ; disable interrupts 
;               mov  word [es:8*4], incrementTimer; store offset at n*4 
;               mov  [es:8*4+2], cs     ; store segment at n*4+2 
;               sti                     ; enable interrupts 
 
;               mov  dx, start          ; end of resident portion 
;               add  dx, 15             ; round up to next para 
;               mov  cl, 4 
;               shr  dx, cl             ; number of paras  
;               mov  ax, 0x3100         ; terminate and stay resident 
;               int  0x21

[org 0x0100] 
global minute_unit, minute_tens, seconds_unit, seconds_tens

minute_unit:    db  0
minute_tens:    db	0
seconds_unit:   db	0
seconds_tens:   db	0
minutes:        db  0
seconds:        db  0
tickcount:      dw  0 

; display a tick count on the top right of screen 
jmp  start 

DRAW_TIME:
    push bp
    mov bp, sp
    push es
    pushA

    ; Set ES to point to video memory
    mov ax, 0xb800
    mov es, ax

    ; Display minute units first
    mov al, [cs:minutes]
    mov ah, 0
    mov bl, 10             ; Load 10 into register BL
    div bl                 ; Divide by 10, AL = remainder (units), AH = quotient (tens)
    
    add al, 0x30           ; Convert units to ASCII
    mov [cs:minute_unit], al  ; Save units digit
    mov di, 70             ; Position for the units of minutes (column 72)
    shl di,1               ; Multiply DI by 2 for video memory addressing
    mov [es:di], al        ; Display minute units
    mov byte [es:di+1], 0x07  ; Set the color attribute (white on black)

    ; Now display minute tens at one column before
    mov al, ah             ; AH contains the tens
    add al, 0x30           ; Convert tens to ASCII
    mov [cs:minute_tens], al  ; Save tens digit
    mov di, 72             ; Position for the tens of minutes (column 70)
    shl di,1               ; Multiply DI by 2 for video memory addressing
    mov [es:di], al        ; Display minute tens
    mov byte [es:di+1], 0x07  ; Set the color attribute (white on black)

    ; Display colon
    mov di, 74             ; Position for the colon (column 74)
    shl di,1
    mov al, ':'
    mov [es:di], al        ; Display colon
    mov byte [es:di+1], 0x07  ; Set the color attribute (white on black)

    ; Display second units first
    mov al, [cs:seconds]
    mov ah, 0
    mov bl, 10             ; Load 10 into register BL
    div bl                 ; Divide by 10, AL = remainder (units), AH = quotient (tens)

    add al, 0x30           ; Convert units to ASCII
    mov [cs:seconds_unit], al ; Save units digit
    mov di, 76             ; Position for the units of seconds (column 78)
    shl di,1
    mov [es:di], al        ; Display second units
    mov byte [es:di+1], 0x07  ; Set the color attribute (white on black)

    ; Now display second tens at one column before
    mov al, ah             ; AH contains the tens
    add al, 0x30           ; Convert tens to ASCII
    mov [cs:seconds_tens], al ; Save tens digit
    mov di, 78             ; Position for the tens of seconds (column 76)
    shl di,1
    mov [es:di], al        ; Display second tens
    mov byte [es:di+1], 0x07  ; Set the color attribute (white on black)

    popA
    pop es
    mov sp, bp
    pop bp

    ret


incrementSeconds:
    inc byte [cs:seconds]
    mov word [cs:tickcount], 0

    ; Check if seconds overflow
    cmp byte [cs:seconds], 60
    jl no_minute_increment   ; If seconds < 60, skip minute increment

    ; Reset seconds and increment minutes
    mov byte [cs:seconds], 0
    inc byte [cs:minutes]

no_minute_increment:
    ret


incrementTimer:
    push ax

    ; Increment tick count and check if 18 ticks passed (approximately 1 second)
    inc word [cs:tickcount]
    cmp word [cs:tickcount], 18
    jl no_second_increment   ; If tickcount < 18, skip second increment

    ; Call to increment seconds
    call incrementSeconds

no_second_increment:
    ; Draw the updated time
    call DRAW_TIME

    ; Acknowledge interrupt
    mov al, 0x20
    out 0x20, al

    pop ax
    iret


start:
    xor ax, ax 
    mov es, ax             ; point es to IVT base 
    cli                    ; disable interrupts 
    mov word [es:8*4], incrementTimer ; store offset at n*4 
    mov [es:8*4+2], cs     ; store segment at n*4+2 
    sti                    ; enable interrupts 
 
    mov dx, start          ; end of resident portion 
    add dx, 15             ; round up to next para 
    mov cl, 4 
    shr dx, cl             ; number of paras  
    mov ax, 0x3100         ; terminate and stay resident 
    int 0x21
