  masm  ;Програмна модель тестування tst.asm – така назва тестової програми
    model small                                                    
   .stack 100h                                                                   ; Визначення сегменту стека
   .data                                                                              ;Визначення сегменту даних
      CT_L db 000,000,127,127,128,255           ;Початковий стан CTL
      CT_H db 000,128,000,128,255,128          ;Початковий стан CTH
    mes_1 db '1 State  CTX before testing',0dh,0ah,0ah, '$'
    mes_2 db '---------------------------------',0dh,0ah, '$'
    mes_3 db 'CTL:',20h,'$'
    mes_4 db 'CTH:',20h,'$'
   mes_5 db 'Program testing OT-419_06_Jemets',0dh,0ah, '$'
   mes_6 db '_________________________________',0dh,0ah, '$'
   mes_7 db '  ',0dh,0ah, '$'
 mes_8 db '3 State after testing oper WHILE',0dh,0ah, 0ah,'$'
 mes_9 db '4 State after testing oper REPEAT',0dh,0ah,0ah, '$'
mes_10 db '2 State after testing oper FUNCT',0dh,0ah, 0ah,'$'
       len equ 6          ;Кількість початкових станів
       .code                 ;Визначення програмного сегменту 
          fnc_B proc near                 ;Процедура програмної моделі лічильника
                 mov cl,CT_l[bx]   ;CTX := Поточний початковий стан 
           cc1:cmp CT_h[bx],cl                ;Порівняння (CTH)-(CTL)
                 jb cc2                      ;Заперечення вимоги  Con_1             
                 inc byte ptr CT_h[bx]   ;Виконання оператора Oper_1           
                 jmp cc1                     ;Безумовний перехід   
          cc2:ret
        endp
    fnc_A proc near                 ;Процедура програмної моделі лічильника
                mov ch,CT_h[bx]   ;CTX := Поточний початковий стан
         c3: dec byte ptr CT_l[bx]                    ; Виконання оператора Oper_2
                cmp CT_l[bx] , ch               ; Порівняння  (CTL) - (CTH)            
                jb c3                        ; Заперечення вимоги  Con_2
                ret
        endp
 fnc_F proc near    
            mov ch,CT_h[bx]   ; Передача істини
            and CT_l[bx], ch               ;Функція кон’юнкції
            not byte ptr CT_l[bx]
             ret
      endp
          scr macro x                  ;Макрос видачі на екран станів CTX
                local nxt                 ;Опис поміток
                xor bx,bx                ;Скид адреси
                mov cx,len              ;Лічильник станів
         nxt: xor ah,ah                 ;Очистка регістру
                mov al,x[bx]           ;Поточний стан
                 mov dh,100            ;Дільник
                div dh                      ;Ділення на 100
                mov dl,al;               ;Сотні
                mov al,ah                ;Остача від ділення
                push ax	;Збереження в стеку
                or dl,30h                  ;ASCII символ сотень
                mov ah,2                 ;Функція DOS
      int 21h                     ;Вивід на екран сотень
               pop ax	 ;Повернення із стеку
                xor ah,ah	 ;Очистка регістру
                mov dh,10
                div dh                      ;Ділення на 10
                mov dl,al                 ;Десятки  
                mov al,ah                 ;Одиниці
                or dl,30h                  ;ASCII символ десятків
      mov ah,2                  ;Функція DOS
      push ax	                  ;Збереження в стеку
                int 21h                     ; Вивід на екран десятків         
                pop ax	         ;Повернення із стеку
                mov dl,al
                or dl,30h                  ;ASCII символ одиниць
                int 21h                     ;Вивід на екран одиниць
                mov dl,20h
                int 21h                     ;Вивід на екран пропуску
                inc bx                      ;Наступна адреса
                loop nxt                   ;Перехід на повторення
                mov dl,0dh                
                int 21h                     ;Переклад курсора на новий рядок
                 mov dl,0ah
                int 21h                     ;Переклад курсора в початок рядка
       endm
   out_scr macro mes	   ;Макрос видачі на екран повідомлення
                mov dx,offset mes  ;Адреса повідомлення
                mov ah,09h	        ;Функція DOS
                int 21h
    endm
 Stat  macro 	   ;Макрос видачі на екран повідомлення
           out_scr mes_3         ;на екран  
            scr CT_L                 ;станів
            out_scr mes_4         ;лічильників
            scr CT_H                ;до  тестування
            out_scr mes_7         ;Пропуск рядка стрічки
            out_scr mes_6         ; Повідомлення друге
    endm
    Exe_Scr   macro  P	   ;Макрос видачі на екран повідомлення
          local lp
             mov di,len              ;Лічильник станів  
            xor bx,bx                ;Скидання адресного регістру
        lp:call P                    ;Тестування на поточному стані  
            inc bx                      ;Корекція адреси
           dec di                       ;Корекція  лічильника циклів   
            jnz lp	                    ;Перехід на наступний стан
      endm
                       start:mov ax,@data	    ;Основна програма
                                 mov ds,ax               ;Утворення сегменту даних
                                 mov ax,3
                                ;int 10h                     ;Текстовий режим монітора 80*25
	         out_scr mes_5        ; Повідомлення перше 
                          out_scr mes_2        ; Повідомлення перше 
                         out_scr mes_1         ;Видача
                         Stat 
  Exe_Scr fnc_F
   out_scr mes_10        ;Видача
   Stat 
                         Exe_Scr fnc_B
                         out_scr mes_8         ;Видача
                        Stat 
                        Exe_Scr fnc_A
                       out_scr mes_9         ;Видача
                       Stat 
                     
                     mov ax,4c00h         
                     int 21h                      ;Повернення  в DOS
                        end start