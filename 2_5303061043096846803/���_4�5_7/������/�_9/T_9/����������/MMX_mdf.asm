 ;Автор программы пакетного сложения в ММХ расширении PENTIUM Бездетко А. М.
format MZ
push cs 				    
pop ds				  ;Инициализация сегмента данных
push ds
pop ss				  ;Инициализация сегмента стека
jmp mt1 			  ;Переход на основную программу
     mes21 db '      TECHNOLOGY MMX ADDITION MMX0:=(MMX0)+(MMX7) THE PENTIUM PROCESSOR ',0ah,0dh,'$'
	mes22 db 'Pack_X:','$'
	mes23 db 'Pack_Y:','$'
	mes24 db 'Pack_Z:','$'
      mes1 db '   paddd mm0,mm7   ;Packed ADDition Double word   ',0ah,0dh,'$'
      mes2 db '   paddusw mm0,mm7;Packed ADDiton Unsigned with Saturation Word',0ah,0dh,'$'
      mes3 db '   paddsb mm0,mm7  ;Packed ADDition signed with Saturation Bytes',0ah,0dh,'$'
	a1 db 56h, 0d5h, 72h, 0afh, 0a4h, 50h, 0e6h, 99h
	a2 db 3dh, 76h, 0f4h, 5ah, 88h, 16h, 0aah, 77h
       res db a2-a1 dup(' ')

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
	push si
	mov si,adr
	add si,7
	mov cx,8
    nxt:scr_byt
	dec si
	loop nxt
	pop si
	cursor
	}

  macro scr_byt 		    ;Вывод одного байта
	{
	local tst,w_0,w_1
	push bx
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
	pop bx
	mov dl,' '
	int 21h
	}
;Начало основной программы
mt1:	
out_str mes21			    ;Вывод на экран текстового сооббщения
cursor
cursor
mov esi,a1
mov edi,a2
mov ebx,res
;Packed ADDitin Double words
out_str mes1			    ;Вывод на экран текстового сооббщения
cursor
out_str mes22
scr_ddw a1
out_str mes23
scr_ddw a2
movq mm0,[esi]
movq mm7,[edi]
paddd mm0,mm7	   ;Packed ADDitin Double words   MMX0:=(MMX0) +(MMX7)
movq[ebx],mm0
out_str mes24
scr_ddw res
 cursor
 cursor
;Packed ADDitin Unsigned with Saturation Words
 out_str mes2			     ;Вывод на экран текстового сооббщения
 cursor
out_str mes22
scr_ddw a1
out_str mes23
scr_ddw a2
movq mm0,[esi]
movq mm7,[edi]
paddusw mm0,mm7       ;Packed ADDitin Unsigned with Saturation Words    MMX0:=(MMX0) +(MMX7)
movq[ebx],mm0
out_str mes24
scr_ddw res
 cursor
 cursor
 ;Packed ADDitin signed with Saturation Bytes  
  out_str mes3			      ;Вывод на экран текстового сооббщения
  cursor
out_str mes22
scr_ddw a1
out_str mes23
scr_ddw a2
movq mm0,[esi]
movq mm7,[edi]
paddsb mm0,mm7	      ;Packed ADDitin signed with Saturation Bytes    MMX0:=(MMX0) +(MMX7)
movq[ebx],mm0
out_str mes24
scr_ddw res
mov ax, 4c00h
int 21h 			   



