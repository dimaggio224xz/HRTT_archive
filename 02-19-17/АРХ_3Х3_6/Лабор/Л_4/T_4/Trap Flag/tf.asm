masm
model small
         scr macro xxx    ;Макрос выдачи на экран состояния регистра SI
            local nxt                  ;Описание метки
            push ds
            mov bx,2d94h    ;Сегмент данных, создаваемый прерыванием
            mov ds,bx         ;(INT 01h) по флажку TF=1
            mov bx,1                ;Сброс адреса
            mov cx,2                ;Счетчик состояний
       nxt: xor ah,ah              ;Сброс 
            mov al,xxx[bx]       ;Текущее состояние
            mov dh,100            ;Делитель
            div dh                     ;Деление на 100
            mov dl,al               ;Сотни
            mov al,ah               ;Остаток
            push ax
            or dl,30h                ;ASCII cимвол сотен
            mov ah,2
            int 21h                   ;Вывод на экран
            pop ax
            xor ah,ah
            mov dh,10
            div dh                    ;Деление на 10
            mov dl,al
            mov al,ah
            or dl,30h
            mov ah,2
            push ax
            int 21h                   ;Вывод на экран десятков
            pop ax
            mov dl,al
            or dl,30h
            int 21h                   ;Вывод на экран единиц
            mov dl,20h
            int 21h                  ;Вывод на экран пробела
            dec bx                   ;Следующий адрес
            loop nxt
            pop ds
            endm
      out_scr macro mes      ;Макрос выдачи на экран сообщения
           mov dx,offset mes
           mov ah,09h
           int 21h
           endm
 .stack 100h
.data
mes_1 db 'Flag TF=0', 0dh, 0ah, '$'
mes_2 db 'Flag TF=1', 0dh, 0ah, '$'
mes_3 db 'SI = ', '$'
.code
strt:mov ax,@data     
      mov ds,ax
      mov si,0ffaah        ; Тестовый код для SI
      pushf
      mov bp,sp                ; Подготовка модификации флажка TF
       xor word ptr [bp], 100h 
      ;out_scr mes_1
       out_scr mes_2
       popf                     ; Установка флажка TF в единицу
      out_scr mes_3
      scr 9c70h         ;Ячейка памяти, где прерывание записало SI
      mov dl,0dh       ; Перевод курсора  
      int 21h              ; на новую строку
       mov dl,0ah       ; Перевод курсора  
      int 21h              ; в начало строки
      mov ax,4c00h      
      int 21h              
      end strt 
