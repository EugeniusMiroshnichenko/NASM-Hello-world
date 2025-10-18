section .text

global _start

_start:

    ; Открытие файла

    mov rax, 0x2  ; sys_open
    ; Проверяем наличие файла, если его нет, созадаём + открываем только на чтение + очищаем файл при открытии
    mov rdi, fileName
    mov rsi, 0x241 ; O_WRONLY = 0x0001  O_CREAT = 0x0040  O_TRUNC  = 0x0200
    mov rdx, 0644o ; админу чтение и запись, остальным чтение
    syscall
    
    ; После успешного выполнения rax хранит или дескриптор файла
    ; в случае неуспешного открытия содержит отрицательное число
    cmp rax, 0
    JL errorSection


    ; Запись в файл

    mov r10, rax ; Запоминаем дескриптор
    mov rax, 0x1
    mov rdi, r10
    mov rsi, msg
    mov rdx, len
    syscall
    
    cmp rax, len ; rax не меняется, код ошибки не теряем, если она есть
    jl errorSection ; % Записано меньше символов, чем ожидалось (если есть ошибка, то результат автоматически будет отрицательным)


    ; Закрытие файла

    mov rax, 0x3
    mov rdi, r10
    syscall
    
    ; В случае неуспешного закрытия содержит отрицательное число
    cmp rax, 0
    JL errorSection
    
    
    ; Завершение

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
    fileName db "output", 0
    msg db  "Hello world!", "\n"
    len equ $ - msg
    erMsg db "Error happed during work!", "\n"
    erMsgLen equ $ - erMsg
