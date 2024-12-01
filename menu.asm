LEFTT: DB 0x80, 0xc0, 0xe0, 0xf0, 0xf0, 0xe0, 0xc0, 0x80

RIGHTT: DB 0x01, 0x03, 0x07, 0x0f, 0x0f, 0x07, 0x03, 0x01

POINTER_Y: DW 56

KBD: DD 0

guide: db 'G U I D E'
ez: db 'E A S Y'
med: db 'M E D I U M'
hd: db 'H A R D'
custom: db 'ENTER NUMBER OF ELEMENTS TO REMOVE'
cust: db 'C U S T O M'

G1: DB '1. COMPLETE THE GRID'
G2: DB '2. UNIQUE ELEMENTS IN EACH ROW'
G3: DB '3. UNIQUE ELEMENTS IN EACH COLUMN'
G4: DB '4. UNIQUE ELEMENTS IN EACH SUBGRID'
G5: DB '5. YOU HAVE THREE HINTS'
G6: DB '6. YOU HAVE THREE MISTAKES'
G7: DB 'PRESS DOWN KEY TO GO BACK'

GO: DB 0

CHECK: DB 'OKI'

PRINT_STR:
    ;BP+10 = LENGTH OF STRING
    ;BP+8 = COLUMN
    ;BP+6 = ROW
    ;BP+4 = STRING

    PUSH BP
    MOV BP,SP
    PUSHA

    MOV CX, [BP+10]   ;LENGTH
    MOV SI, [BP+4]    ;STRING


    loopPrint___String:
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
        MOV BL, 0X5
        MOV CX, 1
        INT 10h

        INC SI
        INC byte [temp]

        POP CX
        LOOP loopPrint___String
    

    exitPrint___String:
        MOV byte [temp], 0
        POPA
        MOV SP,BP
        POP BP
RET 8


GUIDE_SCREEN:
    CALL clear_320

    PUSH WORD 20
    PUSH WORD 2
    PUSH WORD 5
    PUSH G1
    CALL PRINT_STR

    PUSH WORD 30
    PUSH WORD 2
    PUSH WORD 7
    PUSH G2
    CALL PRINT_STR

    PUSH WORD 33
    PUSH WORD 2
    PUSH WORD 9
    PUSH G3
    CALL PRINT_STR

    PUSH WORD 34
    PUSH WORD 2
    PUSH WORD 11
    PUSH G4
    CALL PRINT_STR

    PUSH WORD 23
    PUSH WORD 2
    PUSH WORD 13
    PUSH G5
    CALL PRINT_STR

    PUSH WORD 26
    PUSH WORD 2
    PUSH WORD 15
    PUSH G6
    CALL PRINT_STR

    PUSH WORD 25
    PUSH WORD 2
    PUSH WORD 17
    PUSH G7
    CALL PRINT_STR


JMP NO_KEY

clear_320:
   PUSHA

    mov ah, 0x06                                    ; Scroll up function
    mov al, 0                                       ; Number of lines to scroll (0 = clear entire screen)
    mov bh, 0x0                                    ; Video page and attribute (07h = normal text)
    ;mov bh,01111111b
    mov cx, 0x0000                                  ; Upper-left corner of the screen (row 0, col 0)
    mov dx, 0xffff                                  ; Lower-right corner (row 24, col 79)
    int 0x10                                        ; Call BIOS interrupt 10h to clear the screen

    POPA
RET

KEY_UP:
    CMP WORD [cs:POINTER_Y], 56
    JE NO_KEY
    SUB WORD [cs:POINTER_Y], 16
    CALL PRINT_POINTER
    JMP NO_KEY

KEY_DOWN:

    MOV AX,0XA000
    MOV ES,AX
    CALL print_welcome_screen

    CALL SET_PALLETTE

    CMP WORD [cs:POINTER_Y], 56+16*4
    JE NO_KEY
    ADD WORD [cs:POINTER_Y], 16
    CALL PRINT_POINTER
    JMP NO_KEY

DF1:
    MOV BYTE [diff], 1
    MOV WORD [toRemove],20
    MOV BYTE [countLeft],20
    MOV BYTE [CS:GO], 1

    MOV WORD [BP+2],exit_menu
    MOV WORD [BP+4],CS
    JMP NO_KEY


DF2:
    MOV BYTE [diff], 2
    MOV WORD [toRemove],35
    MOV BYTE [countLeft],35
    MOV BYTE [CS:GO], 1

    MOV WORD [BP+2],exit_menu
    MOV WORD [BP+4],CS
    JMP NO_KEY

DF3:
    MOV BYTE [diff], 3
    MOV WORD [toRemove],55
    MOV BYTE [countLeft],55
    MOV BYTE [CS:GO], 1

    MOV WORD [BP+2],exit_menu
    MOV WORD [BP+4],CS
    JMP NO_KEY

