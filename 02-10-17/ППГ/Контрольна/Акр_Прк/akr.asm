 ;Дослідження команд умовного галудження
.model small					 ;Тип моделі пам’яті
.stack 100h					 ;Сегмент стеку
.data						 ;Сегмент даних
X db 0, 126, 64, 1, 255, 193, 64, 192;Перший операнд 
Y db 0, 64, 126, 0, 128, 127, 248, 15;Другий операнд   
len equ $-Y  
Z db len*2*4 dup (?)
    mes_1 db '              Beginning of the job processing',0dh,0ah,0ah,'$'
    mes_2 db '              1 Initial state',0dh,0ah,'$' 
    mes_3 db '              2 State after While  Y<X  do Y:=Y-1',0dh,0ah,'$'
    mes_4 db '              3 State after execute function X:=X xor  Y',0dh,0ah, '$'
    mes_5 db '              4 State after Repeat  X:=X+1  Until X>=Y ',0dh,0ah,'$'
    mes_6 db '              Completion of the job processing',0dh,0ah, '$'  
   mes_7 db ' X:',20h,'$'
   mes_8 db ' Y:',20h,'$'  
   mes_9 db '  ',0dh,0ah, '$'			
.code  ;Сегмент програми  

                 srv macro  Pnt	    ;Сервіс виконання операторів
	   local lop
	    mov cx,len	     ;Лічильник станів  
	    mov bx,offset x	     ;Адреса стрічки байтів
                lop:call Pnt	                         ;Тестування на поточному стані  
	    inc bx		     ;Корекція адреси
	    loop lop		     ;Корекція  лічильника циклів   	  
	    endm  

                Whi proc near	;Процедурна реалізація передумовного циклу
	    mov al,[bx] 	;Читання елемента першого операнда 
                Whl:cmp [bx]+len,al	;Порівняння та формування усіх прапорів стану
	    jge nx1		; Критерій ознаки порівняння Y >= X
	    dec byte ptr [bx]+len ; Дія обчисленняY:=Y - 1
	    jmp Whl		      
                nx1:ret 
	    endp Whi  

                fnc proc near
	    mov al,[bx]+len	 ;Читання елемента першого операнда 
	    xor [bx],al                 ;Функція конюнкції	   
	    ret 
	    endp  fnc 

                        rpi proc near	 ;Процедурна реалізація функції
	    mov al,[bx]+len	 ;Читання елемента першого операнду 
                 rip:inc byte ptr [bx]	  ;Декремент X:=X - 1         
	   cmp [bx],al	 ;Порівняння та формування усіх прапорів стану
	    jl rip		  ;Критерій ознаки порівняння X<Y
	    ret 
	    endp rpi

                  trn macro p	    ;Транспорт блоку з len*p   байтів
	    mov cx,len                    ;Лічильник циклів
	    lea si, x	                        ;Початкова адреса
                        mov di,len*p               ;Р=2,4,6,8
                rep movsw	                        ;Блокова пересилка
	    endm
				  
	mes macro msg			       ;Макрос програмного
	    mov ah,09h			       ;виведення 
	    mov dx,offset msg		       ;повідомлення
	    int 21h			       ;за перериванням   
	    endm

                                 scr macro xx		 ;Макрос видачі на екран станів CTX
		local nxt		  ;Опис поміток
		xor bx,bx		 ;Скид адреси
		mov cx,8	                     ;Лічильник станів
	            nxt: xor ah,ah 		 ;Очистка регістру
		mov al, xx[bx]	;Поточний стан
		 mov dh,100	 ;Дільник
		div dh		  ;Ділення на 100
		mov dl,al                        ;Сотні
		mov al,ah		 ;Остача від ділення
		push ax                           ;Збереження в стеку
		or dl,30h		   ;ASCII символ сотень
		mov ah,2		   ;Функція DOS
	                    int 21h		   ;Виведення  на екран сотень
	                    pop ax	                     ;Повернення із стеку
		xor ah,ah	                      ;Очистка регістру
		mov dh,10
		div dh		   ;Ділення на 10
		mov dl,al		  ;Десятки  
		mov al,ah		  ;Одиниці
		or dl,30h		   ;ASCII символ десятків
	                   mov ah,2 		  ;Функція DOS
	                   push ax		  ;Збереження в стеку
		int 21h 		    ; Виведенняна екран десятків         
		pop ax		 ;Повернення із стеку
		mov dl,al
		or dl,30h		   ;ASCII символ одиниць
		int 21h 		    ;Виведення на екран одиниць
		mov dl,20h
		int 21h 		    ;Виведення на екран пропуску
		inc bx		    ;Наступна адреса
		loop nxt		   ;Перехід на повторення
		mov dl,20h		  
		int 21h 		      ;Виведення на екран пропуску
		mov dl,20h		   
		int 21h 		      ;Виведення на екран пропуску
                                       endm

               exe macro 		                      ; Макрос програмного виводу станів
	  mes mes_9		   ; Курсор на початок та на нову стрічку
	  mes mes_7		   ; Назва Х
	  scr  x		                       ; Виведення в DEC форматі
	  xyz	x		   ; Виведення в HEX форматі
	  mes mes_9		   ; Курсор на початок та на нову стрічку
	  mes mes_8		   ; Назва Y
	  scr  y		                       ; Виведення в DEC форматі
	  xyz	y		   ; Виведення в HEX форматі
	  mes mes_9;                                      ; Курсор на початок та на нову стрічку
	  mes mes_9;                                      ; Курсор на початок та на нову стрічку
	  endm

 scr_sym macro	           ;Видача ASCII Hexmal символу  
	local fri,sym
	cmp dl,0ah          ;Порівняння з десяткою
	jb fri	           ;Менше десятки
	or dl,40h	          ;Формування символу 
	sub dl,09h	          ;велікої літері 
	jmp sym 	          ;Перехід на видачу
              fri:or dl,30h	          ;Формування символу 
          sym:int 21h 	         ;Видача символу на екран   
                  endm  

