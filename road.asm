%include "../include/io.mac"
struc point
    .x: resw 1
    .y: resw 1
endstruc

section .data
    len dd 0
    pos dd 0
    dist dd 0
    
section .text
    global road
    extern printf
    extern points_distance

road:
    push ebp
    mov ebp, esp
    pusha

    mov esi, [ebp + 8]      ; points
    mov ecx, [ebp + 12]     ; len
    mov ebx, [ebp + 16]     ; distances

    mov [len], ecx
    sub dword [len], 1
    mov dword [pos],0

loop_array: 
    ; eax = point_size*edi +point.y
    mov eax, point_size
    mul dword [pos]

    ; go to element on position pos in array
    ; by adding eax to esi
    mov edi, esi
    add edi, eax
    
    ; compute distace from element on edi to the next one
    push dist
    push edi
    call points_distance
    add esp, 8
    
    ; save distance between point[pos] and point[pos+1]
    ; in distances array on position pos
    mov ecx, [pos]
    mov edx, [dist]
    mov [ebx + ecx*4], edx

    ; check if i have to exit loop
    inc dword [pos]
    mov ecx, [len]
    cmp dword [pos], ecx
    jl loop_array

    popa
    leave
    ret
