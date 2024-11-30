[org 0x100]               ; Origin of the program

jmp start

video_offset dw 0         ; Video memory offset for current pixel

start:
    ; Set video mode to 13h (320x200 256-color)
    mov ax, 0x13
    int 0x10

firework_loop:
    call firework        ; Call the firework animation subroutine
    call delay           ; Add delay between fireworks
    jmp firework_loop    ; Loop back to the start for the next firework

firework:
    ; Draw the firework launch (vertical line moving upwards)
    mov cx, 150          ; Set the initial Y position
launch_loop:
    call draw_pixel      ; Draw the "rocket" at current position
    call delay           ; Small delay for animation effect
    call clear_pixel     ; Clear the previous pixel
    loop launch_loop     ; Loop until the rocket reaches the top

    ; Now simulate an explosion at the top
    call explode
    ret

explode:
    ; Draw outward lines from the center to simulate an explosion
    mov cx, 100          ; Number of explosion particles
explode_loop:
    call draw_explosion_particle
    loop explode_loop
    ret

draw_pixel:
    ; Draw a pixel at (x, y) position
    mov di, [video_offset]   ; DI = video memory offset based on x, y
    mov al, 0x0F             ; Color for the firework (white)
    mov es:[di], al          ; Write to video memory
    ret

clear_pixel:
    ; Clear the pixel at the current position (reset to background color)
    mov di, [video_offset]   ; Calculate the same offset
    mov al, 0x00             ; Background color (black)
    mov es:[di], al          ; Clear the pixel
    ret

; draw_explosion_particle:
;     ; Draw one explosion particle (random direction)
;     ; You would calculate random directions and plot pixels based on that
;     ; Simulate by drawing random pixels in the surrounding area
;     mov di, [video_offset]   ; Calculate video offset for explosion
;     mov al, 0x0F             ; White color for explosion particle
;     mov es:[di], al          ; Write pixel to video memory
;     ret

draw_explosion_particle:
    ; Draw explosion particles randomly
    ; Calculate random directions for particles
    mov ax,  40      ; Get a random value for x and y
    mov di, [video_offset]    ; Calculate the video memory offset
    mov al, 0x0F              ; Color (white for explosion)
    mov es:[di], al           ; Write the pixel
    ret


delay:
    ; Simple delay loop for animation effect
    mov cx, 0xFFFF
delay_loop:
    nop                      ; No operation (wastes time)
    loop delay_loop
    ret

set_palette:
    ; Set color palette for fireworks (optional, based on your needs)
    ret

exit:

    ;jmp start
    ; Reset video mode to text mode (03h)
    mov ax, 0x03
    int 0x10
    mov ax, 0x4C00
    int 0x21
