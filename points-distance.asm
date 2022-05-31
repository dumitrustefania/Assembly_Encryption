%include "../include/io.mac"

struc point
    .x: resw 1
    .y: resw 1
endstruc

section .text
    global points_distance
    extern printf

points_distance:
    
    push ebp
    mov ebp, esp
    pusha

    mov ebx, [ebp + 8]      ; points
    mov eax, [ebp + 12]     ; distance
    
    ; make [eax],ecx,edx = 0
    mov dword [eax], 0
    xor ecx,ecx
    xor edx,edx

    ;move x1, x2 to ecx and edx
    mov cx, [ebx +point.x]
    mov dx, [ebx +point_size + point.x]

    ;if x1=x2
    cmp cx, dx
    je compute_dist_y

    ;compute x1-x2
    mov [eax], ecx
    sub [eax], edx
    jmp test_neg

;compute y1-y2
compute_dist_y:
    mov cx, [ebx +point.y]
    mov dx, [ebx +point_size + point.y]
    mov [eax], ecx
    sub [eax], edx

;if distance is negative make it positive
test_neg:
   cmp dword [eax],0
   jge end
   neg dword [eax]

end:

    popa
    leave
    ret