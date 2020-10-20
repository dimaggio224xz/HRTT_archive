;Исследование фажка DF
masm
model small
.stack 100h
.data
oper_1 db 0c7h, 2dh, 0bdh, 4eh ; Цепочка источник 
oper_z dd 0
oper_2 db 4 dup ('X')                 ; Цепочка приёмнок 
.code
exe:mov ax,@data                      ; Сегменты DS, ES       
       mov ds,ax                            ; в памяти наложены  
       mov es,ax                            ; друг на друга
       lea si,oper_1+3                   ; Инициализация адресов
       lea di, oper_2+3                  ;на конец цепочки 
        mov cx, 2                            ;Длина цепочки
        std                                       ;Установка DF:=1
cli
hlt
        rep movsb                           ; Передача назад
       lea si,oper_1                        ; Инициализация адресов
       lea di, oper_2                       ;на начало цепочки
        mov cx, 2                             ;Длина цепочки
       cld                                        ;Установка DF:=0
       rep movsb                             ; Передача вперёд
       mov ax,4c00h                        ; Программный
       int 21h                                   ; возврат в MS DOS
       end exe 

