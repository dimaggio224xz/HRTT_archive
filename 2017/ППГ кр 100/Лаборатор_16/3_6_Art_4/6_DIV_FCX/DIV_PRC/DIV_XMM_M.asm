format MZ			  ;Дослідження пакетного множення в ХММ розширенні
push cs
pop ds
push ds
pop ss
jmp mt1
  macro out_str str		  ;Вивід текстового повідомлення
	     {push ax
	      mov dx,str
	      mov ah,9		   ;Функція ДОС
	      int 21h
	       pop ax }
	macro cursor		  ;Переведення курсора монитору
	     {mov ah,2		  ;Функція ДОС
	      mov dl,0dh	  ;На початок
	      int 21h		  ;стрічки
	      mov dl,0ah	  ;На другу
	      int 21h}		  ;стрічку
   macro scr_ddw adr		   ;Вивід пакету байтів
       {local nxt
	push si 		  ;Тимчасове збереження
	mov si,adr		  ;Адреса змінної
	add si,15		  ;Регістр та
	mov cx,16		  ;лічильник байтів
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
		shr dl,4		       ;Передача старшої тетради в молодшу
	   comp:cmp dl,10		      ;Порівняння з десяткою
		jnc symb		       ;Симвіл більше або рівен десять
		add dl,30h		      ;Формування ASCII символу чисел 0,1,..,9
		jmp scrn		       ;Перехід на вивід символу
	      symb:add dl,37h		       ;Формування ASCII символу чисел 10,11,..,15
	      scrn:int 21h		      ;Вивід символу
		or dh,dh		      ;Аналіз
		jz exit 		      ;прапора користувача
		mov dh,0		     ;Скид  прапора користувача
		mov dl,[si]		     ;Передача текучого байту
		and dl,0fh		      ;Формування молодшої тетради
		jmp comp		      ;Перехід на обробку молодшої  тетради  символу
	    exit:mov dl,' '		      ;Вивід символу
		int 21h}
  macro inp_dat ope			     ;Введення  данних з клавиатури
       {local lpp,rpt,s30,cor,sto
	mov ah,7
	mov bx,ope
	add bx,15
	mov dh,16
    lpp:mov dl,2
    rpt:int 21h
	cmp al,30h
	jb rpt
	cmp al,3ah
	jb s30
	cmp al,61h
	jb rpt
	cmp al,67h
	jnb rpt
	sym
	sub al,57h
	jmp cor
     s30:sym
	sub al,30h
       cor:dec dl
	je sto
	mov cl,4
	shl al,cl
	mov [bx],al
	jmp rpt
    sto:add [bx],al
	push ax
	push dx
	mov ah,2
	mov dl,' '
	int 21h
	pop dx
	pop ax
	dec bx
	dec dh
	jne lpp
	mov ah,2
	mov dl,'h'
	int 21h}
  macro sym			  ;Вивід ASCII символу
      {push ax
       push dx
       mov ah,2
       mov dl,al
       int 21h
       pop dx
       pop ax}
 mt1:mov di,4
 out_str mes1				   ;TECHNOLOGI XMM DIVISION  THE PENTIUM PROCESSOR
 nxt: mov [mm32],1f80h
 LDMXCSR [mm32] 			   ;LoaD MXCSR
 out_str mes2				   ;Packed_Operand_X:
   scr_ddw Opr_X
   out_str mes3 			   ;Packed_Operand_Y:
      inp_dat Opr_Y
       out_str mes6
  scr_ddw Opr_Y
  mov edx,Opr_X
movups xmm0,[edx]		 ;MOVe Unaligned four Packed Single precesion float point
mov edx,Opr_Y
movups xmm7,[edx]		 ;MOVe Unaligned four Packed Single precesion float point    
divps xmm0,xmm7 		 ;MULtiply Packed Single precesion float point   
movups [edx],xmm0		 ;MOVe Unaligned four Packed Single precesion float point
stmxcsr [mm32]
out_str mes4					     ; Packed_Product_Z: 
 scr_ddw Opr_Y				    
 cursor
 mov eax,[mm32]
 test eax,8
 jz nnrm
  out_str mes8
 nnrm: test eax,16
  jz nonrm
  out_str mes9
 nonrm: test eax,24
   jnz tpr
  out_str mes7
 tpr:dec di
 jnz nxt
 out_str mes5			     ;STOP TESTING TECHNOLOGI XMM DIVISION THE PENTIUM PROCESSOR
      mov ax,4c00h
      int 21h
		  Opr_X dd 1.1754942E-37	; Визначення в памяті
			dd 1.1754943E-37	 ; пакету операндуа Х
			dd 3.4028236E+37	 ; із 4-х подвоєних слів
			dd 3.4028234E+37	 ; в ХММ форматі - SPFP
		  Opr_Y dd 16 dup (?)	       ; Резервування в памяти 16-ти елементів  підд операнд Y
		   mm32 dd ?
	mes1 db '               TECHNOLOGI XMM DIVISION THE PENTIUM PROCESSOR ',0ah,0dh,0ah,'$'
	mes2 db '       Packed_Dividend_X: $'
	mes3 db '       Packed_Divisor_Y : $'
	mes4 db '       Packed_Quotient_Z: $'
	mes5 db '         STOP TESTING TECHNOLOGI XMM DIVISION THE PENTIUM PROCESSOR ',0ah,0dh,0ah,'$'
	mes6 db 0dh,'       Packed_Divisor_Y : $'
	mes7 db '                             EXCEPTION ABSENTS ',0ah,0dh,0ah,'$'
	mes8 db '                             EXCEPTION OVERFLOW',0ah,0dh,0ah,'$'
	mes9 db '                             EXCEPTION UNDERFLOW',0ah,0dh,0ah,'$'