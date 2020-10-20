;Автор програми пакетного додавання в ММХ расширенні Бездітко О.М.
format MZ
push cs 				    
pop ds				  ;Ініціалізація сегменту даних
push ds
pop ss				  ;Ініціалізація сегменту стеку
 jmp qqq
   macro kay		;Макрос очікування натиску клавиші
	     {local prs
	      mov ah,7
	  prs:int 21h			   ;Виведення за перериваннями
	      cmp al,'x'
	      jne  prs}
    macro out_str str		  ;Макрос виведення повідомлення
	     {mov dx,str
	      mov ah,9
	      int 21h}		  ;Виведення за перериваннями
	macro cursor		  ;Макрос переміщення екранного курсору
	    { mov ah,2
	      mov dl,0dh
	      int 21h		   ;на наступну стрічку
	      mov dl,0ah
	      int 21h } 	   ;та у її початок
   macro scr_ddw adr		  ;Вивід пакету байтів
       {local nxt
	push si 		  ;Тимчасове збереження
	mov si,adr		  ;Адреса змінної
	add si,7		  ;Регістр та
	mov cx,8		  ;лічильник байтів
    nxt:scr_byt 		  ;Вивід одного байту
	dec si			  ;Зменшення адреси
	loop nxt		  ;Корекція лчильника та перехід
	mov dl,'H'		  ;Виведення на екран
	int 21h 		  ;символу
	pop si			  ;Поновлення регістру
	cursor}
	macro scr_byt			     ;Вивід одного байту
	 {local comp,symb,scrn,exit
		mov ah,2		     ;Функція системного переривання
		mov dh,1		     ;Установка прапора користувача
		mov dl,[si]		     ;Передача текчого байту
		shr dl,4		     ;Передача старшої тетради в молодшу
	   comp:cmp dl,10		     ;Порівняння з десяткою
		jnc symb		     ;Симвіл більше або рівен десять
		add dl,30h		     ;Формування ASCII символу чисел 0,1,..,9
		jmp scrn		     ;Перехід на вивід символу
	      symb:add dl,37h		     ;Формування ASCII символу чисел 10,11,..,15
	      scrn:int 21h		     ;Вивід символу
		or dh,dh		     ;Аналіз
		jz exit 		     ;прапора користувача
		mov dh,0		     ;Скид  прапора користувача
		mov dl,[si]		     ;Передача текучого байту
		and dl,0fh		     ;Формування молодшої тетради
		jmp comp		     ;Перехід на обробку молодшої  тетради  символу
	    exit:mov dl,' '		     ;Вивід символу
		int 21h}
qqq: ;Початок основної програми
out_str mes21			    ;Виведення на екран текстового повідомлення
cursor				    ;Переміщення
cursor				    ;екранного курсору
mov esi,a1			    ;Ініціалізація
mov edi,a2			    ;адресних
mov ebx,res			    ;покажчиків
;Packed ADDitin Double words MMX0:=(MMX0)+(MMX7)
out_str mes1			    ;Виведення на екран текстового повідомлення
cursor
out_str mes22			    ;Виведення на екран текстового повідомлення
scr_ddw a1			    ;Виведення на екран  першого пакету елементів
out_str mes23			    ;Виведення на екран текстового повідомлення
scr_ddw a2			    ;Виведення на екран  другого пакету елементів
movq mm0,[esi]			    ;Завантаження першого пакету в ММХ розширення
movq mm7,[edi]			    ;Завантаження другого пакету в ММХ розширення
paddd mm0,mm7			    ;Packed ADDitin Double words
movq[ebx],mm0			    ;Збереження пакету суми в памятьі
out_str mes24			    ;Виведення на екран текстового повідомлення
scr_ddw res			    ;Виведення на екран суми пакету елементів
 cursor
 cursor
;Packed ADDitin Unsigned with Saturation Words MMX0:=(MMX0)+(MMX7)
out_str mes2			    ;Виведення на екран текстового повідомлення
cursor
out_str mes22			    ;Виведення на екран текстового повідомлення
scr_ddw a1			    ;Виведення на екран  першого пакету елементів
out_str mes23			    ;Виведення на екран текстового повідомлення
scr_ddw a2			    ;Виведення на екран  другого пакету елементів
movq mm0,[esi]			    ;Завантаження першого пакету в ММХ розширення
paddusw mm0,[edi]		    ;Packed ADDitin Unsigned with Saturation Words
movq[ebx],mm0			    ;Збереження пакету суми в памятьі
out_str mes24			    ;Виведення на екран текстового повідомлення
scr_ddw res			    ;Виведення на екран суми пакету елементів
 cursor
 cursor
 ;Packed ADDitin signed with Saturation Bytes  MMX0:=(MMX0) +(MMX7)
out_str mes3			    ;Виведення на екран текстового повідомлення
cursor
out_str mes22			    ;Виведення на екран текстового повідомлення
scr_ddw a1			    ;Виведення на екран  першого пакету елементів
out_str mes23			    ;Виведення на екран текстового повідомлення
scr_ddw a2			    ;Виведення на екран  другого пакету елементів
movq mm0,[esi]			    ;Завантаження першого пакету в ММХ розширення
movq mm7,[edi]			    ;Завантаження другого пакету в ММХ розширення
paddsb mm0,mm7			    ;Packed ADDitin signed with Saturation Bytes
movq[ebx],mm0			    ;Збереження пакету суми в памятьі
out_str mes24			    ;Виведення на екран текстового повідомлення
scr_ddw res			    ;Виведення на екран суми пакету елементів
cursor
cursor
out_str mes20			    ;Виведення на екран текстового повідомлення
cursor
cursor
kay
mov ax, 4c00h			    ;Поверненння в операційну
int 21h 			    ;систему компютера
 mes21 db '   TECHNOLOGY ADDITION MMX0:=(MMX0)+(MMX7) THE PENTIUM PROCESSOR START',0ah,0dh,'$'
     mes20 db '   TECHNOLOGY MMX  ADDITION MMX0:=(MMX0)+(MMX7) THE PENTIUM PROCESSOR STOP',0ah,0dh,'$'
	mes22 db '                  Pack_X: ','$'
	mes23 db '                  Pack_Y: ','$'
	mes24 db '                  Pack_Z: ','$'
      mes1 db '      PADDD mm0,mm7  ;Packed ADDition Double word   ',0ah,0dh,'$'
      mes2 db '      PADDUSW mm0,mm7;Packed  ADDition Unsigned with Saturation Word',0ah,0dh,'$'
      mes3 db '      PADDSB mm0,mm7 ;Packed  ADDition signed with Saturation Bytes',0ah,0dh,'$'
	a1 db 0c6h, 0d5h, 82h, 4fh, 0a4h, 50h, 0a6h, 0E9h
	a2 db 3dh, 76h, 0f4h, 0bah,  0c8h, 56h, 0aah, 37h
       res db a2-a1 dup(' ')




