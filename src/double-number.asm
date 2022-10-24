SYS_EXIT  equ 1
SYS_READ  equ 3
SYS_WRITE equ 4
STDIN     equ 0
STDOUT    equ 1

STRING_TERMINATOR equ 0

SECTION .DATA
    userMsg:      db 'Enter a number: ', 0xA,0xD
    userMsgLen:   equ $-userMsg
    dispMsg:      db 'The double of this number is: ', 0xA,0xD
    dispMsgLen:   equ $-dispMsg

SECTION .bss
    num           resb 5
    numDouble     resb 5
    resultBuffer  resb 5

SECTION .TEXT
    GLOBAL _start
    GLOBAL string_to_int
    GLOBAL int_to_string

_start:
    mov eax,SYS_WRITE
    mov ebx,STDOUT
    mov ecx,userMsg
    mov edx,userMsgLen
    int 0x80

    ; reading from STDIN
    mov eax,SYS_READ
    mov ebx,STDIN
    mov ecx,num
    mov edx,5
    int 0x80

    mov eax,SYS_WRITE
    mov ebx,STDOUT
    mov ecx,dispMsg
    mov edx,dispMsgLen
    int 0x80

    lea esi,[num]
    mov ecx,4
    call string_to_int

    mov ebx,eax
    add eax,ebx

    mov [numDouble],eax

    lea esi,[numDouble]
    call int_to_string

    mov [resultBuffer],eax

    mov eax,SYS_WRITE
    mov ebx,STDOUT
    mov ecx,resultBuffer
    mov edx,5
    int 0x80

    ; Terminating the program
    mov eax,SYS_EXIT
    mov ebx,0
    int 0x80

string_to_int:
    xor ebx,ebx    ; clear ebx

    .next_digit:
        movzx eax,byte[esi]
        inc esi
        sub al,'0'    ; convert from ASCII to number
        imul ebx,10
        add ebx,eax   ; ebx = ebx*10 + eax
        loop .next_digit  ; while (--ecx)
        mov eax,ebx
        ret


; Input:
; EAX = integer value to convert
; ESI = pointer to buffer to store the string in (must have room for at least 10 bytes)
; Output:
; EAX = pointer to the first character of the generated string
int_to_string:
    add esi,9
    mov byte [esi],STRING_TERMINATOR

    mov ebx,10

    .next_digit:
        xor edx,edx         ; Clear edx prior to dividing edx:eax by ebx
        div ebx             ; eax /= 10
        add dl,'0'          ; Convert the remainder to ASCII 
        dec esi             ; store characters in reverse order
        mov [esi],dl
        test eax,eax            
        jnz .next_digit     ; Repeat until eax==0
        mov eax,esi
        ret
