org 0x0100  ; Origin for COM file

jmp START   ; Jump to the start of the program

; Data section
timer db 10 ; Timer starts from 10

START:

    ;clead screen using loop

    ; mov ax,0xb800
    ; mov es,ax
    ; mov si,0

    ; mov cx,4000
    ; clr:

    ;     mov ax,0720h
    ;     mov bh,00
    ;     mov word[es:si],ax
    ;     add si,2
    ;     loop clr


        


    mov cx, 10           ; Set countdown from 10 seconds
    call DisplayTimer    ; Display the initial timer value
    
CountdownLoop:
    call DelayOneSecond  ; Wait for 1 second
    dec cx               ; Decrement the timer
    call DisplayTimer    ; Display the updated timer value
    jnz CountdownLoop    ; If not zero, keep looping

Exit:
    mov ax, 0x4c00       ; Terminate the program
    int 0x21             ; DOS interrupt to terminate the program

; Subroutine to display the current timer value
DisplayTimer:
    ; ; Clear the screen (optional)
    ; mov ah, 0x02
    ; mov bh, 0x00
    ; mov dh, 0x00
    ; mov dl, 0x00
    ; int 0x10              ; BIOS interrupt to move the cursor to top-left (clear screen)
    
    ; Convert the timer value to ASCII and display it
    mov ax, cx            ; Load the current timer value
    add al, '0'           ; Convert the number to ASCII
    mov ah, 0x0e          ; BIOS teletype function to display character
    int 0x10              ; Interrupt to display character
    ret

; Subroutine to wait for 1 second
DelayOneSecond:
    mov dx, 0x3e8         ; Delay count for 1 second (1000ms)
    call DelayMS
    ret

; Subroutine to delay for a specific number of milliseconds
DelayMS:
    push cx               ; Save CX register
    mov cx, dx            ; Load DX (delay in ms) into CX
DelayLoop:
    ; Inner loop to wait
    mov dx, 0xffff
    delay_inner_loop:
        dec dx
        jnz delay_inner_loop
    loop DelayLoop        ; Decrement CX and loop until 0
    pop cx                ; Restore CX register
    ret
