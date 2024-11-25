

DELAY:  ;delay of 1/18.2 seconds
        push bp
        mov bp, sp
        push cx
        push ax

        DF_l1:                              ;outer loop
            cmp word[bp+4], 0
            je DF_end
            mov ax, 0x0001
            DF_l2:
            mov cx, 0xFFFF
                DS_l3: loop DS_l3           ;inner loop
            dec ax
            jnz DF_l2
            dec word[bp+4]
            jmp DF_l1
        DF_end:
        pop ax
        pop cx
        pop bp
        ret 2
sound:
        ;load the counter 2 value for d3
        ;push bx

        PUSH BP
        MOV BP, SP
        PUSHA

        out 42h, al
        mov al, ah
        out 42h, al
        
        ;turn the speaker on
        in al, 61h
        mov ah,al
        or al, 3h
        out 61h, al
        mov bx, 5

        mov bx,[bp+4]

        push bx
        call DELAY
        
        mov al, ah
        out 61h, al

        POPA
        MOV SP, BP
        POP BP
        ret 2

        ;pop bx
        ret
PlayCollect:
        push ax

        ; mov ax, 1522 ; G5
        ; call sound
        ; mov ax, 1522 ; G5
        ; call sound
        ; mov ax, 1522 ; G5
        ; call sound
        ; mov ax, 1522 ; G5
        ; call sound
        ; mov ax, 1522 ; G5
        ; call sound
        ; mov ax, 1522 ; G5
        ; call sound
       

        ; mov ax, 1612 ;f5#
        ; call sound
        ; mov ax, 1612 ;f5#
        ; call sound
        ; mov ax, 1612 ;f5#
        ; call sound
        ; mov ax, 1612 ;f5#
        ; call sound
        ; mov ax, 1612 ;f5#
        ; call sound
        ; mov ax, 1612 ;f5#
        ; call sound
        

        ; mov ax, 1810 ;e5
        ; call sound
        ; mov ax, 1810 ;e5
        ; call sound
        ; mov ax, 1810 ;e5
        ; call sound
        ; mov ax, 1810 ;e5
        ; call sound
        ; mov ax, 1810 ;e5
        ; call sound
        ; mov ax, 1810 ;e5
        ; call sound

        ; mov ax, 2282 ; C5
        ; call sound
        ; mov ax, 2282 ; C5
        ; call sound
        ; mov ax, 2282 ; C5
        ; call sound
        ; mov ax, 2282 ; C5
        ; call sound
        ; mov ax, 2282 ; C5
        ; call sound
        ; mov ax, 2282 ; C5
        ; call sound



        ; mov ax, 1356 ;a5
        ; call sound
        ; mov ax, 1356 ;a5
        ; call sound
        ; mov ax, 1356 ;a5
        ; call sound
        ; mov ax, 1356 ;a5
        ; call sound
        ; mov ax, 1356 ;a5
        ; call sound
        ; mov ax, 1356 ;a5
        ; call sound


        ;BAREEK AAWAAZ
        ; mov ax,0600
        ; call sound
        ; mov ax,0600
        ; call sound
        ; mov ax,0600
        ; call sound
        ; mov ax,0600
        ; call sound
        ; mov ax,0600
        ; call sound
        ; mov ax,0600
        ; call sound

        ; mov ax,0300
        ; call sound
        ; mov ax,0300
        ; call sound
        ; mov ax,0300
        ; call sound



        mov ax,7000
        call sound
        mov ax,7000
        call sound
        mov ax,7000
       
      

        
         
                 



        ; mov ax, 1356 ;a5
        ; call sound
        ; mov ax, 1612 ;f5#
        ; call sound
        ; mov ax, 1612 ;f5#
        ; call sound
        ; mov ax, 1810 ;e5
        ; call sound
        ; mov ax, 1612 ;f5#
        ; call sound
        ; mov ax, 1810 ;e5
        ; call sound
        ; mov ax, 2032 ;d5
        ; call sound
        ; mov ax, 2032 ;d5
        ; call sound
        ;  mov ax, 2032 ;d5
        ; call sound
        ; mov ax, 1208 ;b5
        ; call sound
        ; mov ax, 1356 ;a5
        ; call sound
        ; mov ax, 1612 ;f5#
        ; call sound
        ; mov ax, 1612 ;f5#
        ; call sound
        ; mov ax, 1810 ;e5
        ; call sound
        ; mov ax, 1810 ;e5
        ; call sound
        ; mov ax, 1810 ;e5
        ; call sound
        ; mov ax, 1810 ;e5
        ; call sound
        ; mov ax, 2416 ;b4
        ; call sound
        ; mov ax, 2416 ;b4
        ; call sound
        ; mov ax, 2032 ;d5
        ; call sound
        ; mov ax, 1810 ;e5
        ; call sound
        ; mov ax, 1612 ;f5#
        ; call sound
        ; mov ax, 1810 ;e5
        ; call sound
        ; mov ax, 2032 ;d5
        ; call sound
        ; mov ax, 1612 ;f5#
        ; call sound
        pop ax
        ret


incorrectSound:
        push ax

        mov ax,7000
        PUSH 3
        call sound

        mov ax,7000
        PUSH 10
        call sound
        mov ax,7000

        pop ax
        ret


correctSound:
        push ax

        mov ax, 1522 ; G5
        PUSH 5
        call sound
        ;mov ax, 1522 ; G5

        pop ax
        ret

buttonPressedSound:
        push ax

        mov ax, 700
        PUSH 10
        call sound

        pop ax
        ret


movingAcrossBoardSound:
        push ax

        mov ax, 8000
        PUSH 3
        call sound

        pop ax
        ret



; abc:

;     mov ax,00
;     int 16h
;     ;call movingAcrossBoardSound
;     call incorrectSound

;     mov ax,00
;     int 16h
;     call correctSound

;     jmp abc
    

