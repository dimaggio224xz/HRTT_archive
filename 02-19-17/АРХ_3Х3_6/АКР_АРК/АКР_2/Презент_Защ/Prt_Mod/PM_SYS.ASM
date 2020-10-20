 ;Листинг програми захищеного режиму
use32
format mz
push cs
pop ds			       ;Ініціалізація сегменту даних
 jmp qqq
    macro out_str str	       ;Макрос виведення повідомлення
	     {mov dx,str
	      mov ah,9
	      int 21h}			    
	      macro kay        ;Макрос очікування натиску клавиші
	     {local prs
	      mov ah,7
	  prs:int 21h	  
	      cmp al,'x'
	      jne  prs}
	macro cursor	      ;Макрос переміщення екранного курсору
	    { mov ah,2
	      mov dl,0dh
	      int 21h	      ;на наступну стрічку
	      mov dl,0ah
	      int 21h }       ;та у її початок
	macro curs	      ;Макрос переміщення екранного курсору
	    { mov ah,2
	      mov dl,20h
	      int 21h }
	macro hex	      ;Макрос друку символу
	    { mov ah,2
	      mov dl,'h'
	      int 21h } 		
	
	macro scr_byt rr		    ;Виведення одного байту
	 {local comp,symb,scrn,exit
		mov ah,2		     ;Функція системного переривання
		mov dh,1		     ;Установка прапора користувача
		mov dl,rr		     ;Передача поточного байту
		shr dl,4		     ;Передача старшої тетради в молодшу
	   comp:cmp dl,10		     ;Порівняння з десяткою
		jnc symb		     ;Символ більше або дорівнює десять
		add dl,30h	     ;Формування ASCII символу чисел 0,1,..,9
		jmp  scrn		     ;Перехід на вивід символу
	       symb:add dl,37h		     ;Формування ASCII символу чисел 10,11,..,15
		 scrn:int 21h		     ;Виведення символу
		or dh,dh		     ;Аналіз
		jz exit 		     ;прапора користувача
		mov dh,0		     ;Скид  прапора користувача
		mov dl,rr		     ;Передача текучого байту
		and dl,0fh		     ;Формування молодшої тетради
		jmp comp		     ;Перехід на обробку молодшої  тетради  символу
		    exit:nop }
qqq:;Початок основної програми

cursor
cursor
out_str mes21	 ;Виведення на екран текстового повідомлення
cursor
cursor

mov eax,CR0
or eax,1
mov  CR0,eax
jmp $+2
LLDT [sel_ldt]
SLDT cx
out_str mes19
scr_byt ch
scr_byt cl
curs
hex
cursor
cursor

mov SS, [sel_ss]
out_str mes18
mov cx,SS
scr_byt ch
scr_byt cl
curs
hex
cursor
cursor

LTR [sel_tr]
STR cx
out_str mes17
scr_byt ch
scr_byt cl
curs
hex
cursor
cursor

out_str mes22
;LGDT [base_lim_?]
SGDT pword [buf]
mov cx,word[buf+4]
scr_byt ch
scr_byt cl
mov cx,word[buf+2]
scr_byt ch
scr_byt cl
curs
mov cx,word[buf]
scr_byt ch
scr_byt cl
curs
hex
cursor
cursor

out_str mes23
;LIDT [base_lim_?]
SIDT pword [buf]
mov cx,word[buf+4]
scr_byt ch
scr_byt cl
mov cx,word[buf+2]
scr_byt ch
scr_byt cl
curs
mov cx,word[buf]
scr_byt ch
scr_byt cl
curs
hex
cursor
cursor

cursor
out_str mes24
cursor
kay
mov ax, 4c00h		    ;Повернення в операційну
int 21h 		    ;систему комп’ютера
			    ;Виведення на екран текстового повідомлення
	mes21 db '               Study of system registers to PM start',0ah,0dh,'$'
	mes20 db '               ARITHMETIC PACKED WORDS STOP',0ah,0dh,'$'
	mes22 db '               State GDTR: ','$'
	mes19 db '               State LDTR: ','$'
	mes18 db '               State   SS: ','$'
	mes17 db '               State   TR: ','$'
	mes23 db '               State IDTR: ','$'
	mes24 db '               Study of system registers to PM stop',0ah,0dh,'$'
    base_lim_? dp 8003f40006ffh
       sel_ldt dw 04b2h
	sel_ss dw 045ah
	sel_tr dw 06b0h
	   buf dp ?