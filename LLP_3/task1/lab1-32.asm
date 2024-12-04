section .rodata
    fmt: dq "%d ",  0

section .text
    extern scanf
    extern printf
    extern malloc
    extern free

global main
    
main:
    push esi
    push ebx
    push ebp
    
    mov ebp, esp
    
    sub esp, 4 + 8


    lea eax, [fmt]
    mov [esp], eax
    lea eax, [ebp - 4]
    mov [esp + 4], eax
    call scanf
    
    mov dword[esp], 100
    call malloc
    mov esi, eax
    
    mov ebx, 0

start_in:                       
    cmp ebx, [ebp-4]
    jge start_sort
    lea eax, [fmt]
    mov [esp], eax
    lea eax, [esi + ebx*4] 
    mov [esp + 4], eax
    call scanf
    
    add ebx, 1
    jmp start_in

start_sort:
    mov ebx, 0
    
outer_loop:
    cmp ebx, [ebp-8]        ;if (i >= n - 1) goto print_array;
    jge start_out
    mov edx, ebx            ;minIdx = i;
    mov ecx, ebx            ;j=i
    add ecx, 1              ;j++
  
inner_loop:
    cmp ecx, [ebp-4]        ;if (j >= n) goto swap_elements;
    jge swap_elements
    mov edi, [esi + ecx*4]  ;arr[j]]
    cmp [esi + edx*4], edi  ;if (arr[minIdx] > arr[j]) goto inner_help;
    jg inner_help
    add ecx, 1              ; j++
    jmp inner_loop          ;goto inner_loop  
    
inner_help:
    mov edx, ecx            ;minIdx = j
    add ecx, 1              ;j++
    jmp inner_loop          ;goto inner_loop
    
swap_elements:
    cmp edx, ecx            ;if (minIdx != i) goto start_swap;
    jne start_swap
    add ebx, 1              ;i++
    jmp outer_loop          ;goto outer_loop
    
    
start_swap:  
    
    mov edi, [esi + ebx*4]
    mov [ebp-8], edi
    mov edi, [esi + edx*4]
    mov [esi+ ebx*4], edi
    mov edi, dword[ebp-8]
    mov [esi+edx*4], edi    
    add ebx, 1              ;i++
    jmp outer_loop          ;goto outer_loop


start_out: 
    mov ebx, 0
    
print:    
    cmp ebx, [ebp-4]
    jge end_out  
    lea eax, [fmt]
    mov [esp], eax
    mov eax, [esi + ebx*4] 
    mov [esp + 4], eax
    call printf
    add ebx, 1
    jmp print
    
end_out:
        
    mov [esp], esi
    call free
            
    leave
    mov ebp, esp
    pop ebx
    pop esi
    ret