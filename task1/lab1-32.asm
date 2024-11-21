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
    mov ebp, esp; for correct debugging
    ; Пролог функции
    push ebp
    mov ebp, esp
    sub esp, 4 + 32          ; Выравниваем стек для локальных переменных
    
    mov ecx, 100            ; Количество элементов массива
    imul ecx, ecx, 4        ; Умножаем на размер элемента (4 байта)
    call malloc
    mov edi, eax            ; Адрес массива в edi

    ; Считываем n
    lea eax, [fmt]          ; 1-й аргумент в eax
    lea edx, [ebp-4]        ; 2-й аргумент в edx (адрес переменной n)
    push edx
    push eax
    call scanf
    add esp, 8              ; Очищаем стек после вызова

    mov ebx, [ebp-4]        ; n сохраняется в ebx

    ; Проверка допустимости n
    cmp ebx, 100
    jg end_program
    cmp ebx, 0
    jle end_program

    xor esi, esi            ; esi = 0 (счётчик для ввода массива)

input_loop:
    cmp esi, ebx            ; Проверка на окончание ввода
    jge sort_start

    lea eax, [fmt]          ; Загружаем формат для scanf
    lea edx, [edi + esi*4]  ; Адрес текущего элемента массива
    push edx
    push eax
    call scanf
    add esp, 8              ; Очищаем стек после вызова

    inc esi
    jmp input_loop

sort_start:
    xor ecx, ecx            ; ecx = 0 (left = 0)
    mov esi, ebx            ; esi = n
    dec esi                  ; esi = n - 1 (right = n - 1)

sorting_loop:
    mov eax, ecx            ; eax = left
    cmp eax, esi            ; left >= right?
    jge sort_end            ; Если да, завершить сортировку

    mov edx, ecx            ; edx = left
    
first_loop_start:
    cmp edx, esi            ; Пока edx < right
    jge first_loop_end

    mov ebx, [edi + edx*4]  ; ebx = arr[edx]
    mov eax, [edi + edx*4 + 4]  ; eax = arr[edx+1]
    cmp ebx, eax             ; Сравниваем arr[edx] и arr[edx+1]
    jle no_swap1

    ; Меняем местами arr[edx] и arr[edx+1]
    mov [edi + edx*4], eax
    mov [edi + edx*4 + 4], ebx

no_swap1:
    inc edx                  ; edx++
    jmp first_loop_start

first_loop_end:
    dec esi                  ; right--
    mov edx, esi             ; edx = right

second_loop_start:
    cmp edx, ecx             ; Пока edx > left
    jle second_loop_end

    mov ebx, [edi + edx*4]  ; ebx = arr[edx]
    mov eax, [edi + edx*4 - 4]  ; eax = arr[edx-1]
    cmp eax, ebx             ; Сравниваем arr[edx-1] и arr[edx]
    jle no_swap2

    ; Меняем местами arr[edx-1] и arr[edx]
    mov [edi + edx*4 - 4], ebx
    mov [edi + edx*4], eax

no_swap2:
    dec edx                  ; edx--
    jmp second_loop_start

second_loop_end:
    inc ecx                  ; left++
    jmp sorting_loop

sort_end:
    xor esi, esi             ; esi = 0 (счётчик для вывода)
output_loop:
    cmp esi, ebx             ; Пока esi < n
    jge end_program          ; Завершаем, если все элементы выведены

    mov eax, [edi + esi*4]   ; eax = arr[esi]
    lea ecx, [fmt_out]       ; Адрес строки формата "%d "
    push eax                  ; Значение для вывода передаем в стек
    push ecx                  ; Адрес строки формата передаем в стек
    call printf              ; Выводим число
    add esp, 8               ; Очищаем стек после вызова

    inc esi                  ; esi++
    jmp output_loop          ; Переход к следующему элементу

end_program:
    ; Восстанавливаем стек и завершаем программу
    mov esp, ebp
    pop ebp
    ret