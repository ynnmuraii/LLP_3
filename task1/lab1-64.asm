%include "io64.inc"

section .bss:
    ; n, left, right, temp перенесем в стек
    arr resd 100

section .text:
    global main

main: 
    sub rsp, 32  ; выделяем место в стеке для переменных n, left, right, temp (по 8 байт на каждую)
    lea rax, [rsp + 0] ; адрес переменной n
    GET_UDEC 4, [rax]
    mov eax, [rsp + 0]  ; значение n
    cmp eax, 100
    jg end_program 
    cmp eax, 0
    jle end_program 

    mov ecx, 0 
    
input_loop:
    cmp ecx, [rsp + 0]  ; сравнение с n
    jge sort_start
    lea rax, [arr + ecx*4]
    GET_UDEC 4, [rax]
    inc ecx 
    jmp input_loop

sort_start:
    mov dword [rsp + 8], 0  ; left = 0
    mov eax, [rsp + 0]  ; eax = n
    dec eax
    mov dword [rsp + 16], eax ; right = n - 1

sorting_loop:
    mov eax, [rsp + 8]  ; left
    mov ebx, [rsp + 16] ; right
    cmp eax, ebx
    jge sort_end 
    
    mov ecx, [rsp + 8]  ; left 
    
first_loop_start:
    mov ebx, [rsp + 16] ; right
    cmp ecx, ebx 
    jge first_loop_end

    mov edx, [arr + ecx*4]
    mov esi, [arr + ecx*4 + 4] 
    cmp edx, esi 
    jle no_swap1 

    mov [rsp + 24], edx ; temp = arr[ecx]
    mov [arr + ecx*4], esi
    mov [arr + ecx*4 + 4], edx 

no_swap1:
    inc ecx 
    jmp first_loop_start
    
first_loop_end:
    dec dword [rsp + 16]  ; right--
    mov ecx, [rsp + 16]   ; обновляем значение ecx
    
second_loop_start:
    mov eax, [rsp + 8]  ; left
    cmp ecx, eax 
    jle second_loop_end 

    mov edx, [arr + ecx*4]
    mov esi, [arr + ecx*4 - 4]
    cmp esi, edx 
    jle no_swap2 

    mov [rsp + 24], edx ; temp = arr[ecx]
    mov [arr + ecx*4], esi
    mov [arr + ecx*4 - 4], edx

no_swap2:
    dec ecx  
    jmp second_loop_start
    
second_loop_end:
    inc dword [rsp + 8]  ; left++
    jmp sorting_loop 

sort_end:
    mov ecx, 0  
    
output_loop:
    cmp ecx, [rsp + 0]  ; сравнение с n
    jge end_program 

    mov eax, [arr + ecx*4]
    PRINT_DEC 4, eax 
    PRINT_STRING " "
    inc ecx 
    jmp output_loop

end_program:
    add rsp, 32  ; освобождаем стек
    NEWLINE
    RET
