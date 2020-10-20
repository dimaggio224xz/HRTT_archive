 ;Автор программы пакетного сложения в ХММ расширении PENTIUM Бездетко А.М.
format MZ
push cs 				    
pop ds				  ;Инициализация сегмента данных
push ds
pop ss				  ;Инициализация сегмента стека
jmp mt1 					  ;Переход на основную программу
       mes db '                  TECHNOLOGY XMM ADDITION THE PENTIUM PROCESSOR',0ah,0dh,'$'
     mes1 db '          addps xmm0,xmm1;ADDition Packed Single-precision float-point',0ah,0dh,'$'
     mes2 db '                  ---------------------------------------------',0ah,0dh,'$'
   Oper1 db '          Packed_X: ','$'
   Oper2 db '          Packed_Y: ','$'
      Sum db '          Packed_Z: ','$'
	a1 dd 0.0, 1.0, 0.0,-55.51 ; Резервирование памяти под пакет
	a2 dd 90.9, 0.0, 0.0, 703.91 ;операндов и результата из четырёх 
	res dd a2-a1 dup('?')	     ; операндов в стандартном  формате  SPFP     
  macro out_str str		       ;Вывод текстового сообщения
	    {
	      mov dx,str
	      mov ah,9
	      int 21h
	     }

  macro cursor		 ;Перевод экранного курсора монитора
	    {
	      mov ah,2
	      mov dl,0dh
	       int 21h		  ;Перевод  курсора на новую строку
	       mov dl,0ah	  
	       int 21h			;Перевод  курсора в начало строки
	     }
  macro scr_ddw adr		   ;Вывод пакета байтов
	{
	local nxt		      
	push bx
	mov bx,adr		    ;Начальный адрес пакета
	add bx,15		      ;Конечный адрес пакета
	mov cx,16		      ;Ёмкость пакета в байтах
	    nxt:scr_byt 	      ;Вывод одного байта
		dec bx		;Уменьшение адреса пакета
		loop nxt	 ;Переход на младший элемент пакета
		mov dl,'h'
		int 21h 	   ;Вывод символа
		pop bx
	cursor
	}

	 macro scr_byt		    ;Вывод одного байта
	 {
	local  comp,symb,scrn,exit
		mov ah,2		     ;Функция системного прерывания
		mov dh,1		     ;Установка пользовательского флажка
		mov dl,[bx]		     ;Передача текущего байта
		shr dl,4			 ;Передача старшей тетрады в младшую
	       comp:cmp dl,10			  ;Сравнение с десяткой
		jnc symb		       ;Символ больше или равнн десяти
		add dl,30h		      ;Формирование ASCII символа чисел 0,1,..,9
		jmp scrn		       ;Переход на вывод символа
	      symb: add dl,37h			    ;Формирование ASCII символа чисел 10,11,..,15
	       scrn: int 21h		  ;Вывод символа
		or dh,dh		      ;Анализ
		jz exit 			 ; пользовательского флажка
		mov dh,0		     ;Сброс пользовательского флажка
		mov dl,[bx]		     ;Передача текущего байта
		and dl,0fh		       ;Формирование младшей тетрады
		jmp comp		      ;Переход на обработку младшей тетрады  символа
		 exit: mov dl,' '	
		int 21h 			;Вывод символа
		}
 
 mt1:				    ;Начало основной программы
 cursor 				    ;Перевод экранного курсора в начало новой строки
  cursor	   
   out_str mes			    ;Вывод на экран текстового сооббщения
    out_str mes2			    ;Вывод на экран текстового сооббщения
 cursor 			       
 out_str mes1			    ;Вывод на экран текстового сооббщения
    cursor	
 out_str Oper1			    ;Вывод на экран текстового сооббщения
  scr_ddw a1			    ;Вывод на экран первого пакета данных в формате SPFP           
    cursor	
 out_str Oper2			    ;Вывод на экран текстового сооббщения
  scr_ddw a2			    ;Вывод на экран второго пакета данных в формате SPFP       
    cursor
     mov esi,a1 		    ;Инициализация     
     mov edi,a2 					      ;адресных
     mov ebx,res					     ;регистров
 movups xmm0,[esi]					;MOVe Unaligned four Pakced Single-precesion float-point 
 movups xmm1,[edi]				       ;Пересылка невыровненных упакованных значений  в формате SPFP  
addps xmm0,xmm1 				      ;Пакетное сложение одинарной точности с плавающей точкой
 movups[ebx],xmm0			    ;Загрузка пакета размером 64 бита учетверённым словом
 out_str Sum			    ;Вывод на экран текстового сооббщения
scr_ddw res					    ;Вывод на экран  пакета суммы данных в формате SPFP       
 cursor 			  
mov ax, 4c00h						   ;Стандартный возврат в операционную
int 21h 						    ; среду управления компьютером         



