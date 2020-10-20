
;Листинг програми пакетної обробки слів в ММХ розширенні
format MZ
push cs
pop ds				  ;Ініціалізація сегменту даних
 jmp qqq
    macro out_str str		  ;Макрос виведення повідомлення
	     {mov dx,str
	      mov ah,9
	      int 21h}			    ;Виведення за перериваннями
	      macro kay 	   ;Макрос очікування натиску клавиші
	     {local prs
	      mov ah,7
	  prs:int 21h			   ;Виведення за перериваннями
	      cmp al,'x'
	      jne  prs}
	macro cursor		  ;Макрос переміщення екранного курсору
	    { mov ah,2
	      mov dl,0dh
	      int 21h			     ;на наступну стрічку
	      mov dl,0ah
	      int 21h } 		      ;та у її початок
	macro scr_ddw adr	   ; Виведення пакету байтів
       {local nxt,nte
	mov ah,2
	push bp
	push si 			 ;Тимчасове збереження
	mov si,adr			;Адреса змінної
	add si,7			;Регістр та
	mov cx,4
    nte:mov bp,2			;лічильник байтів
    nxt:scr_byt 		       ;Вивід одного байту
	dec si
	dec bp
	jnz nxt
	mov dl,''		 ;Виведення на екран
	int 21h
	loop nte		  ;Корекція лічильника та перехід
	mov dl,'H'		  ;Виведення на екран
	int 21h 		  ;символу
	pop si
	pop bp} 		     ;Поновлення регістру
	macro scr_byt			     ;Виведення одного байту
	 {local comp,symb,scrn,exit
		mov ah,2		     ;Функція системного переривання
		mov dh,1		     ;Установка прапора користувача
		mov dl,[si]		     ;Передача поточного байту
		shr dl,4		     ;Передача старшої тетради в молодшу
	   comp:cmp dl,10		     ;Порівняння з десяткою
		jnc symb		     ;Символ більше або дорівнює десять
		add dl,30h		     ;Формування ASCII символу чисел 0,1,..,9
		jmp  scrn		   ;Перехід на вивід символу
	   symb:add dl,37h	  ;Формування ASCII символу чисел 10,11,..,15
	   scrn:int 21h 		     ; Виведення символу
		or dh,dh		     ;Аналіз
		jz exit 		     ;прапора користувача
		mov dh,0		     ;Скид  прапора користувача
		mov dl,[si]		     ;Передача текучого байту
		and dl,0fh		     ;Формування молодшої тетради
		jmp comp	     ;Перехід на обробку молодшої  тетради  символу
	   exit:nop }
qqq:					   ;Початок основної програми
out_str mes21		    ;Виведення на екран текстового повідомлення
cursor				    ;Переміщення
mov esi,a1			    ;Ініціалізація
mov edi,a2			    ;адресних
mov ebx,res			    ;покажчиків
out_str mes1			    ;Виведення на екран текстового повідомлення
out_str mes22			    ;Виведення на екран текстового повідомлення
scr_ddw a1
cursor				   ;Виведення на екран  першого пакету елементів
out_str mes23			    ;Виведення на екран текстового повідомлення
scr_ddw a2
cursor				   ;Виведення на екран  другого пакету елементів
movq mm0,[esi]			    ;Завантаження першого пакету в ММХ розширення
paddusw mm0,[edi]	    ; Packed ADDitin Unsigned with Saturation Word
movq[ebx],mm0			    ;Збереження пакету суми в пам’яті
out_str mes24			    ;Виведення на екран текстового повідомлення
scr_ddw res			    ;Виведення на екран суми пакету елементів
cursor
cursor
out_str mes2
out_str mes23			 ;Виведення на екран текстового повідомлення
scr_ddw a1
cursor				   ;Виведення на екран  першого пакету елементів
out_str mes23			    ;Виведення на екран текстового повідомлення
scr_ddw a2
cursor				   ;Виведення на екран  другого пакету елементів
movq mm0,[esi]			    ;Завантаження першого пакету в ММХ розширення
psubsw mm0,[edi]		;Packed SUBtractin signed with Saturation Word
movq[ebx],mm0			    ;Збереження пакету суми в пам’яті
out_str mes24			    ;Виведення на екран текстового повідомлення
scr_ddw res			    ;Виведення на екран суми пакету елементів
cursor
cursor
out_str mes20			    ;Виведення на екран текстового повідомлення
cursor
kay
mov ax, 4c00h		    ;Повернення в операційну
int 21h 			    ;систему комп’ютера
	mes21 db '               ARITHMETIC PACKED WORDS START',0ah,0dh,'$'
	mes20 db '               ARITHMETIC PACKED WORDS STOP',0ah,0dh,'$'
	mes22 db '               Pack_X: ','$'
	mes23 db '               Pack_Y: ','$'
	mes24 db '               Pack_Z: ','$'
	mes1 db '                    PADDUSW mm1, mm2/m64   ',0ah,0dh,'$'
	mes2 db '                    PSUBSW mm1, mm2/m64 ',0ah,0dh,'$'
	a1 db  45h,0BAh,6Eh,0D5h,23h,09h,9Ah,3Fh
	a2 db  0C7h,73h,00h,00h,00h,80h,00h,00h
	res db a2-a1 dup(' ')




