format MZ
push cs
pop ds
push ds
pop ss
jmp mt1
  macro out_str str		  ;Вывод текстового сообщения
	    {
	      mov dx,str
	      mov ah,9
	      int 21h
	     }

  macro cursor			   ;Перевод курсора монитора
	    {
	      mov ah,2
	      mov dl,0dh
	      int 21h
	      mov dl,0ah
	      int 21h
	     }
  macro scr_ddw adr		   ;Вывод пакета байтов
	{
	local nxt
	mov si,adr
	add si,15
	mov cx,16
    nxt:scr_byt
	dec si
	loop nxt
	cursor
	}

  macro scr_byt 		    ;Вывод одного байта
	{
	local tst,w_0,w_1
	mov bl,128
	mov ah,2
    tst:test [si],bl
	jz w_0
	mov dl,'1'
	jmp w_1
    w_0:mov dl,'0'
    w_1:int 21h
	shr bl,1
	jne tst
	mov dl,' '
	int 21h
	}

  macro inp_dat ope		   ;Ввод данных с клавиатуры
	{
	local lpp,rpt,s30,cor,sto
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
	cursor
	}
  macro sym			  ;Вывод ASCII символа
       {
       push ax
       push dx
       mov ah,2
       mov dl,al
       int 21h
       pop dx
       pop ax
       }
 mt1: ;Opr_x:=Opr_x * Opr_y
 out_str mes1
 ; cursor
 out_str mes2
  ;cursor
   scr_ddw Opr_X
    ;cursor
 out_str mes3
 ; out_str mes5
  ; cursor
    inp_dat Opr_Y
    ; cursor
 scr_ddw Opr_Y
 ; cursor
mov edx,Opr_X		 
movups xmm0,[edx]		;MOVe Unaligned four Packed Single precesion float point   
mov edx,Opr_Y
movups xmm7,[edx]		 ;MOVe Unaligned four Packed Single precesion float point    
mulps xmm0,xmm7 		 ;MULtiply Packed Single precesion float point   
movups [edx],xmm0		 ;MOVe Unaligned four Packed Single precesion float point   
out_str mes4
; cursor
  scr_ddw Opr_Y
   ;cursor
;out_str mes6
exit:		
mov ax, 4c00h	
int 21h 	 
Opr_X dd 0.0		; Определение в памяти            
	    dd 0.0		       ; пакета операнда Х      
	    dd 0.0	 ; из четырёх двойных слов
	    dd -51.1e-10	      ; в ХММ формате - SPFP
Opr_Y db 16 dup (?)		       ;Резервирование в памяти 16-ти байт  под операнд Y
	mes1 db '         TECHNOLOGI XMM MULTIPLICATION THE PENTIUM PROCESSOR ',0ah,0dh,'$'
	mes2 db '                              Operand X',0ah,0dh,'$'
	mes3 db '                              Operand Y',0ah,0dh,'$'
	mes4 db '                              Resultat Z',0ah,0dh,'$'
	mes5 db '                           Introduse the key',0ah,0dh,'$'
	mes6 db '                                Finish',0ah,0dh,'$'
     