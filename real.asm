[org 0x0100]

jmp START
;---------------------------------------------------INCLUDING FILES------------------------------------------------
%include "displayTimer.asm"                         ;displayGrid.asm called in displayTimer
;%include "frequency.asm"                            ;drawNotes.asm called in frequency 
;%include "sideScreen.asm"
;%include "displayGrid.asm"
%include"menu.asm"
%include "frontScreen.asm"
;------------------------------------------------------------------------------------------------------------------


RESTART:
    ;SET ALL NOTES1 ARRAY TO 0
    MOV CX,729
    MOV SI,0
    
    resetNotes:
        MOV WORD [notes1+SI],0
        ADD SI,2
    LOOP resetNotes

    ;SET ALL BOARDS ARRAY TO 0
    MOV CX,81
    MOV SI,0
    resetBoards:
        MOV WORD [sudokuArray+SI],0
        MOV WORD [solutionArray+SI],0
        ADD SI,2
    LOOP resetBoards

    MOV WORD [currenScore],50
    MOV WORD [hintCount],3
    MOV WORD [mistakeCount],0
    MOV WORD [toRemove],30
    MOV WORD [selected_x],8
    MOV WORD [selected_y],8
    MOV WORD [selected_x_index],0
    MOV WORD [selected_y_index],0

    MOV BYTE [minute_unit],0
    MOV BYTE [minute_tens],0
    MOV BYTE [seconds_unit],0
    MOV BYTE [seconds_tens],0
    MOV BYTE [minutes],0
    MOV BYTE [seconds],0
    MOV WORD [tickcount],0

    MOV BYTE [hasGameEnded],0

RET


SET_PALLETTE:
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
    ; MOV al,63
    ; OUT dx,al
    ; MOV al,28
    ; OUT dx,al
    ; MOV al,16
    ; OUT dx,al
    ;PURPLE LIGHT
    MOV al,00
    OUT dx,al
    MOV al,7
    OUT dx,al
    MOV al,50
    OUT dx,al


    ;BLACK
    MOV al,0
    OUT dx,al
    MOV al,0
    OUT dx,al
    MOV al,0
    OUT dx,al


    MOV al,63
    OUT dx,al
    MOV al,29
    OUT dx,al
    MOV al,50
    OUT dx,al

    ;PURPLE 

    MOV al,63
    OUT dx,al
    MOV al,0
    OUT dx,al
    MOV al,63
    OUT dx,al

    MOV al,50
    OUT dx,al
    MOV al,0
    OUT dx,al
    MOV al,63
    OUT dx,al

    MOV al,63
    OUT dx,al
    MOV al,10
    OUT dx,al
    MOV al,55
    OUT dx,al

RET

firework: db 0x00, 0x00, 0x00, 0x00, 0x00, 0x04, 0x40, 0x00, 0x00, 0x44, 0x48, 0x00, 0x00, 0x44, 0x48, 0x00, 0x0c, 0x20, 0x10, 0x30, 0x06, 0x21, 0x10, 0x60, 0x23, 0x11, 0x20, 0xc4, 0x11, 0x91, 0x21, 0x88, 0x08, 0xc1, 0x03, 0x10, 0x00, 0x61, 0x06, 0x00, 0x00, 0x31, 0x0c, 0x18, 0x0c, 0x19, 0x18, 0x60, 0x03, 0x0d, 0x31, 0x80, 0x70, 0xc7, 0x60, 0x0e, 0x00, 0x07, 0xe0, 0x00, 0x00, 0x03, 0xff, 0xe0, 0x07, 0xff, 0xc0, 0x00, 0x00, 0x07, 0xe0, 0x00, 0x70, 0x06, 0xe1, 0x8e, 0x00, 0xcc, 0xb0, 0x60, 0x03, 0x18, 0x98, 0x18, 0x0c, 0x30, 0x8c, 0x00, 0x00, 0x60, 0x86, 0x00, 0x08, 0xc8, 0x93, 0x10, 0x11, 0x88, 0x91, 0x88, 0x23, 0x10, 0x88, 0xc4, 0x06, 0x10, 0x88, 0x60, 0x0c, 0x20, 0x04, 0x30, 0x00, 0x22, 0x14, 0x00, 0x00, 0x02, 0x10, 0x00, 0x00, 0x02, 0x10, 0x00, 0x00, 0x00, 0x00, 0x00

c: dw 0

START:


    MOV AX,0X13
    INT 10H


    CALL SET_PALLETTE
      ; ;-------------------------------------

    ;SAVE ORIGINAL INTERRUPT VECTOR IN KBD

    MOV AX,0
    MOV ES,AX
    MOV AX, [ES:9*4]
    MOV WORD [KBD], AX
    MOV AX, [ES:9*4+2]
    MOV WORD [KBD+2], AX

   

    ;HOOK MENU_KEYBOARD INTERRUPT
    MOV AX, 0
    MOV ES, AX
    CLI
    MOV WORD [ES:9*4], MENU_KEYBOARD
    MOV WORD [ES:9*4+2], CS
    STI


    CALL clear_320


    
    MOV AX,0XA000
    MOV ES,AX
    CALL print_welcome_screen

    CALL SET_PALLETTE
 
    CALL MENUU

    mov ax, 0x12
    int 10h

    CALL SET_PALLETTE

    MOV AX, 0
    MOV ES, AX
    MOV AX, [KBD]
    MOV WORD [ES:9*4], AX
    MOV AX, [KBD+2]
    MOV WORD [ES:9*4+2], AX


    call clear_screen

;/////////////////////////////////////////////////////////////////////////////////////
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
   
  
    ;-------------------------------------
 
    call correctSound

    mov ah,0
    int 16h

    CALL generateBoard

    CALL COPY_TO_SOLUTION

    PUSH WORD [toRemove]
    
    CALL REMOVE_N_NUMBERS
    
    CALL SET_FREQUENCY

    CALL DRAW_ALL_PINK_BOXES
    
    CALL DRAW_GRID                          ;DRAW GRID, VERTICAL AND HORIZONTAL LINES


    PUSH WORD 18
    PUSH WORD 18
    CALL DRAW_SUDOKU_ARRAY

    push word 17
    push word 17
    call DRAW__ALL_BOX_NOTES
    
    CALL TIMER_START

    CALL DRAW_9_PURPLE_BOXES_BEHIND_FREQ
    
    CALL DRAW_AVAILABLE_NUMBERS


    CALL DRAW_CARDS_OUTLINE

    CALL DISPLAY_SIDE_SCREEN

   
    CALL DRAW_SELECTED_BOX_OUTLINE





    jmp $
    ; abcd:
    ;     jmp abcd

    MOV ax, 0x3100
    INT 21h



