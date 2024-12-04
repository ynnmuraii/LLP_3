%include "io64.inc"

section .data
    val_float1 dd 1400.0
    val_float2 dd 1900.0

section .text
extern access8

global main                       
main:
    push    rbp 
    mov     rbp, rsp
    sub     rsp, 32
    
    mov     cx, 40
    movss   xmm1, dword [val_float1]
    movss   xmm2, dword [val_float2]
    mov     r9w, 50

    call    access8

    leave
    xor     rax, rax
    ret
