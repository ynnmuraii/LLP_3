%include "io64.inc"

section .bss:
    n resd 1
    left resd 1
    right resd 1
    temp resd 1
    arr resd 100

section .text:
    global main

main: 
    GET_UDEC 4, [n]
    mov eax, [n]
    cmp eax, 100
    jg end_program 
    cmp eax, 0
    jle end_program 

    mov ecx, 0 
    
input_loop:
    cmp ecx, [n]
    jge sort_start
    GET_UDEC 4, [arr + ecx*4]
    inc ecx 
    jmp input_loop

sort_start:
    mov dword [left], 0
    mov eax, [n]
    dec eax
    mov dword [right], eax

sorting_loop:
    mov eax, [left]
    mov ebx, [right]
    cmp eax, ebx
    jge sort_end 
    
    mov ecx, [left] 
    
first_loop_start:
    mov ebx, [right]
    cmp ecx, ebx 
    jge first_loop_end


    mov edx, [arr + ecx*4]
    mov esi, [arr + ecx*4 + 4] 
    cmp edx, esi 
    jle no_swap1 


    mov [temp], edx 
    mov [arr + ecx*4], esi
    mov [arr + ecx*4 + 4], edx 

no_swap1:
    inc ecx 
    jmp first_loop_start
    
first_loop_end:
    dec dword [right] 
    mov ecx, [right]
    
second_loop_start:
    mov eax, [left]
    cmp ecx, eax 
    jle second_loop_end 

    mov edx, [arr + ecx*4]
    mov esi, [arr + ecx*4 - 4]
    cmp esi, edx 
    jle no_swap2 

    mov [temp], esi 
    mov [arr + ecx*4 - 4], edx
    mov [arr + ecx*4], esi

no_swap2:
    dec ecx  
    jmp second_loop_start
    
second_loop_end:
    inc dword [left] 
    jmp sorting_loop 

sort_end:
    mov ecx, 0  
    
output_loop:
    cmp ecx, [n] 
    jge end_program 

    mov eax, [arr + ecx*4]
    PRINT_DEC 4, eax 
    PRINT_STRING " "
    inc ecx 
    jmp output_loop

end_program:
    NEWLINE
    RET