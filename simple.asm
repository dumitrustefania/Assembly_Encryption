%include "../include/io.mac"

section .text
    global simple
    extern printf

simple:
    push    ebp
    mov     ebp, esp
    pusha

    mov     ecx, [ebp + 8]  ; len
    mov     esi, [ebp + 12] ; plain
    mov     edi, [ebp + 16] ; enc_string
    mov     edx, [ebp + 20] ; step

; loop plain string
loop_string:
    ; move character on position ecx-1 in eax register
    xor eax, eax
    mov al, [esi + ecx-1]
    
    ; add to the character the no of steps required
    add eax, edx
    ; check if character is still in interval A-Z
    cmp eax, 'Z'
    jle modify
    ; if character > Z, bring it back to the interval circularly
    sub eax, 26

modify:
    ; add encrypted character to enc_string
    mov [edi+ecx-1], al
    loop loop_string

    popa
    leave
    ret
