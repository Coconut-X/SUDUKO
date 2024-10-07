

[org 0x100]
jmp start

verticalOffset: dw 12
horizontalOffset: db 12
len: dw 10
temp: dw 82




;function to draw pixel in 640x480 16-color mode, x and y are passed on the stack


draw_horizontal_line:

    push bp;
    mov bp, sp;

    mov cx, [len]
    mov dl,[horizontalOffset]
    mov dh,[verticalOffset]

        iterator:
            mov ah,02h
            mov bh,0
            add dh,0
            add dl,1
            int 10h

            ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
            mov ax,0x0e00
            mov al, [bp+4] ; character ascii
            
            mov bx,12
            int 10h

            loop iterator
    
    mov sp, bp
    pop bp


    ret


draw_vertical_line:

    push bp;
    mov bp, sp;

    mov cx, [len]
    mov dl,[horizontalOffset]
    mov dh,[verticalOffset]

        iterato:
            mov ah,02h
            mov bh,0
            add dh,1
            add dl,0
            int 10h

            ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
            mov ax,0x0e00
            mov al, [bp+4] ; character ascii
            
            mov bx,12
            int 10h

            loop iterato
    
    mov sp, bp
    pop bp



ret

drawPixel:

    mov ah, 0x0c
    mov al,12 ;color
    mov bh, 0 ;page number
    mov cx, [horizontalOffset]
    mov dx, [verticalOffset]
    push dx

    mov dx,[temp]

    ;;draw len times pixel vertically



    drawPixelLoop:
        int 0x10
        sub dx, 1
       jnz drawPixelLoop

   
    ;int 0x10
ret


set_video_mode:
    mov ax, 0xa000   ; 640x480, 16-color mode
    mov es, ax
    int 0x10          ; Call BIOS interrupt to set video mode
    ret


start:
    mov ax, 0x13
    int 0x10
    call set_video_mode


;;drawing grid

push word 95
call draw_horizontal_line

; push word '.'
; call draw_vertical_line

;call drawPixel

call drawPixel
    

mov ax, 0x4c00
int 0x21






