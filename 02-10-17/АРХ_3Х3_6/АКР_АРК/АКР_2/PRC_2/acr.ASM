format mz ;Листинг програми контрольної роботи
push cs
pop ds			;Ініціалізація сегменту даних
jmp qqq
       macro out_str mes       ;Макрос виведення повідомлення
	     {mov dx,mes
	      mov ah,9
	      int 21h}
	macro kay	  ;Макрос очікування натиску клавиші
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
	macro curs	       ;Макрос пропуску 
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
		mov dl,[bx]	     ;Передача поточного байту
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
		mov dl,[bx]	     ;Передача текучого байту
		and dl,0fh		     ;Формування молодшої тетради
		jmp comp		     ;Перехід на обробку молодшої  тетради  символу
		   exit:nop }
	   macro scr_quw m,n	   ;Виведення повідомлення m, даних n байтів
		 {local nxt
		out_str m
		add bx,n-1	    ;Переведення на старший байт
		mov cx,n		    ;Кількість слів
			    nxt: scr_byt		    ;Виведення на екран байту символів
		curs		    ;Пропуск місця символу
		dec bx		    ;Зміна адреси
		loop nxt		    ;Повторення або вихід
		hex		    ;Друк симвое Н
		cursor}
	   macro bas_ind adr,sel	;Макрос розпаковки десриптора
	     {mov [xxx],dword 0 	     ;для вилучення базової
	      mov ax,word [adr+2]	    ;адреси та формування
	      or word[xxx],ax		   ;суми при індексуванні
	      mov al,byte [adr+4]	   ; сегменту памяті
	      or byte [xxx+2],al		 
	      mov al,byte [adr+7]		
	      or byte [xxx+3],al
	      and [sel],0fff8h
	      xor eax,eax
	      mov ax,[sel]
	      add [xxx],eax
	      int 21h}
	  macro bas_seg dsc	      ;Макрос розпаковки десриптора
	   {mov [xxx],dword 0	 ;для вилучення базової
	    mov ax,word[dsc+2]	;від дескриптора
	    or word[xxx],ax
	    mov al,byte[dsc+4]
	    or byte[xxx+2],al
	    mov al,byte[dsc+7]
	    or byte[xxx+3],al}
qqq:cursor	;Початок основної програми
out_str mes00
cursor
out_str mes01	 ;Виведення на екран текстового повідомлення
out_str mes02
cursor
out_str mes03
cursor
out_str mes00
cursor
cursor
	 mov bx,gdtr
	 scr_quw mes04,6
	 cursor
	 mov eax,dword[gdtr+2]
	 mov dword[gdtr],eax
	 mov bx,gdtr
	 scr_quw mes05,4
	 cursor
	 mov bx,ldtr
	 scr_quw mes06,2
	 cursor
     and [ldtr],0fff8h
     mov ax,[ldtr]
     and eax,0ffffh
     mov dword [xxx],eax
     mov eax,dword[gdtr]
     add dword[xxx],eax
	 mov bx,xxx
	 scr_quw mes07,4
	 cursor
	  mov bx,dldt
	 scr_quw mes08,8
	 cursor
      bas_seg dldt
      mov bx,xxx
      scr_quw mes09,4
      cursor
	 mov bx,sds
	 scr_quw mes10,2
	 cursor
   bas_ind dldt,sds
		    mov bx,xxx
	 scr_quw mes11,4
	 cursor
	  mov bx,dds
	 scr_quw mes12,8
	 cursor
		       bas_seg dds
		       mov bx,xxx
		       scr_quw mes13,4
cursor
mov bx, xxx
mov [xxx],dword aea
scr_quw mes14,4
 cursor
   bas_seg dds
   mov bx,xxx
   add [xxx],dword aea
   scr_quw mes15,4 
mov bx, xxx
mov [xxx],dword mem
cursor
scr_quw mes16,4
mov bx, xxx
mov [xxx],dword dxe
cursor
scr_quw mes17,4
mov edx,dword dxe
sub edx,mem
pushfd
mov bx,xxx
mov [xxx],edx
cursor
scr_quw mes18,4
mov bx,xxx
popd [xxx]
cursor
scr_quw mes19,4
cursor
cursor
out_str mes00
cursor
out_str mes20
out_str mes00
cursor
kay				     ;Очікування натику
mov ax, 4c00h	  ; Повернення в операційну
int 21h 		 ;систему комп’ютера
	mes00 db '             __________________________________________________________',0dh,0ah,'$'
	mes01 db '             *       Control work after a text of administration      *',0ah,0dh,0ah,'$'
	mes02 db '             *  Educational discipline is "Architecture of computers" *',0ah,0dh,'$'
	mes03 db '             *     The student of group OT-324 Ivan Petrov executed   *','$'
	mes04 db '             01 State system register    GDTR: ','$';Виведення на екран текстового повідомлення
	mes05 db '             02 State base address BASE32_GDT: ','$'
	mes06 db '             03 State system register    LDTR: ','$'
	mes07 db '             04 State address descriptor LDTR: ','$'
	mes08 db '             05 State system descriptor  LDTR: ','$'
	mes09 db '             06 State base address BASE32_LDT: ','$'
	mes10 db '             07 State selector segment     DS: ','$'
	mes11 db '             08 State address descriptor   DS: ','$'
	mes12 db '             09 State descriptor segment   DS: ','$'
	mes13 db '             10 State base address  BASE32_DS: ','$'
	mes14 db '             11 State ([EBX]+[EDI*4]+DISP) EA: ','$'
	mes15 db '             12 State address operand      DS: ','$'
	mes16 db '             13 State operand to memory   MEM: ','$'
	mes17 db '             14 State before SUB EDX,MEM  EDX: ','$'
	mes18 db '             15 State after  SUB EDX,MEM  EDX: ','$'
	mes19 db '             16 State flags register      EFX: ','$'
	mes20 db '             *           A teacher Alex Bezditko checked              *',0ah,0dh,'$'
	   dxe = 896202057		     ;Вихідний стан першого операнду edx
	   aea = 244a2h+66140h*4h-2015+22+11; [EBX]+[EDI*4]+DISP  DISP=-2015+d+m d=22 m=11
	   mem = 211842894  ;Другий операнд у пам'яті команди  SUB EDX,[EBX]+[EDI*4]+DISP
	  gdtr dq 54864783ffffh 	;Регістр глобальної дескрипторної таблиці
	  ldtr dw 3373h 		       ;Регістр локальної дескрипторної таблиці
	  dldt dq 7777ffff7740e277h;Дескриптор локальної таблиці станом у глобальій таблиці
	   sds dw 0EEEBh		      ;Селектор сегменту даних
	   dds dq 744ff3445566ffffh ;Дескриптор сегменту даних станом у локальній таблиці 
		      xxx dd ?				      ;Буфер у памяті з чотирьох байтів