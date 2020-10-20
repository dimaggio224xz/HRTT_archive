      format mz 		     ;Програмна емуляція множення змінних EXTENDED
     push cs
     pop ds			    ;Ініціалізація сегменту даних
     jmp qqq

       macro out_str str       ;Макрос виведення повідомлення
	     {mov dx,str
	      mov ah,9
	      int 21h}

	macro kay	 ;Макрос очікування натиску клавиші
       {local prs
	      mov ah,7
	  prs:int 21h
	      cmp al,'x'
	      jne  prs}

	macro cursor	       ;Макрос переміщення екранного курсору
	     {mov ah,2
	      mov dl,0dh
	      int 21h	       ;на наступну стрічку
	      mov dl,0ah
	      int 21h}	      ;та у її початок

	macro curs	       ;Макрос переміщення екранного курсору
	     {mov ah,2
	      mov dl,20h
	      int 21h}

	macro hex	       ;Макрос друку символу
	    { mov ah,2
	      mov dl,'h'
	      int 21h }

	  macro scr_byt 		     ;Виведення одного байту
	 {local comp,symb,scrn,exit
		mov ah,2		     ;Функція системного переривання
		mov dh,1		     ;Установка прапора користувача
		mov dl,[si]		     ;Передача поточного байту
		shr dl,4		     ;Передача старшої тетради в молодшу
	   comp:cmp dl,10		     ;Порівняння з десяткою
		jnc symb		     ;Символ більше або дорівнює десять
		add dl,30h		     ;Формування ASCII символу чисел 0,1,..,9
		jmp  scrn		     ;Перехід на вивід символу
	   symb:add dl,37h		     ;Формування ASCII символу чисел 10,11,..,15
	   scrn:int 21h 		     ;Виведення символу
		or dh,dh		     ;Аналіз
		jz exit 		     ;прапора користувача
		mov dh,0		     ;Скид  прапора користувача
		mov dl,[si]		     ;Передача текучого байту
		and dl,0fh		     ;Формування молодшої тетради
		jmp comp		     ;Перехід на обробку молодшої  тетради  символу
	   exit:nop }

	  macro scr_quw t,n		      ;Виведення на екран одного байту
	 {local nxt,tyu
		push ax
		mov si,t		    ;Показчик адреси
		add si,n-1		      ;Переведення на старший йт
		mov cx,n		   ;Кількість слів
	   nxt: scr_byt 		    ;Виведення на екран байту символів
	  ; mov ax,cx
	  ; dec ax
	  ; mov dl,4
	  ; div dl
	   ;or ah,ah
	   ;jnz tyu
		curs
		; curs
	  ; tyu: curs;Пропуск місця символу
		dec si			    ;Зміна адреси
		loop nxt		    ;Повторення або вихід
		hex			    ;Друк симвое Н
		cursor
		cursor
		pop ax}

 qqq:cursor		    ;Основна програма
     cursor
     out_str mes1	     ;Виведення на екран текстового повідомлення
     cursor

   ;finit
   ;fld dword [x]
  ; fstp qword [y]
   out_str mes2
   scr_quw x,4
   out_str mes3
   scr_quw y,10

   out_str mes4
   scr_quw w,8
   out_str mes5
   scr_quw w,16
; mov ebx,x
 ;emms
;  mov ebx,x
; movq mm0,[ebx]
;  mov ebx,y
 ; movq [ebx],mm0
 ;  out_str mes10
 ; scr_quw y,8
 ooo:out_str mes6		 ;Виведення на екран текстового повідомлення
     kay			 ;Очікування натиску клавіші
     mov ax,4c00h		 ;Повернення в операційну
     int 21h			 ;систему комп'ютера
	mes1 db '                   Presentation data to processor PENTIUM start',0ah,0dh,'$'
	mes2 db '  Present LongInteger CPU:                                     ','$'
	mes3 db '     Present Extended FPU:                   ','$'
	mes4 db '       Present Packed MMX:                         ','$'
	mes5 db '       Present String XMM: ','$'
	mes6 db '                   Presentation data to processor PENTIUM stop',0ah,0dh,'$'

	      x  dd  -1294967295 ;               4 294 967 295 = FF FF FF FF
	      y  db  34,255,-98,3,109,-122,99,23,45,-33
	      w  db   -56, 44, 35, 127, -128,50,-50,78
	      z  db   110, 23, 56, -44, -22, 99, 35, 0, 70, -70, 67, -22, 87, 63, 41, 127