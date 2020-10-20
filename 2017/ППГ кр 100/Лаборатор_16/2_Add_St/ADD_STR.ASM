     format mz			
     push cs
     pop ds
     jmp qqq

       macro out_str mes       ;Макрос виведення повідомлення
	     {mov dx,mes
	      mov ah,9
	      int 21h}

	macro kay	 ;Макрос очікування натиску клавіші
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

	  macro scr_byt 		      ;Виведення одного байту
	 {local comp,symb,scrn,exit
		mov ah,2		     ;Функція системного переривання
		mov dh,1		     ;Установка прапора користувача
		mov dl,[si]	     ;Передача поточного байту
		shr dl,4		     ;Передача старшої тетради в молодшу
	   comp:cmp dl,10		     ;Порівняння з десяткою
		jnc symb		     ;Символ більше або дорівнює десять
		add dl,30h	     ;Формування ASCII символу чисел 0,1,..,9
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

	  macro scr_quw m,t,n	     ;Виведення повідомлення m, даних за t адресою n байтів
	 {local nxt
		out_str m
		mov si,t		    ;Показчик адреси
		add si,n-1		    ;Переведення на старший байт
		mov cx,n		    ;Кількість слів
	   nxt: scr_byt 		    ;Виведення на екран байту символів
		curs		    ;Пропуск місця символу
		dec si		    ;Зміна адреси
		loop nxt		    ;Повторення або вихід
		hex		    ;Друк симвое Н
		cursor
		cursor}
qqq:cursor	  ;Основна програма
    out_str mes1	  ;Початкове повідомлення
    cursor
    mov bx,x	  ;Ініціалізація
    inc bx		  ;адресних покажчиків
    mov di,y
    inc di		  ;Виключення хвостового байту
    mov al,len	  ;Тестування на ознаку
    or al,al		  ;відсутності ланцюга
    jnz arb		  ;Ланцюг присутній
    out_str mes7	  ;Ланцюг відсутній
    jmp stp		  ;Вихід з програми
arb:scr_quw mes2,bx,len   ;Виведення ланцюгів
    scr_quw mes3,di,len   ;вихідних даних
    mov cl,4	  ;Визначення кількості
    mov ax,len	  ;подвійних
    div cl		  ;слів
    mov cl,al	  ;в cl та остачі в ah
    xor ch,ch	  ;Тестування ознаки
    or cx,cx		  ;кількості подвійних слів
    pushf		  ;Збереження вхідного перенесення
    jz exn		  ;Подвійнних слів намає
ccl:popf		;Поновлення вхідного перенесення
    mov edx,[di]	;Додавання другого операнду
    adc [bx],edx	;до першого у памяті
    pushf		;Збереження між подвійно словарного перенесення
    sub di,4	;Формування старших адрес
    sub bx,4	;ланцюгів
    loop ccl		;Корекція СХ на мінус один та перехід
exn:cmp ah,0	;Остатоку від
    jz ext		;ділення немає
nxt:cmp ah,03	;Тестування голови ланцюга на три байти
    jnz cm1		;Немає трьох байтіву у голові ланцюга
lba:popf		;Повернення вхідного пренесення
    mov dx,[di] 	;Додавання слів
    adc [bx],dx 	;у памяті
    pushf		;Збереження вихідного пернесення
    cmp ah,2	;Тестування голови ланцюга на два байти
    jnz lbt		;Перехід на обробку одного байту
ext:popf		;Оброблено
    jmp ovr		;два байти
lbt:popf		;Поновлення вхідного перенесення
    mov dl,[di+2]	;Додавання байтів
    adc [bx+2],dl	;у пам'яті
    jmp ovr		;з переходом на вихідний оператор
cm1:cmp ah,1	;У голові ланцюга
    jnz lba		;два байти
    sub di,2		;У голові ланцюга
    sub bx,2	;присутній
    jmp lbt		;один байт
ovr:mov bx,x	;Адреса результату
    pushf		;Буферизація статусу
    inc bx		;Виключення хвостового байту
    scr_quw mes4,bx,len ;Виведення ланцюга результату додавання
    popf		;Поновлення статусу
    jo ooo		;Є переповнення
    out_str mes6	;Немає переповнення
    jmp stp		;Перехід на закінчення
ooo:out_str mes5	;Є переповнення
stp:out_str mes8	;Підсумкове повідомлення
    kay 			;Очікування натиску клавіші
    mov ax,4c00h		;Повернення в операційну
    int 21h			;систему комп'ютера
	mes1 db '                   Study addition of lines of data start',0ah,0dh,'$'
	mes2 db '               Operand_X : ','$'
	mes3 db '               Operand_Y : ','$'
	mes4 db '               Rezult _W : ','$'
	mes5 db '                   A Overflow is present afte addition',0ah,0ah,0dh,'$'
	mes6 db '                   A Overflow absents afte addition',0ah,0dh,0ah,'$'
	mes7 db '                   Not of operands data before addition',0ah,0dh,0ah,'$'
	mes8 db '                   Stop testing addition of lines of data',0ah,0dh,0ah,'$'
	 x db ?
	   dd 0AFFCD09Dh,0F049F924h ; - 2 147 483 648 .. 2 147 483 647: 80 00 00 00h .. 7F FF FF FFh
	   dw 36CDh; 9D38h                 ; -32 768 .. 32 767               : 80 00h .. 7F FFh
	  db 97 		  ; -128 .. 127                     : 80h .. 7Fh
	 y db ?
	   dd 800197B1h,88DB036Eh   ;0 .. 4 294 967 294               : 00 00 00 00h .. FF FF FF FFh
	   dw 31945; 7CC9h          ;0 .. 65 535                      : 00 00h .. FF FFh
	  db -37		  ;0 .. 255                         : 00h .. FFh
	 len = $-y-1
