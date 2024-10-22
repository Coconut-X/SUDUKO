[org 0x100]

jmp start

str: db "G A M E   O V E R", 0
mistakes: db "MISTAKES:",0
time: db "TIME:",0
score: db "SCORE:",0
playagain: db "PLAY AGAIN",0



clear_screen:
    mov ah, 0x06
    mov al, 0
    mov bh, 0x0
    mov cx, 0x0000
    mov dx, 0x184F
    int 0x10
    ret


display_text:

    push bp
    mov bp, sp
    pusha

    mov ax, 0xb800
    mov es, ax

   
    mov si, [bp + 6]                                            ; Address of the string
    mov di, [bp + 4]                                            ; Starting byte (offset in video memory)

    print:
        lodsb                                                   ; Load a byte (character) from the string into AL
        or al, al                                               ; Check if the character is zero (end of string)
        jz halt                                                 ; If zero, jump to halt
        mov ah, 0x01                                            ; Set the attribute (white text on black background)
        mov [es:di], ax                                         ; Store the character and attribute at the video memory location
        add di, 2                                               ; Move to the next character position (2 bytes for character and attribute)
        jmp print                                               

    halt:
        popa
        mov sp, bp
        pop bp
RET 4              


start:

    call clear_screen

    MOV AL,0x0
    MOV dx,0x3c8
    out dx,al
    mov dx,0x3c9

   

    ;baby pink
    mov al,63
    out dx,al
    mov al,49
    out dx,al
    mov al,55
    out dx,al

     ;ORANGE
    mov al,63
    out dx,al
    mov al,28
    out dx,al
    mov al,16
    out dx,al

    push str
    push 1822
    call display_text

    push mistakes
    push 3202
    call display_text

    push time
    push 3362
    call display_text

    push score
    push 3450-120
    call display_text

    push playagain
    push 1822+1440+160+160
    call display_text



ret

