 ;Листинг програми захищеного режиму
format mz
push cs
pop ds			       ;Ініціалізація сегменту даних
 jmp qqq
   cor procedure
	  pop bx
    sub sp,2
mov byte [bx]+1,0feh
ret
endp;Макрос виведення повідомлення

qqq:call cor
jmp nxt
nxt:nop;
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