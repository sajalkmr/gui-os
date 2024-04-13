[org 0x7c00]
[bits 16]

section code

.init:
    
    mov eax, 0xb800
    mov es, eax
    mov eax, 0; set eax to 0-> i=0
    mov ebx, 0 ; index of current character in the string to be printed
    mov ecx, 0 ; actual addresss of the character on screen
    mov dl, 0 ; actual value of the character to be printed


.clear:
    mov byte [es:eax], 0; Move blank character to current text address
    inc eax
    mov byte [es:eax], 0xD0; Move the bg color n character to next address
    inc eax

    cmp eax, 2 * 25 * 80

    jl .clear

mov eax, welcome
mov ecx,  0 * 2 * 80

call .print

jmp .switch


.print:
    mov dl, byte[eax + ebx]

    cmp dl, 0
    je .print_end

    mov byte [es:ecx], dl

    inc ebx
    inc ecx
    inc ecx

    jmp .print

.print_end:
    ret

.switch:
    cli ; clear interrupts
    lgdt [gdt_descriptor] ; load the gdt table

    mov eax, cr0
    or eax, 0x1
    mov cr0, eax ; enable protected mode

    jmp protected_mode


welcome: db 'Welcome to my OS!', 0

[bits 32]
protected_mode:
    mov ax, data_seg
    mov ds, ax
    mov ss, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

    ; update stack pointer
    mov ebp, 0x90000
    mov esp, ebp

    jmp $

gdt_begin:
gdt_null_descriptor:
    dd 0x00
    dd 0x00
gdt_code_seg:
    dw 0xffff
    dw 0x00
    db 0x00
    db 10011010b
    db 11001111b
    db 0x00
gdt_data_seg:
    dw 0xffff
    dw 0x00
    db 0x00
    db 10010010b
    db 11001111b
    db 0x00
gdt_end:
gdt_descriptor:
    dw gdt_end - gdt_begin - 1
    dd gdt_begin

code_seg equ gdt_code_seg - gdt_begin
data_seg equ gdt_data_seg - gdt_begin

times 510 - ($ - $$) db 0x00 ; Pads file with 0s, to make it 512 bytes

db 0x55
db 0xaa