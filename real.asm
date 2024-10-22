[org 0x0100]

jmp START
;---------------------------------------------------INCLUDING FILES------------------------------------------------
%include "displayTimer.asm"
%include "frequency.asm"                            ;drawNotes.asm called in frequency 
%include "sideScreen.asm"
%include "displayGrid.asm"
;------------------------------------------------------------------------------------------------------------------

clear_screen:
    mov ah, 0x06                                    ; Scroll up function
    mov al, 0                                       ; Number of lines to scroll (0 = clear entire screen)
    mov bh, 0x0                                    ; Video page and attribute (07h = normal text)
    ;mov bh,01111111b
    mov cx, 0x0000                                  ; Upper-left corner of the screen (row 0, col 0)
    mov dx, 0xffff                                  ; Lower-right corner (row 24, col 79)
    int 0x10                                        ; Call BIOS interrupt 10h to clear the screen
RET                                                 ; Return from subroutine

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
   
    push word 17
    push word 17
    call DRAW__ALL_BOX_NOTES

;;;;;;;;;;;;;;;;;;;;;;;;
    PUSH WORD 9
    PUSH WORD 9
    CALL DRAW_PINK

    PUSH WORD 9
    PUSH WORD 9+45*5
    CALL DRAW_PINK

    PUSH WORD 9
    PUSH WORD 9+45*7
    CALL DRAW_PINK

;;;;;;;;;;;;;;;;;;;;;;;;

    PUSH WORD 54
    PUSH WORD 9+45*2
    CALL DRAW_PINK

     PUSH WORD 54
    PUSH WORD 9+45*8
    CALL DRAW_PINK
;;;;;;;;;;;;;;;;;;;;;;;;;


     PUSH WORD 99
    PUSH WORD 9+45*0
    CALL DRAW_PINK

     PUSH WORD 99
    PUSH WORD 9+45*3
    CALL DRAW_PINK

     PUSH WORD 99
    PUSH WORD 9+45*6
    CALL DRAW_PINK

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


    PUSH WORD 144
    PUSH WORD 9+45*1
    CALL DRAW_PINK

    PUSH WORD 144
    PUSH WORD 9+45*6
    CALL DRAW_PINK

     ;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    PUSH WORD 189
    PUSH WORD 9+45*2
    CALL DRAW_PINK 

    PUSH WORD 189
    PUSH WORD 9+45*4
    CALL DRAW_PINK 


    ;;;;;;;;;


    ;;;;;;;;;;;;;;

    PUSH WORD 279
    PUSH WORD 9+45*0
    CALL DRAW_PINK 

    PUSH WORD 279
    PUSH WORD 9+45*7
    CALL DRAW_PINK 

    ;;;;;;;;;;;;;;;;;;;

     PUSH WORD 324
    PUSH WORD 9+45*4
    CALL DRAW_PINK 

    PUSH WORD 324
    PUSH WORD 9+45*6
    CALL DRAW_PINK 

    ;;;;;;;;;;;;;;;;;;;;

    PUSH WORD 369
    PUSH WORD 9+45*2
    CALL DRAW_PINK

    PUSH WORD 369
    PUSH WORD 9+45*8
    CALL DRAW_PINK


    ; ;-------------------------------------


    ;CALL DRAW_ALL_PINK_BOXES

    CALL DRAW_GRID                                   ;DRAW GRID, VERTICAL AND HORIZONTAL LINES

    PUSH WORD 18
    PUSH WORD 18
    CALL DRAW_SUDOKU_ARRAY

    
    CALL DRAW_AVAILABLE_NUMBERS

    CALL DISPLAY_SIDE_SCREEN

    CALL TIMER_START

    ; abcd:
    ;     jmp abcd

    MOV ax, 0x4c00
    INT 21h



