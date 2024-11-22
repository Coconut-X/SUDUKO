[org 0x0100]

jmp START
;---------------------------------------------------INCLUDING FILES------------------------------------------------
%include "displayTimer.asm"                         ;displayGrid.asm called in displayTimer
;%include "frequency.asm"                            ;drawNotes.asm called in frequency 
;%include "sideScreen.asm"
;%include "displayGrid.asm"
;%include "frontScreen.asm"
;------------------------------------------------------------------------------------------------------------------

; clear_screen:
;     mov ah, 0x06                                    ; Scroll up function
;     mov al, 0                                       ; Number of lines to scroll (0 = clear entire screen)
;     mov bh, 0x0                                    ; Video page and attribute (07h = normal text)
;     ;mov bh,01111111b
;     mov cx, 0x0000                                  ; Upper-left corner of the screen (row 0, col 0)
;     mov dx, 0xffff                                  ; Lower-right corner (row 24, col 79)
;     int 0x10                                        ; Call BIOS interrupt 10h to clear the screen
; RET                                                 ; Return from subroutine

START:
   
    mov ax, 0x12
    int 10h

    call clear_screen

;////////////////////////////COLOR PALETTE///////////////////////////////
    MOV AL,0x0
    MOV dx,0x3c8
    out dx,al
    mov dx,0x3c9

     ;WHITE
    mov al,63
    out dx,al
    mov al,59
    out dx,al
    mov al,59
    out dx,al


    ;baby pink
    mov al,61
    out dx,al
    mov al,49
    out dx,al
    mov al,55
    out dx,al

    ;DARK PINK

    mov al,63
    out dx,al
    mov al,11
    out dx,al
    mov al,39
    out dx,al

    ;ORANGE
    mov al,63
    out dx,al
    mov al,28
    out dx,al
    mov al,16
    out dx,al

;/////////////////////////////////////////////////////////////////////////////////////
   


    ; ;-------------------------------------


    CALL DRAW_ALL_PINK_BOXES

    CALL DRAW_GRID                                   ;DRAW GRID, VERTICAL AND HORIZONTAL LINES

    CALL generateBoard


    PUSH WORD 18
    PUSH WORD 18
    CALL DRAW_SUDOKU_ARRAY

    push word 17
    push word 17
    call DRAW__ALL_BOX_NOTES
    
    CALL DRAW_AVAILABLE_NUMBERS

    CALL DISPLAY_SIDE_SCREEN

    ;CALL DRAW_SELECTED_BOX_OUTLINE

    CALL TIMER_START


    ;;;;;;;;;;;HOOKING KEYBOARD INTERRUPT;;;;;;;;;;;;;;;;;;;;;

    ;STORE ORIINAL INTERRUPT VECTOR
    XOR AX,AX
    MOV ES,AX
    MOV DI,0

    MOV AX,[ES:9*4]
    MOV [old_kbisr],AX ;SAVE OFFSET

    MOV AX,[ES:9*4+2]
    MOV [old_kbisr+2],AX ;SAVE SEGMENT


    CLI 
    MOV WORD [ES:9*4],KEYBOARD_MOVEMENT
    MOV WORD [ES:9*4+2],CS
    STI

    MOV DX,START
	add dx, 15 ; round up to next para
	mov cl, 4
	shr dx, cl 


    ; abcd:
    ;     jmp abcd

    MOV ax, 0x3100
    INT 21h



