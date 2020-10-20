     format mz		;Програма вивчення співпроцесора
     push cs
     pop ds			    ;Ініціалізація сегменту даних
     jmp qqq

       macro out_str mes       ;Макрос виведення повідомлення
	     {mov dx,mes
	      mov ah,9
	      int 21h}

	macro kay	    ;Макрос очікування натиску клавиші
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
	      int 21h}	       ;та у її початок

	macro curs		;Макрос переміщення екранного курсору
	     {mov ah,2
	      mov dl,20h
	      int 21h}

	macro hex	       ;Макрос друку символу
	    { mov ah,2
	      mov dl,'h'
	      int 21h }

	  macro scr_byt 		      ;Виведення одного байту
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

	  macro scr_quw m,t,n		     ;Виведення повідомлення m, даних за t адресою n байтів
	 {local nxt
		out_str m
		mov si,t		    ;Показчик адреси
		add si,n-1		    ;Переведення на старший байт
		mov cx,n		    ;Кількість слів
	   nxt: scr_byt 		    ;Виведення на екран байту символів
		curs			    ;Пропуск місця символу
		dec si			    ;Зміна адреси
		loop nxt		    ;Повторення або вихід
		hex			    ;Друк симвое Н
		cursor
		cursor}

 qqq:cursor		    ;Основна програма
     cursor
     out_str me1	    ;Виведення на екран текстового повідомлення
     cursor
     cursor
     finit
     scr_quw mes1,X1,L1     ;Друк у внутрішньому форматі
     scr_quw mes2,X2,L2     ;змінної Single операндів
     mov bx,X1		    ;Адреса прершого числа
     fld dword [bx]	    ;Передача на вершину
     mov bx,X2		    ;Адреса другого числа
     fadd  dword [bx]	    ;Додавання в співпроцесорі
     mov bx,X3		    ;Адреса результату
     fstp dword [bx]	    ;Збереження результату
     scr_quw mes3,X3,L3     ;Дрку результату
     mov bx,S1		    ;Адреса слова управління
     FSTCW  [bx]	    ;STore  Control Word;  MEM:= (CWR)
     scr_quw ms1,S1,M1	    ;Друк слова управління
     mov bx,S2		    ;Адреса слова стану
     FSTCW  [bx]	    ;STore  Control Word;  MEM:= (SWR)
     scr_quw ms2,S2,M2	    ;Друк слова стану
     cursor
     out_str me2	    ;Виведення на екран текстового повідомлення
     kay			 ;Очікування натиску клавіші
     mov ax,4c00h		 ;Повернення в операційну
     int 21h			 ;систему комп'ютера
	me1 db '          Study of arithmetic coprocessor start',0ah,0dh,'$'
	ms1 db '         State CW : ','$'
	ms2 db '         State SW : ','$'
	mes1 db '               X1 : ','$'
	mes2 db '               X2 : ','$'
	mes3 db '            X1+X2 : ','$'
	me2 db '         Study of arithmetic coprocessor  stop','$'
      X1 DD 7645.67  ;Перший операнд
      L1=$-X1	     ;та його байтність
      X2 DD -7645.67 ;Другий операнд
      L2=$-X2	     ;та його байтність
      X3 DD ?	     ;Результат обчислення в співпроцесорі
      L3=$-X3	     ;та його байтність
      S1 DD ?	     ;Збереження слова управління
      M1=$-S1	     ;та його байтність
      S2 DD ?	     ;Збереження слова стану
      M2=$-S2	     ;та його байтність