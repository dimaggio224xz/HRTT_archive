format MZ
push cs 				    
pop ds				  ;Ініціалізація сегменту даних
push ds
pop ss				  ;Ініціалізація сегменту стека
jmp mt1 				  ;Перехід на основну програму
       mes db '              TECHNOLOGY MULTIMEDIA  ADDITION THE PENTIUM PROCESSOR',0ah,0dh,'$'
     mes0 db '                ------- SINGLE PRECESSION FLOATING POINT -------',0ah,0dh,'$'
     mes1 db '          addps xmm0,xmm1;ADDition Packed Single-precision float-point',0ah,0dh,'$'
     mes2 db '                  ---------------------------------------------',0ah,0dh,'$'
   Oper1 db '          Packed_X: ','$'
   Oper2 db '          Packed_Y: ','$'
      Sum db '          Packed_Z: ','$'
	a1 dd -51.7, 0.0, 1.0, -142.6	    ; Резервування пам'яті під пакет
	a2 dd -90.9, 0.0, -1.0, 0.0		   ;операндів та результату із чотирьох
	res dd a2-a1 dup('?')	      ; операндів в стандартному  форматі  SPFP     
			    macro out_str str	      ;Вивід текстового повідомлення
	    {mov dx,str
	      mov ah,9
	      int 21h}
		      macro cursor		  ;Перевід екранного курсора монітору
	    {mov ah,2
	      mov dl,0dh	
	       int 21h				  ;Перевід  курсора на новую стрічку
	       mov dl,0ah	  
	       int 21h} 			  ;Перевод  курсора в начало строки
       macro scr_ddw adr		     ;Вивід пакету байтів
	{local nxt		      
	push bx
	mov bx,adr		      ;Початкова адреса пакету
	add bx,15		      ;Кінцева адреса пакету
	mov cx,16		      ;Ємність пакету в байтах
	    nxt:scr_byt 	      ;Вивід одного байту
		dec bx	     ;Зменшення адреси пакету
		loop nxt	     ;Перехід на молодший елемент пакету
		mov dl,'h'
		int 21h 	     ;Вивід символу
		pop bx
	cursor}

	 macro scr_byt		    ;Вивід одного байту
	 {local  comp,symb,scrn,exit
		mov ah,2		     ;Функция  преривання
		mov dh,1		     ;Установка прапора користувача
		mov dl,[bx]		     ;Передача текучого байту
		shr dl,4		     ;Передача старшої тетради в молодшу
		    comp:cmp dl,10		     ;Порівняння с десяткою
		jnc symb		       ;Символ больший або рівний десять
		add dl,30h		      ;Формування ASCII символу чисел 0,1,..,9
		jmp scrn		       ;Перехід на вивід символу
		    symb: add dl,37h	     ;Формування ASCII символу чисел 10,11,..,15
		  scrn: int 21h 	     ;Вивід символу
		or dh,dh		      ;Анализ
		jz exit 		      ;прапору користувача
		mov dh,0		      ;Скид прапору користувача
		mov dl,[bx]		      ;Передача текучого байту
		and dl,0fh		      ;Формування молодшої тетради
		jmp comp		      ;Перехід на обробку  тетради  символу
		       exit: mov dl,' ' 
		int 21h}		    ;Вивід символу
		 
 mt1:cursor			   ;Початок основної програми
 cursor 			   ;Перевід екранного курсору 
  cursor	   
   out_str mes0 		    ;Вивід на екран текстового повідомлення
 cursor 
 out_str mes			    ;Вивід на екран текстового повідомлення
    out_str mes2		    ;Вивід на екран текстового повідомлення
 cursor 			       
 out_str mes1			    ;Вивід на екран текстового повідомлення
    cursor	
 out_str Oper1		    ;Вивід на екран текстового повідомлення
  scr_ddw a1			    ;Вивід на екран першого пакету данних в форматі SPFP           
    cursor	
 out_str Oper2		    ;Вивід на екран текстового повідомлення
  scr_ddw a2			     ;Вивід на екран другого пакету данних в форматі SPFP      
    cursor
     mov esi,a1 		    ;Ініціалізація     
     mov edi,a2 		     ;адресних
     mov ebx,res		     ;регістрів
 movups xmm0,[esi]		    ;MOVe Unaligned four Pakced Single-precesion float-point 
 movups xmm1,[edi]		     ;Пересилка непорівнених упакованих значень  в форматі SPFP  
addps xmm0,xmm1 		      ;Пакетне додавання одинарної точності з плаваючою точкою
 movups[ebx],xmm0		    ;Завантаження пакету розміром 64 біта учетверенним словом
 out_str Sum			   ;Вивід на екран текстового повідомлення
scr_ddw res			     ;Вивід на екран  пакету суми данних в форматі SPFP    
 cursor 			  
mov ax, 4c00h		    ;Стандартне повернення в операційне
int 21h 			    ; средовище управління компютером         



