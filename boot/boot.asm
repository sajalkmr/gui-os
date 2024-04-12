[org 0x00]
[bits 16]

section code

.init:
    mov eax, 0x07c0
    mov ds, eax
    mov eax, 0xb800
    mov es, eax
    mov eax, 0; set eax to 0-> i=0
    mov ebx, 0 ; index of current character in the string to be printed
    mov ecx, 0 ; actual addresss of the character on screen
    mov dl, 0 ; actual value of the character to be printed


.clear:
    mov byte [es:eax], 0; Move blank character to current text address
    inc eax
    mov byte [es:eax], 0x20; Move the bg color n character to next address
    inc eax

    cmp eax, 2 * 25 * 80

    jl .clear

mov eax, text2
mov ecx,  3 * 2 * 80
push .end
call .print

.end:
    mov byte [es:0x00], 'L'
    jmp $

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



text: db 'Hello, World!', 0
text2: db 'This is a test', 0

times 510 - ($ - $$) db 0x00 ; Pads file with 0s, to make it 512 bytes

db 0x55
db 0xaa