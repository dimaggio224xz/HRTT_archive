masm                                     ;Программа арифметической обработки 
model small                           ;двоичных чисел   
mes_sb macro mes_i              ;Макрос выдачи сообщения
             mov ah,09h
             mov dx,offset mes_i
             int 21h
             endm
con_bd macro op_b, op_d    ;Макрос преобразования двоичного                
            local nxt1                  ;числа в распакованное двоично десятичное
            lea bx, op_d              ;Адрес распакованого десятичного кода
            mov cx,10000           ;Весовая маска
            mov si,10                  ;Дискрета десятичного веса 
            mov ax,op_b             ;Двоичный код из памяти  
    nxt1:xor dx,dx
            div cx                        ;Вычисление  и запоминание
            mov [bx]+4,al           ;текущего десятичного разряда
           dec bx
           mov ax,dx
           xor dx,dx
           xchg ax,cx                 ;Уменьшение
           div si                        ;веса    
           xchg ax,cx                 ;маски 
           or cx,cx
           jnz nxt1                     ;Выход, если маска равна нулю  
           endm  
con_db macro                       ;Макрос преобразования распакованного  
            local nxt2                  ;двоично десятичное числа в двоичного 
            lea bx, opp_d            ;Адрес распакованого десятичного кода
            mov cx,1                   ;Весовая маска
            mov si,10                  ;Дискрета десятичного веса 
           xor di,di
    nxt2:xor ah,ah 
            mov al, [bx]              ;Содержимое текущего десятичного разряда
            inc bx
            mul cx                       ;Частичное произведение    
            add di,ax                   ;Сумма частичных произведений
            mov  ax,cx                 ;Увеличение  
            mul si                        ;веса
            mov cx, ax                 ;маски
            and dx,0ffffh
            jz nxt2                       ;Выход, если маска больше 10000
            mov opp_b,di           ;Сохранение двоичного кода 
           endm  
             
.stack 100h
.data
mes1 db 'Error product!', '$'          ;Сообщения о признаке
mes2 db 'Ok Key product!', '$'       ;полученного  результата
op1_b dw  15888                   ;Определение 
op2_b dw  14288                    ;операндов
opp_b dw  ?                          ;и результата вычитания  
op1_d db 5 dup(?)                 ;Операнды и их
op2_d db 5 dup(?)                 ;разность в распакованном  
opp_d db 5 dup(?)                 ;десятичном формате   
.code
stt:  mov ax,@data                ;Стандартное начало 
       mov ds,ax                      ;основной программы
       mov ax,3                        ;Очистка экрана 
       int 10h                            ;монитора
       con_bd op1_b, op1_d    ;Преобразование двоичного кода 
       con_bd op2_b, op2_d    ;операндов в десятичный
       mov cx,5                        ;Разрядность десятичного кода   
       lea si, op1_d                   ;Инициализация
       lea di, op2_d                  ;адресных
       lea bx, opp_d                 ;указателей
       clc
nxt3:mov al,[si]                     ;Вычитание 
       sbb al,[di]                       ;байтов
       aas                                  ;с коррекцией
       mov [bx],al                     ;результата
       inc si                               ;распакованных
       inc di                               ;десятичных
       inc bx                              ;чисел
       loop nxt3                         ;операндов  
       con_db                            ;Конверсия в двоичный код 
       mov ax, op1_b                 ; Двоичное
      ; inc al
       sub ax, op2_b                  ; вычитание
       cmp ax, opp_b                 ;Сравнение двух результатов
       jz ner                                  
       mes_sb mes1                    ;Ошибка результата  
      jmp exit
ner:  mes_sb mes2                   ;Правильность результата
exit:mov ax,4c00h                   ;Стандартный вход  
       int 21h                              ; в среду MS DOS
       end stt 
