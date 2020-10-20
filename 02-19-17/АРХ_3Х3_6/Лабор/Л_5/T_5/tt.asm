masm               ;Программа многобайтного сложения 
model small     ; с анализом на переполнение   
.stack 100h
.data
message_1 db 'Overflow', 13, 10,'$'          ;Сообщения о признаке
message_2 db 'NoOverflow', 13,10, '$'      ;полученного  результата
oper_1 db 0fh, 0fah, 0f5h,  8fh              ;Определение 
oper_2 db 87h, 5Dh, 74h,  76h              ;операндов
summ db 4 dup (?)                                 ;и результата  
.code
stt:jmp exe
err_sum proc near                        ;Процедура выдачи сообщения
       mov ah,09h
       mov dx,offset message_1
       int 21h
       ret
       endp
exe:mov ax,@data         ;Стандартное начало 
       mov ds,ax                ;основной программы
       mov ax,3            ;Очистка экрана 
       int 10h                ;монитора
xor si,si                       ; Инициализация  
xor di,di                      ; адресных
lea bx,summ                ; регистров и
mov  cx, 4                  ; счётчика циклов
clc                                ;Установка CF:=0 
        cycle:  mov al, oper_1[si]            ; Сложение текущих
adc al, oper_2[di]             ; байтов из памяти с 
mov [bx],al                        ; запоминанием результата
pushf
inc si                           ;Коррекция на плюс один
inc di                           ;адресных
inc bx                          ;регистров
popf
loop cycle                                 ;Зацикливание
jo ero                         ; Анализ на переполнение 
 mov ah,09h                             ;Сообщение об
 mov dx,offset message_2        ;отсутствии
 int 21h                                     ;переполнения
jmp ext                         
ero: call err_sum        ;Выявлено переполнение   
       ext:mov ax,4c00h     ;Стандартный вход  
  int 21h                  ; в среду MS DOS
                      end stt
   
 
