%include "../include/io.mac"

section .data
    char1 db 0
    char2 db 0

    pos dd 0

    len_plain dd 0
    len_key dd 0
    key dd 0
    plain dd 0
    tabula_recta dd 0

section .text
    global beaufort
    extern printf

; void beaufort(int len_plain, char *plain, int len_key, char *key, char tabula_recta[26][26], char *enc) ;
beaufort:
    push ebp
    mov ebp, esp
    pusha

    mov eax, [ebp + 8]  ; len_plain
    mov [len_plain], eax
    mov eax, [ebp + 12] ; plain (address of first element in string)
    mov [plain], eax
    mov eax, [ebp + 16] ; len_key
    mov [len_key], eax
    mov eax, [ebp + 20] ; key (address of first element in matrix)
    mov [key], eax
    mov eax, [ebp + 24] ; tabula_recta
    mov [tabula_recta], eax
    mov esi, [ebp + 28] ; enc

    mov ecx, [len_plain]
    sub ecx, 1
    mov [pos], ecx
    
loop_string:
    ; edx = pos % len_key
    mov eax, [pos]
    xor edx, edx
    mov edi, [len_key]
    div edi
    
    ; char1 = plain[pos]
    mov ebx, [plain]
    mov ecx, [pos]
    mov al, [ebx + ecx]
    mov [char1], al

    ; char2 = key[edx]
    mov ebx, [key]
    mov al, [ebx + edx]
    mov [char2], al

    ; char1 = char1 - 'A'
    sub byte [char1], 'A'
    
    ; traverse tabula recta
    ; searching column is [char1]
    ; i go down the column until tabula_recta[line][char1] = char2 (the encryption key)
    
    xor ecx,ecx
    
find_in_tabula_recta:
    ; for each line, i search the element on tabula_recta + ecx*26 + [char1]

    ; eax = ecx*26 + [char1]
    mov eax, 26
    mul ecx
    xor edx,edx
    mov dl, [char1]
    add eax, edx

    ; ebx = tabula_recta + eax
    mov ebx, [tabula_recta]
    add ebx, eax

    ; check if tabula_recta[ecx][char1] = char2
    mov al, [ebx]
    mov dl, [char2]
    cmp al, dl
    je found_encryption

    ;check for loop ecx < 26
    inc ecx
    jmp find_in_tabula_recta

    ; i found the right line, so i take the first element from it 
found_encryption:
    ; eax = ecx*26
    mov eax, 26
    mul ecx

    ; edx = tabula_recta + eax
    mov edx, [tabula_recta]
    add edx, eax

    ; enc[pos] = tabula_recta[ecx][0]
    mov eax, [edx]
    mov edx, [pos]
    mov [esi + edx], al

    ; check loop [pos] >= 0
    sub [pos], dword 1
    cmp [pos], dword 0
    jge loop_string

    popa
    leave
    ret

