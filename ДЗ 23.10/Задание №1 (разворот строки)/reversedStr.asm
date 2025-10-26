section .text

global _start

_start:
    ; Входное сообщение
    mov rax, 0x1
    mov rdi, 0x1
    mov rsi, inMes
    mov rdx, inMesLen
    syscall

    cmp rax, inMesLen ; rax не меняется, код ошибки не теряем, если она есть
    JL errorSection ; % Выведено меньше символов, чем ожидалось (если есть ошибка, то результат автоматически будет отрицательным)

    ; Считываем строку
    mov rax, 0
    mov rdi, 0
    mov rsi, string
    mov rdx, 256
    syscall
    
    cmp rax, 0
    JL errorSection; 0 символов - не ошибка. Значит ошибка только отрицательное число
    JE exitSection

    mov [str_len], rax
    mov rdi, string
    mov rsi, reversed_str
    mov rdx, [str_len]
    call reverse_string

    ; Выходное сообщение
    mov rax, 0x1
    mov rdi, 0x1
    mov rsi, outMes
    mov rdx, outMesLen
    syscall

    cmp rax, outMesLen ; rax не меняется, код ошибки не теряем, если она есть
    JL errorSection ; % Выведено меньше символов, чем ожидалось (если есть ошибка, то результат автоматически будет отрицательным)

    ; Выводим перевернутую строку
    mov rax, 0x1
    mov rdi, 0x1
    mov rsi, reversed_str
    mov rdx, [str_len]
    syscall
    
    cmp rax, [str_len] ; rax не меняется, код ошибки не теряем, если она есть
    JL errorSection ; % Выведено меньше символов, чем ожидалось (если есть ошибка, то результат автоматически будет отрицательным)
 
    ; Новая строка
    mov rax, 0x1
    mov rdi, 0x1
    mov rsi, newLine
    mov rdx, newLineLen
    syscall

    cmp rax, newLineLen ; rax не меняется, код ошибки не теряем, если она есть
    JL errorSection ; % Выведено меньше символов, чем ожидалось (если есть ошибка, то результат автоматически будет отрицательным)   
    
    ; Завершаем работу
    JMP exitSection


reverse_string:
    ; rdx хранит длину строки
    ; rdi - ссылку на исходную строку (на входе), 
    ; rsi - сслыку на перевернутую строку
    ; rcx - счётчик
    
    mov rcx, 0 ; обнуляем счетчик (на всякий случай)

    mov r8, rdi ; сохраняем начало исходной строки в r8, чтобы не съехал указатель
    add rdi, rdx ; rdi указывает на конец исходной строки
    dec rdi ; корректируем на последний символ
    
    
.loop:
    mov al, [rdi] ; символ с текущего конца исходной строки 
    mov [rsi + rcx], al ; помещаем символ в перевернутую строку (движемся с начала) 
    dec rdi ; смещаем конец исходной строки
    inc rcx ; увеличиваем счётчик
    cmp rcx, rdx ; проврека на выход за границы
    jb .loop
    
    ret


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

exitSection:
    mov rax, 0x3c
    mov rdi, 0x0
    syscall

section .data
    inMes db "Enter string:"
    inMesLen equ $ - inMes
    outMes db "Reversed string:"
    outMesLen equ $ - outMes
    newLine db 10
    newLineLen equ $ - newLine
    string times 256 db 0     ; Исходная строка
    str_len dd 0            ; Длина введенной строки
    erMsg db "Error happed during writing!", "\n"
    erMsgLen equ $ - erMsg

section .bss
    reversed_str times 256 resb 0  ; Буфер для перевернутой строки

