format MZ
push cs 				    
pop ds				  ;Инициализация сегмента данных
push ds
pop ss				  ;Инициализация сегмента стека
jmp mt1 			  ;Переход на основную программу
      mes db '           TECHNOLOGY XMM THE PENTIUM PROCESSOR ',0ah,0dh,'$'
   Oper1 db '           PACKED OPERAND1 FORMAT SPFP ',0ah,0dh,'$'
   Oper2 db '           PACKED OPERAND2 FORMAT SPFP',0ah,0dh,'$'
   Sum	 db '       PACKED SUMMA FORMAT SPFP ',0ah,0dh,'$'
	a1 dd -100.0, 0.0, 0.0,-51.7 ; Резервирование памяти под пакет
	a2 dd 0.1, 0.0, 0.0, -90.9 ;операндов и результата из четырёх 
	res dd a2-a1 dup('?')	     ; операндов в стандартном  формате  SPFP     

  macro out_str str		  ;Вывод текстового сообщения
	    {
	      mov dx,str
	      mov ah,9
	      int 21h
	     }

  macro cursor		 ;Перевод экранного курсора монитора
	    { mov ah,2
	      mov dl,0dh
	      int 21h
	      mov dl,0ah
	      int 21h }
  macro scr_ddw adr		   ;Вывод пакета байтов
	{
	local nxt
	mov si,adr
	add si,15
	mov cx,16
    nxt:scr_byt
	dec si
	loop nxt
	cursor
	}

  macro scr_byt 		    ;Вывод одного байта
	{
	local tst,w_0,w_1
	mov bl,128		    ;Маска сканирования
	mov ah,2		    ;Функция прерывания
    tst:test [si],bl		    ;Тестирования бита
	jz w_0			    ;Бит равен нулю
	mov dl,'1'
	jmp w_1
    w_0:mov dl,'0'
    w_1:int 21h 		    ;Вывод бита на экран
	shr bl,1
	jne tst
	mov dl,' '
	int 21h
	}
 
 mt1:				    ;Начало основной программы
 out_str mes			    ;Вывод на экран текстового сооббщения
 cursor 			    ;Перевод экранного курсора в начало новой строки
 out_str Oper1			    ;Вывод на экран текстового сооббщения
 cursor 			   
scr_ddw a1
 cursor 	
 out_str Oper2			    ;Вывод на экран текстового сооббщения
 cursor 			   
scr_ddw a2
 cursor 			
  mov esi,a1
 mov edi,a2
  mov ebx,res
 movups xmm0,[esi]
 movups xmm1,[edi]
addps xmm0,xmm1
 movups[ebx],xmm0		     ;Загрузка пакета 64 бита учетверённым словом
 out_str Sum			    ;Вывод на экран текстового сооббщения
 cursor 		
scr_ddw res
 cursor 		
mov ax, 4c00h
int 21h 			   



