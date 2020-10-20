;Дослідження прапора DF
.model small                                     ;Тип моделі пам’яті
.stack 100h                                        ;Сегмент стеку
.data                                                  ;Сегмент даних
Mes_1 db 'Study flag DF                                                              ',13,'$'
 Mes_2 db 'Bezditko A. M.',0dh,0ah,'$'; Текст повідомлення
oper_1 db 0c7h, 2dh, 0bdh, 34h    ; Джерельний ланцюг 
len equ $-oper_1                          ;Кількість байтів ланцюга
oper_2 db len dup ('X')              ; Ланцюг приймача 
.code                                              ;Сегмент програми
   exe:mov ax,@data                      ; Сегменти DS, ES в фізичній       
       mov ds,ax                              ; пам’яті  накладені 
       mov es,ax                               ; один на другий
       Mov bl,2
   Nxt:mov ah,09                             ; Виведення 
       Cmp bl,1
       jnz mms
       mov dx, offset mes_2               ; повідомлення
       int 21h   
       jmp hod         
   mms:mov dx, offset mes_1         
       int 21h                                   ; за перериванням              
       lea si,oper_1+len-1                  ;Ініціалізація адрес
       lea di,oper_2+len-1                ;на кінець ланцюга байтів 
        mov cx, len/2                          ;Довжина ланцюга
        std                                         ;Установка DF:=1
        rep movsb                           ; Передача назад
        mov si, offset  oper_1          ; Ініціалізація адрес
        mov di, offset oper_2            ;на початок ланцюга
        mov cx, len/2                      ;Довжина ланцюга
        cld                                        ;Установка DF:=0
        rep movsb                             ; Передача уперед
    hod:dec bl
        jnz nxt
        mov ax,4c00h                        ; Програмне
        int 21h                                   ; повернення в MS DOS
        end exe                                  ; Закінчення програми

