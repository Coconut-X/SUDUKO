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
    mov bh, 0x07                                    ; Video page and attribute (07h = normal text)
    mov cx, 0x0000                                  ; Upper-left corner of the screen (row 0, col 0)
    mov dx, 0x184F                                  ; Lower-right corner (row 24, col 79)
    int 0x10                                        ; Call BIOS interrupt 10h to clear the screen
RET                                                 ; Return from subroutine

START:
   
    mov ax, 0x12
    int 10h
   
    ; push word 17
    ; push word 17
    ; call DRAW__ALL_BOX_NOTES

    CALL DRAW_GRID                                   ;DRAW GRID, VERTICAL AND HORIZONTAL LINES

    PUSH WORD 18
    PUSH WORD 18
    CALL DRAW_SUDOKU_ARRAY

    CALL DRAW_AVAILABLE_NUMBERS

    CALL DISPLAY_SIDE_SCREEN

    CALL TIMER_START

    MOV ax, 0x4c00
    INT 21h



