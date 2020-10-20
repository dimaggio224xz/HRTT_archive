format MZ
push cs 				    
pop ds				  ;Инициализация сегмента данных
push ds
pop ss				  ;Инициализация сегмента стека
jmp mt1 			  ;Переход на основную программу
   mes db '           TECHNOLOGY MMX THE PENTIUM PROCESSOR ',0ah,0dh,'$'
	src db 'PHILADELPHIA  FLYERS MIKROPROCESSOR THE PENTIUM TECHNOLOGY','$'
	tmp db	tmp-src-1 dup(20h)
	dst db	tmp-src-1 dup('?'),'$'

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
 
 mt1:				    ;Начало основной программы
 out_str mes			    ;Вывод на экран текстового сооббщения
 cursor 			    ;Перевод экранного курсора в начало новой строки
 out_str src			    ;Вывод на экран текстового сооббщения
 cursor 			    ;Перевод экранного курсора в начало новой строки
 cursor
 mov eax,tmp-src-1		    ;Число байтов массива
 mov ebx,8			    ;Пакет ММХ расширения в байтах
 xor edx,edx			    ;Сброс в ноль
 div ebx			    ;Делить на число байтов в пакете
 mov ecx,eax			    ;Число пакетов в тексте
 mov esi,src
 mov edi,dst
 mov ebx,tmp
 next:
 movq mm0,[esi] 		     ;Загрузка пакета 64 бита учетверённым словом
 paddb mm0,[ebx]		     ;Пакетное сложение байтов в расширении ММХ
 movq [edi],mm0 		     ;Сохранение пакета 64 бита учетверённым словом
 add esi,8
 add edi,8
 add bx,8
 dec ecx
 jnz next
 mov ecx,edx
 next1:
 mov al,[esi]
 add al,20h
 mov [edi],al
 inc esi
 inc edi
dec ecx
jnz next1
exit:
out_str dst		     ;Вывод на экран текстового сооббщения
cursor
mov ax, 4c00h
int 21h 			   



