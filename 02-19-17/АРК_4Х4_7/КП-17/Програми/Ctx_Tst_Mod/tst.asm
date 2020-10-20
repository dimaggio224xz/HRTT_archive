  masm  ;Програмна модель тестування tst.asm – така назва тестової програми
    model small                                                    
   .stack 100h                                                                   ; Визначення сегменту стека
   .data                                                                              ;Визначення сегменту даних
      CT_L db 000,000,127,127           ;Початковий стан CTL
      CT_H db 000,128,000,128          ;Початковий стан CTH
    mes_1 db '            1 State  CTX before testing',0dh,0ah,0ah, '$'
    mes_2 db '            -----------------------------------------------',0dh,0ah, '$'
    mes_3 db '              CTL:',20h,'$'
    mes_4 db '              CTH:',20h,'$'
   mes_5 db '                   Program testing OT-416_09_Petrenko',0dh,0ah, '$'
   mes_6 db '            __________________________________________________________',0dh,0ah, '$'
   mes_7 db '  ',0dh,0ah, '$'
   mes_8 db '            2 State after testing oper While CTH<CTL do CTH:=CTH+1',0dh,0ah, 0ah,'$'
   mes_9 db '            3 State after testing oper Repeat CTL:=CTL-1 Until CTL>CTH',0dh,0ah,0ah, '$'
   mes_10 db '            4 State after testing oper Func CTL:=not CTL',0dh,0ah,0ah, '$'
      len equ 4           ;Кількість початкових станів
       .code                 ;Визначення програмного сегменту 
inp_key macro         ;Макрос очікування натиснення клавіші Х
             local lpp 
             mov ah,07h
      lpp: int 21h
             cmp al, 'x'
             jne lpp
             endm
        Whil proc near                   ;Процедура перед умовного циклу
                 mov cl,CT_l[bx]         ;CTX := Поточний початковий стан 
           cc1:cmp CT_h[bx],cl        ;Порівняння (CTH)-(CTL)
                 jae cc2                        ;Заперечення вимоги  Con_1             
                 inc byte ptr CT_h[bx] ;Виконання оператора Oper_1           
                 jmp cc1                        ;Безумовний перехід   
           cc2:ret
         endp
       Rpet proc near                    ;Процедура після умовного циклу
                mov ch,CT_h[bx]      ;CTX := Поточний початковий стан
         cc3:dec byte ptr CT_l[bx]  ; Виконання оператора Oper_2
                cmp CT_l[bx] , ch       ; Порівняння  (CTL) - (CTH)            
                jbe cc3                         ; Заперечення вимоги  Con_2
                ret
         endp
  Funk proc near                  ;Процедура обчислення функції
             mov cl,CT_l[bx]  
             not cl                     ; Заперечення
             mov CT_l[bx], cl
             ret
      endp
         scr macro x                  ;Макрос видачі на екран станів CTX
                local nxt                 ;Опис поміток
                xor bx,bx                ;Скид адреси
                mov cx,len              ;Лічильник станів
         nxt: xor ah,ah                ;Очистка регістру
                mov al,x[bx]           ;Поточний стан
                trn                          ;Виведення на екран станів
                mov ah,2     
                mov dl,20h
                int 21h                    ;Вивід на екран пропуску
                inc bx                      ;Наступна адреса
                loop nxt                   ;Перехід на повторення
                mov dl,0dh                
                int 21h                     ;Переклад курсора на новий рядок
                 mov dl,0ah
                int 21h                     ;Переклад курсора в початок рядка
       endm
          trn macro                      ;Макрос перетворення та виведення
                local mxt                 ;Опис поміток
                mov dh,100             ;Дільник
        mxt: div dh                       ;Ділення 
                mov dl,al;                ;Частка від ділення
                mov al,ah                ;Остача від ділення
               xor ah,ah
                push ax	             ;Збереження в стеку
                or dl,30h                  ;ASCII символ 
                mov ah,2                 ;Функція DOS
                int 21h                     ;Виведення на екран 
               xor ah,ah
               mov al,dh
               mov dh,10
               div dh                      ;Ділення на 10
               mov dh,al
               pop ax	            ;Повернення із стеку
               or dh,dh	            ;Очистка регістру
               jnz mxt                    ;Перехід на повторення             
        endm
   out_scr macro mes	   ;Макрос видачі на екран повідомлення
                mov dx,offset mes  ;Адреса повідомлення
                mov ah,09h	        ;Функція DOS
                int 21h
    endm
 Stat  macro 	         ;Макрос видачі на екран повідомлення
           out_scr mes_3          ;на екран  
            scr CT_L                 ;станів
            out_scr mes_4         ;лічильників
            scr CT_H                ;до  тестування
            out_scr mes_7         ;Пропуск рядка стрічки
            out_scr mes_6         ; Повідомлення друге
    endm
    Exe_Scr   macro  P       ;Макрос обчислення стану
          local lp
             mov di,len              ;Лічильник станів  
            xor bx,bx                 ;Скидання адресного регістру
        lp:call P                       ;Виклик процедури обчислення 
            inc bx                       ;Корекція адреси станів у памяті 
            dec di                       ;Корекція  лічильника циклів   
            jnz lp	          ;Перехід на наступний стан
      endm
                       start:mov ax,@data        ;Основна програма
                               mov ds,ax                ;Утворення сегменту даних
                               out_scr mes_5        ; Повідомлення про назву
                               out_scr mes_2        ; Повідомлення перериваючої лінії
                               out_scr mes_1         ;Повідомлення про стан до тестування
                               Stat                          ;Виведення стану лічильників
                               Exe_Scr Whil          ;Обчислення станів в памяті перед умовним циклом
                               out_scr mes_8         ;Повідомлення про стан після дії перед умовного циклу
                               Stat                          ;Виведення стану лічильників
                               Exe_Scr Rpet           ;Обчислення станів в памяті після умовним циклом
                               out_scr mes_9          ;Повідомлення про стан після дії після умовного циклу
                               Stat                           ;Виведення стану лічильників
                               Exe_Scr  Funk         ;Обчислення станів в памяті після оператором функції
                               out_scr mes_10        ;Повідомлення про стан після дії оператора функції
                               Stat                           ;Виведення стану лічильників
                               inp_key                     ;Програмне очікування натиску клавиші Х
                               mov ax,4c00h         
                               int 21h                      ;Повернення  в DOS
                        end start