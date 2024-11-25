[org 0x0100]

jmp START
;---------------------------------------------------INCLUDING FILES------------------------------------------------
%include "displayTimer.asm"                         ;displayGrid.asm called in displayTimer
;%include "frequency.asm"                            ;drawNotes.asm called in frequency 
;%include "sideScreen.asm"
;%include "displayGrid.asm"
;%include "frontScreen.asm"
;------------------------------------------------------------------------------------------------------------------

START:


 MOV AH,00
    INT 16H

   
   
    mov ax, 0x12
    int 10h

    call clear_screen

;////////////////////////////COLOR PALETTE///////////////////////////////
    MOV AL,0x0
    MOV dx,0x3c8
    OUT dx,al
    MOV dx,0x3c9

     ;WHITE
    MOV al,63
    OUT dx,al
    MOV al,59
    OUT dx,al
    MOV al,59
    OUT dx,al


    ;baby pink
    MOV al,61
    OUT dx,al
    MOV al,49
    OUT dx,al
    MOV al,55
    OUT dx,al

    ;DARK PINK

    MOV al,63
    OUT dx,al
    MOV al,11
    OUT dx,al
    MOV al,39
    OUT dx,al

    ;ORANGE
    MOV al,63
    OUT dx,al
    MOV al,28
    OUT dx,al
    MOV al,16
    OUT dx,al

;/////////////////////////////////////////////////////////////////////////////////////
   
    ; ;-------------------------------------


    CALL generateBoard

    CALL COPY_TO_SOLUTION

    PUSH WORD [toRemove]
    CALL REMOVE_N_NUMBERS

    CALL DRAW_ALL_PINK_BOXES
    
    CALL SET_FREQUENCY
    
    CALL DRAW_GRID                                   ;DRAW GRID, VERTICAL AND HORIZONTAL LINES

    PUSH WORD 18
    PUSH WORD 18
    CALL DRAW_SUDOKU_ARRAY

    push word 17
    push word 17
    call DRAW__ALL_BOX_NOTES
    
    CALL DRAW_AVAILABLE_NUMBERS

    CALL DISPLAY_SIDE_SCREEN

    CALL DRAW_SELECTED_BOX_OUTLINE

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
         
    ;SET NEW INTERRUPT VECTOR

    CLI 
    MOV WORD [ES:9*4],KEYBOARD_MOVEMENT
    MOV WORD [ES:9*4+2],CS
    STI


    ;hook divide by zero interrupt
    MOV AX, 0
    MOV ES, AX
    MOV WORD [ES:0],  DIVIDE_BY_ZERO
    MOV WORD [ES:2], CS


    MOV DX,START
	add dx, 15 ; round up to next para
	mov cl, 4
	shr dx, cl 


    ; abcd:
    ;     jmp abcd

    MOV ax, 0x3100
    INT 21h



