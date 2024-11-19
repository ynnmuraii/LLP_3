%include "io64.inc"
section .rodata:
    fmt: db "%u", 0
section .bss:
    arr resd 100             ; Массив остается в памяти

section .text:
    global main

main:
    push rbp
    mov rbp, rsp
    
    sub rsp, 4+32
    
    lea rcx, [fmt]
    lea rdx, [rbp-4]
    call scanf
    mov ebx, [rbp-4]
  
    cmp ebx, 100             ; Если n > 100, завершаем
    jg end_program
    cmp ebx, 0               ; Если n <= 0, завершаем
    jle end_program

    xor esi, esi             ; ecx = 0 (счетчик для ввода массива)
    
input_loop:
    cmp esi, ebx  
    jge sort_start 

    lea rcx, [fmt]
    lea rdx, [arr + esi*4]  ; Адрес текущего элемента массива
    call scanf

    inc esi
    jmp input_loop

sort_start:
    xor edi, edi             ; edi = 0 (left = 0)
    mov esi, ebx             ; esi = n
    dec esi                  ; esi = n - 1 (right = n - 1)

sorting_loop:
    mov eax, edi             ; eax = left
    cmp eax, esi             ; left >= right?
    jge sort_end             ; Если да, завершить сортировку

    mov ecx, edi             ; ecx = left
    
first_loop_start:
    cmp ecx, esi             ; Пока ecx < right
    jge first_loop_end

    mov edx, [arr + ecx*4]   ; edx = arr[ecx]
    mov eax, [arr + ecx*4 + 4] ; eax = arr[ecx+1]
    cmp edx, eax             ; Сравниваем arr[ecx] и arr[ecx+1]
    jle no_swap1

    ; Меняем местами arr[ecx] и arr[ecx+1]
    mov [arr + ecx*4], eax
    mov [arr + ecx*4 + 4], edx

no_swap1:
    inc ecx                  ; ecx++
    jmp first_loop_start

first_loop_end:
    dec esi                  ; right--
    mov ecx, esi             ; ecx = right

second_loop_start:
    cmp ecx, edi             ; Пока ecx > left
    jle second_loop_end

    mov edx, [arr + ecx*4]   ; edx = arr[ecx]
    mov eax, [arr + ecx*4 - 4] ; eax = arr[ecx-1]
    cmp eax, edx             ; Сравниваем arr[ecx-1] и arr[ecx]
    jle no_swap2

    ; Меняем местами arr[ecx-1] и arr[ecx]
    mov [arr + ecx*4 - 4], edx
    mov [arr + ecx*4], eax

no_swap2:
    dec ecx                  ; ecx--
    jmp second_loop_start

second_loop_end:
    inc edi                  ; left++
    jmp sorting_loop

sort_end:
    xor ecx, ecx             ; ecx = 0 (счетчик для вывода)

output_loop:
    cmp ecx, ebx             ; Пока ecx < n
    jge end_program          ; Завершаем, если все элементы выведены

    mov eax, [arr + ecx*4]   ; eax = arr[ecx]
    PRINT_DEC 4, eax         ; Вывод числа
    PRINT_STRING " "         ; Вывод пробела
    inc ecx                  ; ecx++
    jmp output_loop          ; Переход к следующему элементу

end_program:
    mov rsp, rbp
    pop rbp
    RET