scr_byte macro		   ;Видача байту ASCII Hexmal символів
	 mov dl,[di]	    ;Завантаження з памяті 
	 push cx	     ;Збереження в стеку
	 mov cl,4	     ;Розрядність тетради
	 shr dl,cl	       ; Зсув  управо на чотири
	 pop cx 	      ;Поновлення регістру
	 scr_sym	    ;Видача старшого символу байту
	 mov dl,[di]	   ;Завантаження того ж числа з памяті 
	 and dl,0fh	    ;Знищення старшої тетради
	 scr_sym	     ;Видача молодшого символу байту
	 mov dl,20h	   ;Видача  символу 
	 int 21h	       ;пропуск
	 endm
	 
               xyz macro   adr  ;Видача байтів ASCII символів змінної   
	  local next
	   mov cx,8
	   lea di, adr
             next:scr_byte       ;Видача байту ASCII символів
	     inc di	       ;Збільшення адреси
	     loop next	      ;Зменшення лічильника та перехід
	     mov dl,'h'       ;Видача
	     int 21h		;символу h
	     endm	      
    
  sta:mov ax,@data			 ;Ініціалізація        
      mov ds,ax 			 ;регістрів на 
      mov es,ax 			 ;перекриття сегментів
      cld 
 mes mes_9;
      mes mes_1 	  ;Повідомлення про початок тестування ознаки
      mes mes_2; 
exe                                    ;Друк двох стрічок вихідного стану
       trn 2		   ;Транспорт вихідного стану
      srv Whi                       ; Обчислення перед умовного циклу
      mes mes_3               ; Друк оператора перед умовного циклу
exe                                    ;Друк двох стрічок обчислень перед умовного циклу
      trn 4		   ;Транспорт післяобчислень перед умовного циклу
      srv fnc                         ; Обчислення функції
      mes mes_4               ; Друк оператора функції
exe                                    ;Друк двох стрічок обчисленьфункції
      trn 6		   ;Транспорт після виконаної функції                                     
      srv rpi                        ; Обчислення після умовного циклу
      mes mes_5               ; Друк оператора після  умовного циклу
exe                                    ;Друк двох стрічок обчислень після  умовного циклу
      trn 8		     ;Транспорт післяобчислень після  умовного циклу
      mes mes_6 	   ;Повідомлення про закінчення тестування ознаки  
      mes mes_9               ;Курсор на нове місце
      mov ax,4c00h	   
      int 21h			   ;Повернення  в DOS
      end sta