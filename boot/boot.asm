[org 0x00]
[bits 16]

section code

.init:
    mov eax, 0x07c0
    mov eax, 0xb800
    mov es, eax
    mov eax, 0; set eax to 0-> i=0
    mov ebx, 0 ; 
    mov ecx, 0
    mov dl, 0


.clear:
    mov byte [es:eax], 0; Move blank character to current text address
    inc eax
    mov byte [es:eax], 0x20; Move the bg color n character to next address
    inc eax

    cmp eax, 2 * 25 * 80

    jl .clear

.main:

    mov byte [es:0x00], 'H' ; 0xb800 + 0x00 = 0xb800
    mov byte [es:0x01], 0x20 

jmp $

times 510 - ($ - $$) db 0x00 ; Pads file with 0s, to make it 512 bytes

db 0x55
db 0xaa