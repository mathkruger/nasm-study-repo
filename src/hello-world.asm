SECTION .DATA
    hello:      db 'Hello World',10
    helloLen:   equ $-hello

SECTION .TEXT
    GLOBAL _start

_start:
    mov eax,4           ; syscall 'write' = 4
    mov ebx,1           ; file descriptor 1 = STDOUT
    mov ecx,hello
    mov edx,helloLen
    int 80h

    ; Terminating the program
    mov eax,1
    mov ebx,0
    int 80h