DF4: ;CUSTOM DIFFICULTY

    ; CALL CLR
    
    ; PUSH WORD 28
    ; PUSH WORD 10
    ; PUSH WORD 10
    ; PUSH custom
    ; CALL PRINT_STR

    ; MOV AH, 0X0
    ; INT 16H

    CMP AL, 0X0
    JL NO_KEY

    CMP AL, 0XA
    JG NO_KEY


    DEC AL
    MOV BL,8
    MUL BL
    MOV AH,0

    MOV BYTE [diff], 4
    MOV WORD [toRemove], AX
    MOV BYTE [countLeft], AL
    MOV BYTE [CS:GO], 1


    
    MOV WORD [BP+2],exit_menu
    MOV WORD [BP+4],CS
    JMP NO_KEY



entered:
    CMP WORD [cs:POINTER_Y], 56
    JE GUIDE_SCREEN

    CMP WORD [cs:POINTER_Y], 56+16
    JE DF1

    CMP WORD [CS:POINTER_Y], 56+32
    JE DF2 

    CMP WORD [CS:POINTER_Y], 56+48
    JE DF3

    ; CMP WORD [CS:POINTER_Y], 56+64
    ; JE DF4

    JMP NO_KEY

MENU_KEYBOARD:
    PUSH BP
    MOV BP,SP
    PUSH AX

    IN AL, 0x60
    CMP AL, 0x48
    JE KEY_UP

    CMP AL, 0x50
    JE KEY_DOWN

    ; CMP WORD [CS:POINTER_Y], 56+64
    ; JE DF4

    CMP AL, 0x1C
    JE entered
    
    call movingAcrossBoardSound
    

    JMP DF4
   

   NO_KEY:
    POP AX
    MOV SP,BP
    POP BP

    JMP FAR [cs:KBD]


IRET


PRINT_POINTER:

    ;CALL clear_320  
    CALL CLR

    ; mov ax, 0xa000
    ; mov es, ax
    ; call print_welcome_screen

    ;MOV WORD [POINTER_Y], 56


    PUSH WORD 100
    PUSH WORD [POINTER_Y]
    PUSH WORD 8
    PUSH WORD 8
    PUSH WORD 0X2
    PUSH LEFTT
    CALL printfont

    PUSH WORD 204
    PUSH WORD [POINTER_Y]
    PUSH WORD 8
    PUSH WORD 8
    PUSH WORD 0X2
    PUSH RIGHTT
    CALL printfont

;-------------------------------------
    PUSH WORD 9
    PUSH WORD 15
    PUSH WORD 7
    PUSH guide
    CALL PRINT_STR

    PUSH WORD 7
    PUSH WORD 16
    PUSH WORD 9
    PUSH ez
    CALL PRINT_STR

    PUSH WORD 11
    PUSH WORD 14
    PUSH WORD 11
    PUSH med
    CALL PRINT_STR

    PUSH WORD 7
    PUSH WORD 16
    PUSH WORD 13
    PUSH hd
    CALL PRINT_STR


    PUSH WORD 11
    PUSH WORD 14
    PUSH WORD 15
    PUSH cust
    CALL PRINT_STR

RET


CLR:
    PUSHA
    PUSH ES

    PUSH word 0xA000
    POP ES

    MOV AL, 0x02
    MOV DX, 0x3C4
    OUT DX, AL

    MOV AL, 0x0F
    MOV DX, 0x3C5
    OUT DX, AL

   MOV DI, 16000
XOr AX, AX
MOV CX, 24000

rEP STOSW

    POP ES
    POPA
RET

MENUU:

    ;CALL clear_320
    CALL CLR
    CALL PRINT_POINTER

    ;CALL clear_320

    JK:
        CMP BYTE [cs:GO], 0
        JE JK


    ;JMP $
    exit_menu:
    ;JMP MENFIS
RET



printnum: push bp 
 mov bp, sp 
 push es 
 push ax 
 push bx 
 push cx 
 push dx 
 push di 


 
 ;mov es, ax ; point es to video base 
 mov ax, [bp+4] ; load number in ax 
 mov bx, 10 ; use base 10 for division 
 mov cx, 0 ; initialize count of digits 
nextdigit: mov dx, 0 ; zero upper half of dividend 
 div bx ; divide by 10 
 add dl, 0x30 ; convert digit into ascii value 
 push dx ; save ascii value on stack 
 inc cx ; increment count of values 
 cmp ax, 0 ; is the quotient zero 
 jnz nextdigit ; if no divide it again 
 mov di, 0

    MOV AH,02h
    MOV BH,0
    MOV DH,07
    MOV DL,67
    INT 10h

 nextpos: 

    POP AX                                    ;LOAD CHARACTER TO DISPLAY
    MOV AH, 0Eh                                     ;DRAW AT CURSOR POSITION
    ;ADD AL, 48
    MOV BH, 0
    MOV BL, 0X4
    INT 10h


 loop nextpos ; repeat for all digits on stack

    call correctSound

 pop di 
 pop dx 
 pop cx 
 pop bx 
 pop ax 
 pop es 
 pop bp 
 ret 2 
