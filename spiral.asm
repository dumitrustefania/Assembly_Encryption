%include "../include/io.mac"
section .data
    N dd 0
    plain dd 0
    key dd 0

    pos dd 0
    i dd 0
    j dd 0
    k dd 0

section .text
    global spiral
    extern printf

;void encrypt(int key_pos, char *enc)
encrypt:
    push ebp
    mov ebp, esp
    pusha

    mov eax, [ebp + 8]  ; key_pos
    mov esi, [ebp + 12] ; enc_string (address of first element in string)
    
    ; encrypt with key[eax]
    ; multiply eax with 4 because key has ints
    mov ebx, [key]
    mov edx, [ebx +eax*4] ; key that is added to the character in plain string
    
    mov ecx, [pos] ; position of the character i will modify
    mov ebx, [plain]
    add ebx, [pos] ; [ebx] = character plain[pos]

    mov eax, [ebx]
    add eax, edx ; eax = plain[pos] + edx
    mov [esi + ecx], al ; enc[pos] = eax
    
    inc dword [pos] ; increase string iterator

    popa
    leave
    ret

; void spiral(int N, char *plain, int key[N][N], char *enc_string);
spiral:
    push ebp
    mov ebp, esp
    pusha

    mov eax, [ebp + 8]  ; N (size of key line)
    mov [N], eax
    mov eax, [ebp + 12] ; plain (address of first element in string)
    mov [plain], eax
    mov eax, [ebp + 16] ; key (address of first element in matrix)
    mov [key], eax
    mov esi, [ebp + 20] ; enc_string (address of first element in string)

    mov eax, [N]
    sub eax, 1
    mov [i], eax
    mov [j], dword 0
    mov [pos], dword 0


loop_square:
;-------------------loop first row from the remaining rows
    ; k = j
    mov eax, [j]
    mov [k], eax

    ; if k >= i
    mov eax, [i]
    cmp [k], eax
    jge loop_last_column

first_row:
    ; eax = j*N + k
    mov eax, [j]
    mul dword [N]
    add eax, [k]
    
    ; encrypt character plain[pos] with key eax
    push esi
    push eax
    call encrypt
    add esp, 8

    ; while k < i
    inc dword [k]
    mov eax, [i]
    cmp [k], eax
    jl first_row 

;-------------------loop last column from the remaining columns

loop_last_column:
    ; k = j
    mov eax, [j]
    mov [k], eax

    ; if k >= i
    mov eax, [i]
    cmp [k], eax
    jge loop_last_row

last_column:
    ; eax = k*N + i
    mov eax, [k]
    mul dword [N]
    add eax, [i]
    
    ; encrypt character plain[pos] with key eax
    push esi
    push eax
    call encrypt
    add esp, 8

    ; while k < i
    inc dword [k]
    mov eax, [i]
    cmp [k], eax
    jl last_column 

;-------------------loop last row from the remaining rows

loop_last_row:
    ; k = i
    mov eax, [i]
    mov [k], eax

    ; if k <= j
    mov eax, [j]
    cmp [k], eax
    jle loop_first_column

last_row:
    ; eax = i*N + k
    mov eax, [i]
    mul dword [N]
    add eax, [k]
    
    ; encrypt character plain[pos] with key eax
    push esi
    push eax
    call encrypt
    add esp, 8

    ; while k < i
    dec dword [k]
    mov eax, [j]
    cmp [k], eax
    jg last_row 

;-------------------loop first column from the remaining columns
loop_first_column:
    ; k = i
    mov eax, [i]
    mov [k], eax

    ; if k <= j
    mov eax, [j]
    cmp [k], eax
    jle check_loop

first_column:
    ; eax = k*N + j
    mov eax, [k]
    mul dword [N]
    add eax, [j]
    
   ; encrypt character plain[pos] with key eax
    push esi
    push eax
    call encrypt
    add esp, 8

    ; while k < i
    dec dword [k]
    mov eax, [j]
    cmp [k], eax
    jg first_column 


check_loop:
    ; check i > 0
    dec dword [i]
    inc dword [j]
    cmp [i], dword 0
    jg loop_square

; if n is odd, make sure i also print the 
; middle element in the matrix key[(n-1)/2][(n-1)/2]

    test dword [N], 1
    JP end

    xor edx, edx
    mov ecx, [N]
    dec ecx
    mov eax, ecx
    mov ecx, 2
    div ecx
    mov ecx, eax ; edx = (n-1)/2
    
    mul dword [N]
    add eax, ecx ; eax = (n-1)*2 * n + (n-1) / 2
    
    ; encrypt character plain[pos] with key eax
    push esi
    push eax
    call encrypt
    add esp, 8

end:
    mov ecx, [pos]
    mov [esi + ecx], byte 0 ; enc[pos] = '\0'

    popa
    leave
    ret
