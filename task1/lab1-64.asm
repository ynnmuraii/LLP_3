%include "io64.inc"

section .rodata
    fmt: db "%u", 0
    fmt_out: db "%d ", 0

section .bss
    arr resd 100             ; Массив остаётся в памяти

extern scanf, printf
extern malloc, free

section .text
    global main

main:
    mov rbp, rsp; for correct debugging
    ; Пролог функции
    push rbp
    mov rbp, rsp
    sub rsp, 4+32              ; Выравниваем стек для локальных переменных
    
    mov rcx, 100
    imul rcx, rcx, 4
    call malloc
    mov rdi, rax

    ; Считываем n
    lea rcx, [fmt]           ; 1-й аргумент в rcx
    lea rdx, [rbp-4]         ; 2-й аргумент в rdx
    call scanf


    mov ebx, [rbp-4]         ; n сохраняется в ebx

    ; Проверка допустимости n
    cmp ebx, 100
    jg end_program
    cmp ebx, 0
    jle end_program

    xor rsi, rsi             ; esi = 0 (счётчик для ввода массива)

input_loop:
    cmp esi, ebx  
    jge sort_start 

    lea rcx, [fmt]
    lea rdx, [rdi + rsi*4]   ; Адрес текущего элемента массива
    call scanf

    inc rsi
    jmp input_loop

sort_start:
    xor r8d, r8d             ; edi = 0 (left = 0)
    mov esi, ebx             ; esi = n
    dec esi                  ; esi = n - 1 (right = n - 1)

sorting_loop:
    mov eax, r8d             ; eax = left
    cmp eax, esi             ; left >= right?
    jge sort_end             ; Если да, завершить сортировку

    mov ecx, r8d             ; ecx = left
    
first_loop_start:
    cmp ecx, esi             ; Пока ecx < right
    jge first_loop_end

    mov edx, [rdi + rcx*4]   ; edx = arr[ecx]
    mov eax, [rdi + rcx*4 + 4] ; eax = arr[ecx+1]
    cmp edx, eax             ; Сравниваем arr[ecx] и arr[ecx+1]
    jle no_swap1

    ; Меняем местами arr[ecx] и arr[ecx+1]
    mov [rdi + rcx*4], eax
    mov [rdi + rcx*4 + 4], edx

no_swap1:
    inc ecx                  ; ecx++
    jmp first_loop_start

first_loop_end:
    dec esi                  ; right--
    mov ecx, esi             ; ecx = right

second_loop_start:
    cmp ecx, r8d             ; Пока ecx > left
    jle second_loop_end

    mov edx, [rdi + rcx*4]   ; edx = arr[ecx]
    mov eax, [rdi + rcx*4 - 4] ; eax = arr[ecx-1]
    cmp eax, edx             ; Сравниваем arr[ecx-1] и arr[ecx]
    jle no_swap2

    ; Меняем местами arr[ecx-1] и arr[ecx]
    mov [rdi + rcx*4 - 4], edx
    mov [rdi + rcx*4], eax

no_swap2:
    dec ecx                  ; ecx--
    jmp second_loop_start

second_loop_end:
    inc r8d                  ; left++
    jmp sorting_loop

sort_end:
    xor esi, esi             ; ecx = 0 (счётчик для вывода)

output_loop:
    cmp esi, ebx             ; Пока ecx < n
    jge end_program          ; Завершаем, если все элементы выведены

    mov eax, [rdi + rsi*4]   ; eax = arr[ecx]
    lea rcx, [fmt_out]       ; Адрес строки формата "%u "
    mov rdx, rax             ; Значение для вывода передается в rdx
    call printf              ; Выводим число

    inc esi                  ; ecx++
    jmp output_loop          ; Переход к следующему элементу

end_program:
    ; Восстанавливаем стек и завершаем программу
    mov rsp, rbp
    pop rbp
    ret
