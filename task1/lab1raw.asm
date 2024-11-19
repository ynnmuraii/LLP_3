%include "io64.inc"

section .rodata:
    fmt: db "%u", 0
    fmt_out: db "%u ", 0

section .bss:
    arr resd 100

section .text:
    global main

extern scanf, printf
extern malloc, free
main:
    push rbp
    mov rbp, rsp
    sub rsp, 16            ; Выделяем место под локальные переменные n, left, right, temp

    sub rsp, 4+32          ; Замена GET_UDEC
    lea rcx, [fmt]
    lea rdx, [rbp-16]
    call scanf
    
    mov eax, [rbp-16]
    cmp eax, 100
    jg end_program 
    cmp eax, 0
    jle end_program 

    mov ecx, 0 
    
input_loop:
    cmp ecx, [rbp-16]      ; cmp ecx, n
    jge sort_start
    
    GET_UDEC 4, [arr + ecx*4]
    inc ecx 
    jmp input_loop

sort_start:
    mov dword [rbp-12], 0  ; left = 0
    mov eax, [rbp-16]      ; eax = n
    dec eax
    mov dword [rbp-8], eax ; right = n - 1

sorting_loop:
    mov eax, [rbp-12]      ; eax = left
    mov ebx, [rbp-8]       ; ebx = right
    cmp eax, ebx
    jge sort_end 
    
    mov ecx, [rbp-12]      ; ecx = left
    
first_loop_start:
    mov ebx, [rbp-8]       ; ebx = right
    cmp ecx, ebx 
    jge first_loop_end

    mov edx, [arr + ecx*4]
    mov esi, [arr + ecx*4 + 4] 
    cmp edx, esi 
    jle no_swap1 

    mov [rbp-4], edx       ; temp = edx
    mov [arr + ecx*4], esi
    mov [arr + ecx*4 + 4], edx 

no_swap1:
    inc ecx 
    jmp first_loop_start
    
first_loop_end:
    dec dword [rbp-8]      ; right--
    mov ecx, [rbp-8]       ; ecx = right
    
second_loop_start:
    mov eax, [rbp-12]      ; eax = left
    cmp ecx, eax 
    jle second_loop_end 

    mov edx, [arr + ecx*4]
    mov esi, [arr + ecx*4 - 4]
    cmp esi, edx 
    jle no_swap2 

    mov [rbp-4], esi       ; temp = esi
    mov [arr + ecx*4 - 4], edx
    mov [arr + ecx*4], esi

no_swap2:
    dec ecx  
    jmp second_loop_start
    
second_loop_end:
    inc dword [rbp-12]     ; left++
    jmp sorting_loop 

sort_end:
    mov ecx, 0  
    
output_loop:
    cmp ecx, [rbp-16]      ; cmp ecx, n
    jge end_program 

    mov eax, [arr + ecx*4]
    PRINT_DEC 4, eax 
    PRINT_STRING " "
    inc ecx 
    jmp output_loop

end_program:
    NEWLINE
    mov rsp, rbp
    pop rbp
    RET