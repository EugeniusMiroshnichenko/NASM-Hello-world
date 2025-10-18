section .text

global _start

_start:
    mov rax, 0x1
    mov rdi, 0x1
    mov rsi, msg
    mov rdx, len
    syscall
    
    cmp rax, len ; rax не меняется, код ошибки не теряем, если она есть
    JL errorSection ; % Выведено меньше символов, чем ожидалось (если есть ошибка, то результат автоматически будет отрицательным)
    
    mov rax, 0x3c
    mov rdi, 0x0
    syscall

    

errorSection:
    ; Вывелись не все символы на экран или есть ошибка
    ; Код ошибки лежим в rax, здесь возможна какая-то дополнительная логика
    mov rax, 0x1
    mov rdi, 0x2
    mov rsi, erMsg
    mov rdx, erMsgLen
    syscall
    
    mov rax, 0x3c
    mov rdi, 0x1
    syscall
    

section .data
    msg db  "Hello world!", "\n"
    len equ $ - msg
    erMsg db "Error happed during writing!", "\n"
    erMsgLen equ $ - erMsg

