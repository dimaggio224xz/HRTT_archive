 ;����� ��������� ��������� �������� � ��� ���������� PENTIUM �������� �. �.
format MZ
push cs 				    
pop ds				  ;������������� �������� ������
push ds
pop ss				  ;������������� �������� �����
 jmp qqq
   macro kay		;������ ���������� ������� �������
	     {local prs
	      mov ah,7
	  prs:int 21h			   ;��������� �� �������������
	      cmp al,'x'
	      jne  prs}
    macro out_str str		    ;����� ���������� ���������
	     {mov dx,str
	      mov ah,9
	      int 21h}
  macro cursor		 ;������� ��������� ������� ��������
	    { mov ah,2
	      mov dl,0dh
	      int 21h
	      mov dl,0ah
	      int 21h }
  macro scr_ddw adr		   ;����� ������ ������
	{
	local nxt
	push si
	mov si,adr
	add si,7
	mov cx,8
    nxt:scr_byt
	dec si
	loop nxt
	pop si
	cursor
	}
  macro scr_byt 		    ;����� ������ �����
	{
	local tst,w_0,w_1
	push bx
	mov bl,128		    ;����� ������������
	mov ah,2		    ;������� ����������
    tst:test [si],bl		    ;������������ ����
	jz w_0			    ;��� ����� ����
	mov dl,'1'
	jmp w_1
    w_0:mov dl,'0'
    w_1:int 21h 		    ;����� ���� �� �����
	shr bl,1
	jne tst
	pop bx
	mov dl,' '
	int 21h
	}
;������ �������� ���������
qqq:
out_str mes21			    ;����� �� ����� ���������� ����������
cursor
cursor
mov esi,a1
mov edi,a2
mov ebx,res
;Packed  SUBtraction Double words
out_str mes1			    ;����� �� ����� ���������� ����������
cursor
out_str mes22
scr_ddw a1
out_str mes23
scr_ddw a2
movq mm0,[esi]
movq mm7,[edi]
psubd mm0,mm7	   ;Packed  SUBtraction Double words   MMX0:=(MMX0) +(MMX7)
movq[ebx],mm0
out_str mes24
scr_ddw res
 cursor
 cursor
;Packed  SUBtraction Unsigned with Saturation Words
 out_str mes2			     ;����� �� ����� ���������� ����������
 cursor
out_str mes22
scr_ddw a1
out_str mes23
scr_ddw a2
movq mm0,[esi]
movq mm7,[edi]
psubusw mm0,mm7       ;Packed SUBtraction Unsigned with Saturation Words    MMX0:=(MMX0+(MMX7)
movq[ebx],mm0
out_str mes24
scr_ddw res
 cursor
 cursor
 ;Packed  SUBtraction signed with Saturation Bytes
  out_str mes3			      ;����� �� ����� ���������� ����������
  cursor
out_str mes22
scr_ddw a1
out_str mes23
scr_ddw a2
movq mm0,[esi]
movq mm7,[edi]
psubsb mm0,mm7	      ;Packed  SUBtraction signed with Saturation Bytes    MMX0:=(MMX0)+(MMX7)
movq[ebx],mm0
out_str mes24
scr_ddw res
cursor
cursor
out_str mes20			    ;����� �� ����� ���������� ����������
cursor
cursor
kay
mov ax, 4c00h
int 21h
 mes21 db '   TECHNOLOGY MMX SUBTRACTION MMX0:=(MMX0)-(MMX7) THE PENTIUM PROCESSOR START',0ah,0dh,'$'
 mes20 db '   TECHNOLOGY MMX SUBTRACTION MMX0:=(MMX0)-(MMX7) THE PENTIUM PROCESSOR STOP',0ah,0dh,'$'
	mes22 db 'Pack_X: ','$'
	mes23 db 'Pack_Y: ','$'
	mes24 db 'Pack_Z: ','$'
      mes1 db '   PSUBD mm0,mm7  ;Packed SUBtraction Double word   ',0ah,0dh,'$'
      mes2 db '   PSUBUSW mm0,mm7;Packed SUBtraction Unsigned with Saturation Word',0ah,0dh,'$'
      mes3 db '   PSUBSB mm0,mm7 ;Packed SUBtraction signed with Saturation Bytes',0ah,0dh,'$'
	a1 db 0c6h, 0d5h, 82h, 4fh, 0a4h, 50h, 0a6h, 0E9h
	a2 db 3dh, 76h, 0f4h, 0bah,  0c8h, 16h, 0aah, 37h
       res db a2-a1 dup(' ')




