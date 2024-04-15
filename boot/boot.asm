[org 0x7c00]
[bits 16]

section code





.switch:
    mov bx, 0x1000 ; load from hdd
    mov ah, 0x02 ; read sectors
    mov al, 30 ; read 30 sectors
    mov ch, 0x00 ; cylinder 0
    mov dh, 0x00 ; head 0
    mov cl, 0x02 ; sector 2
    int 0x13 ; call bios



    cli ; clear interrupts
    lgdt [gdt_descriptor] ; load the gdt table

    mov eax, cr0
    or eax, 0x1
    mov cr0, eax ; enable protected mode

    jmp code_seg:protected_mode


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

    call 0x1000 ; call the kernel
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