global _start

section .bss
temp resb 1

section .data
num1 dq 0, 0, 32

num2 dq 0, 0, 3

section .text
%macro addI 3
    push 0
    push %3
    push %1
    push %2
    call addNums
    pop rbx
    pop rbx
    pop rbx
    pop rbx
%endmacro
_start:
    addI num1, num2, 3
    mov rbx, [num1+16]
loop:
    mov rax, rbx
    and rax, 1
    add rax, '0'
    mov [temp], rax
    mov rax, 1
    mov rdi, 1
    mov rsi, temp
    mov rdx, 1
    syscall

    shr rbx, 1

    cmp rbx, 0
    jne loop

    mov rax, 60
    mov rdi, [num1+16]
    syscall

addNums:
    mov r15, 0
    mov rdi, [rsp+32]
    mov rsi, [rsp+24]
    shl rsi, 3
    mov rax, [rsp+16]
    mov rbx, [rsp+8]
    add rax, rsi
    add rbx, rsi

addNumsLoop:
    mov rcx, [rax]
    mov rdx, [rbx]
    xor [rax], rdx
    and [rbx], rcx

    rol qword [rbx], 1

    mov rsi, [rbx]
    and rsi, 1
    sub [rbx], rsi
    add [rbx], rdi
    mov rdi, rsi

    mov rcx, 1
    cmp qword [rbx], qword 0
    cmovne r15, rcx

    sub rax, 8
    sub rbx, 8
    
    cmp rax, num1
    jge addNumsLoop

    mov rsi, [rsp+24]
    shl rsi, 3
    mov rbx, [rsp+8]
    add rbx, rsi

    cmp r15, 1
    je addNums

    ret
