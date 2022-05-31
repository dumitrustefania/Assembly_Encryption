%include "../include/io.mac"
section .data
    pos dd 0
    len dd 0
    pos2 dd 0
section .text
    global is_square
    extern printf
    
; function to check if a number is a square root
is_square_root:
    push ebp
    mov ebp, esp
    pusha

    mov esi, [ebp + 8]      ; 1 or 0
    mov edi, [ebp + 12]     ; nr

    mov edx, 0

loop_square:
    ; save edx bcs mul ruins it 
    push edx

    ; eax = edx ^ 2
    mov eax, edx
    mul edx

    ; restore edx
    pop edx

    inc edx

    ; if edx^2 < number, continue looping
    cmp eax, edi
    jl loop_square

    ; we got here, so edx^2 >= number
    ; if edx^2 == number => number is square root
    mov dword [esi], 1
    je end
    ; otherwhise, it is not
    mov dword [esi], 0

end:
    popa
    leave
    ret

is_square:
    push ebp
    mov ebp, esp
    pusha

    mov ebx, [ebp + 8]      ; dist
    mov eax, [ebp + 12]     ; nr
    mov ecx, [ebp + 16]     ; sq
   
    mov [len], eax
    mov dword [pos], 0
    
; loop the distances array
loop_array:
    ; eax = 4 * pos
    mov eax, 4
    mov edx, [pos]
    mul edx

    ; edx = ebx + 4 * pos => edx is element at position pos
    mov edx, ebx
    add edx, eax
    
    ; call function to check if element at position pos
    ; is a square root and store the answer in esi
    push dword [edx]
    push esi
    call is_square_root
    add esp, 8

    ; esi is now 0 or 1
    ; add esi to the array at position pos
    mov edx, [pos]
    mov eax, [esi]
    mov [ecx + edx*4], eax

    ; check if i have to exit loop
    inc dword [pos]
    mov eax, [len]
    cmp dword [pos], eax
    jl loop_array
    
    popa
    leave
    ret
