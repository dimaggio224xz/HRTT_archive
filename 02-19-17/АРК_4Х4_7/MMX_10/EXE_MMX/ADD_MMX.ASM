;����� �������� ��������� ��������� � ��� ���������� ������� �.�.
format MZ
push cs 				    
pop ds				  ;������������ �������� �����
push ds
pop ss				  ;������������ �������� �����
 jmp qqq
   macro kay		;������ ���������� ������� �������
	     {local prs
	      mov ah,7
	  prs:int 21h			   ;��������� �� �������������
	      cmp al,'x'
	      jne  prs}
    macro out_str str		  ;������ ��������� �����������
	     {mov dx,str
	      mov ah,9
	      int 21h}		  ;��������� �� �������������
	macro cursor		  ;������ ���������� ��������� �������
	    { mov ah,2
	      mov dl,0dh
	      int 21h		   ;�� �������� ������
	      mov dl,0ah
	      int 21h } 	   ;�� � �� �������
   macro scr_ddw adr		  ;���� ������ �����
       {local nxt
	push si 		  ;��������� ����������
	mov si,adr		  ;������ �����
	add si,7		  ;������ ��
	mov cx,8		  ;�������� �����
    nxt:scr_byt 		  ;���� ������ �����
	dec si			  ;��������� ������
	loop nxt		  ;�������� ��������� �� �������
	mov dl,'H'		  ;��������� �� �����
	int 21h 		  ;�������
	pop si			  ;���������� �������
	cursor}
	macro scr_byt			     ;���� ������ �����
	 {local comp,symb,scrn,exit
		mov ah,2		     ;������� ���������� �����������
		mov dh,1		     ;��������� ������� �����������
		mov dl,[si]		     ;�������� ������� �����
		shr dl,4		     ;�������� ������ ������� � �������
	   comp:cmp dl,10		     ;��������� � ��������
		jnc symb		     ;����� ����� ��� ���� ������
		add dl,30h		     ;���������� ASCII ������� ����� 0,1,..,9
		jmp scrn		     ;������� �� ���� �������
	      symb:add dl,37h		     ;���������� ASCII ������� ����� 10,11,..,15
	      scrn:int 21h		     ;���� �������
		or dh,dh		     ;�����
		jz exit 		     ;������� �����������
		mov dh,0		     ;����  ������� �����������
		mov dl,[si]		     ;�������� �������� �����
		and dl,0fh		     ;���������� ������� �������
		jmp comp		     ;������� �� ������� �������  �������  �������
	    exit:mov dl,' '		     ;���� �������
		int 21h}
qqq: ;������� ������� ��������
out_str mes21			    ;��������� �� ����� ���������� �����������
cursor				    ;����������
cursor				    ;��������� �������
mov esi,a1			    ;������������
mov edi,a2			    ;��������
mov ebx,res			    ;���������
;Packed ADDitin Double words MMX0:=(MMX0)+(MMX7)
out_str mes1			    ;��������� �� ����� ���������� �����������
cursor
out_str mes22			    ;��������� �� ����� ���������� �����������
scr_ddw a1			    ;��������� �� �����  ������� ������ ��������
out_str mes23			    ;��������� �� ����� ���������� �����������
scr_ddw a2			    ;��������� �� �����  ������� ������ ��������
movq mm0,[esi]			    ;������������ ������� ������ � ��� ����������
movq mm7,[edi]			    ;������������ ������� ������ � ��� ����������
paddd mm0,mm7			    ;Packed ADDitin Double words
movq[ebx],mm0			    ;���������� ������ ���� � �������
out_str mes24			    ;��������� �� ����� ���������� �����������
scr_ddw res			    ;��������� �� ����� ���� ������ ��������
 cursor
 cursor
;Packed ADDitin Unsigned with Saturation Words MMX0:=(MMX0)+(MMX7)
out_str mes2			    ;��������� �� ����� ���������� �����������
cursor
out_str mes22			    ;��������� �� ����� ���������� �����������
scr_ddw a1			    ;��������� �� �����  ������� ������ ��������
out_str mes23			    ;��������� �� ����� ���������� �����������
scr_ddw a2			    ;��������� �� �����  ������� ������ ��������
movq mm0,[esi]			    ;������������ ������� ������ � ��� ����������
paddusw mm0,[edi]		    ;Packed ADDitin Unsigned with Saturation Words
movq[ebx],mm0			    ;���������� ������ ���� � �������
out_str mes24			    ;��������� �� ����� ���������� �����������
scr_ddw res			    ;��������� �� ����� ���� ������ ��������
 cursor
 cursor
 ;Packed ADDitin signed with Saturation Bytes  MMX0:=(MMX0) +(MMX7)
out_str mes3			    ;��������� �� ����� ���������� �����������
cursor
out_str mes22			    ;��������� �� ����� ���������� �����������
scr_ddw a1			    ;��������� �� �����  ������� ������ ��������
out_str mes23			    ;��������� �� ����� ���������� �����������
scr_ddw a2			    ;��������� �� �����  ������� ������ ��������
movq mm0,[esi]			    ;������������ ������� ������ � ��� ����������
movq mm7,[edi]			    ;������������ ������� ������ � ��� ����������
paddsb mm0,mm7			    ;Packed ADDitin signed with Saturation Bytes
movq[ebx],mm0			    ;���������� ������ ���� � �������
out_str mes24			    ;��������� �� ����� ���������� �����������
scr_ddw res			    ;��������� �� ����� ���� ������ ��������
cursor
cursor
out_str mes20			    ;��������� �� ����� ���������� �����������
cursor
cursor
kay
mov ax, 4c00h			    ;����������� � ����������
int 21h 			    ;������� ���������
 mes21 db '   TECHNOLOGY ADDITION MMX0:=(MMX0)+(MMX7) THE PENTIUM PROCESSOR START',0ah,0dh,'$'
     mes20 db '   TECHNOLOGY MMX  ADDITION MMX0:=(MMX0)+(MMX7) THE PENTIUM PROCESSOR STOP',0ah,0dh,'$'
	mes22 db '                  Pack_X: ','$'
	mes23 db '                  Pack_Y: ','$'
	mes24 db '                  Pack_Z: ','$'
      mes1 db '      PADDD mm0,mm7  ;Packed ADDition Double word   ',0ah,0dh,'$'
      mes2 db '      PADDUSW mm0,mm7;Packed  ADDition Unsigned with Saturation Word',0ah,0dh,'$'
      mes3 db '      PADDSB mm0,mm7 ;Packed  ADDition signed with Saturation Bytes',0ah,0dh,'$'
	a1 db 0c6h, 0d5h, 82h, 4fh, 0a4h, 50h, 0a6h, 0E9h
	a2 db 3dh, 76h, 0f4h, 0bah,  0c8h, 56h, 0aah, 37h
       res db a2-a1 dup(' ')




