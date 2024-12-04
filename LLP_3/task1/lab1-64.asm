section .rodata
    fmt: dq "%lld ",  0

section .text
    extern scanf
    extern printf
    extern malloc
    extern free

global main
    ;n- [rbp-8]
    ;i-r12
    ;j-r13
    ;minI - r14
    ;tmp - r15
    
main:
    mov rbp, rsp; for correct debugging
    push rsi
    push rbp
    mov rbp, rsp; for correct debugging
    
    sub rsp, 8 + 32
    
    lea rcx, [fmt] 
    lea rdx, [rbp - 8] 
    call scanf
    
    mov rcx, 100
    call malloc
    mov rsi, rax
    mov r12, 0

start_in:                       
    cmp r12, [rbp-8]
    jge start_sort
    lea rcx, [fmt] 
    lea rdx, [rsi + r12*8] 
    call scanf
    
    add r12, 1
    jmp start_in
    
start_sort:
    mov r12, 0
    
outer_loop:
    cmp r12, [rbp-8]  ;if (i >= n - 1) goto print_array;
    jge start_out
    mov r14, r12    ;minIdx = i;
    mov r13, r12    ;j=i
    add r13, 1      ;j++
  
inner_loop:
    cmp r13, [rbp-8] ;if (j >= n) goto swap_elements;
    jge swap_elements
    mov rdi, [rsi + r13*8] ;arr[j]]
    cmp [rsi + r14*8], rdi  ;if (arr[minIdx] > arr[j]) goto inner_help;
    jg inner_help
    add r13, 1 ; j++
    jmp inner_loop ;goto inner_loop  
    
inner_help:
    mov r14, r13    ;minIdx = j
    add r13, 1      ;j++
    jmp inner_loop  ;goto inner_loop
    
swap_elements:
    cmp r13, r12    ;if (minIdx != i) goto start_swap;
    jne start_swap
    add r12, 1      ;i++
    jmp outer_loop  ;goto outer_loop
    
    
start_swap:  
    mov rbx, [rsi + r12*8]  ;temp = arr[i]
    mov rdi, [rsi + r14*8]
    
    mov [rsi + r12*8], rdi    ;arr[i] = arr[minIdx]
    mov [rsi + r14*8], rbx     ;arr[minIdx] = temp
    
    add r12, 1      ;i++
    jmp outer_loop      ;goto outer_loop
    
start_out:
    mov r12, 0 
    
print:    
    cmp r12, [rbp-8]
    jge end_out  
    lea rcx, [fmt]
    mov rdx, [rsi + r12*8] 
    call printf

    add r12, 1
    jmp print
end_out:
    mov rcx, rsi
    call free
            
    leave
    mov rbp, rsp
    pop rsi
    ret