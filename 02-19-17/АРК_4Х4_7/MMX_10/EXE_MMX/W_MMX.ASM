
;������� �������� ������� ������� ��� � ��� ����������
format MZ
push cs
pop ds				  ;������������ �������� �����
 jmp qqq
    macro out_str str		  ;������ ��������� �����������
	     {mov dx,str
	      mov ah,9
	      int 21h}			    ;��������� �� �������������
	      macro kay 	   ;������ ���������� ������� �������
	     {local prs
	      mov ah,7
	  prs:int 21h			   ;��������� �� �������������
	      cmp al,'x'
	      jne  prs}
	macro cursor		  ;������ ���������� ��������� �������
	    { mov ah,2
	      mov dl,0dh
	      int 21h			     ;�� �������� ������
	      mov dl,0ah
	      int 21h } 		      ;�� � �� �������
	macro scr_ddw adr	   ; ��������� ������ �����
       {local nxt,nte
	mov ah,2
	push bp
	push si 			 ;��������� ����������
	mov si,adr			;������ �����
	add si,7			;������ ��
	mov cx,4
    nte:mov bp,2			;�������� �����
    nxt:scr_byt 		       ;���� ������ �����
	dec si
	dec bp
	jnz nxt
	mov dl,''		 ;��������� �� �����
	int 21h
	loop nte		  ;�������� ��������� �� �������
	mov dl,'H'		  ;��������� �� �����
	int 21h 		  ;�������
	pop si
	pop bp} 		     ;���������� �������
	macro scr_byt			     ;��������� ������ �����
	 {local comp,symb,scrn,exit
		mov ah,2		     ;������� ���������� �����������
		mov dh,1		     ;��������� ������� �����������
		mov dl,[si]		     ;�������� ��������� �����
		shr dl,4		     ;�������� ������ ������� � �������
	   comp:cmp dl,10		     ;��������� � ��������
		jnc symb		     ;������ ����� ��� ������� ������
		add dl,30h		     ;���������� ASCII ������� ����� 0,1,..,9
		jmp  scrn		   ;������� �� ���� �������
	   symb:add dl,37h	  ;���������� ASCII ������� ����� 10,11,..,15
	   scrn:int 21h 		     ; ��������� �������
		or dh,dh		     ;�����
		jz exit 		     ;������� �����������
		mov dh,0		     ;����  ������� �����������
		mov dl,[si]		     ;�������� �������� �����
		and dl,0fh		     ;���������� ������� �������
		jmp comp	     ;������� �� ������� �������  �������  �������
	   exit:nop }
qqq:					   ;������� ������� ��������
out_str mes21		    ;��������� �� ����� ���������� �����������
cursor				    ;����������
mov esi,a1			    ;������������
mov edi,a2			    ;��������
mov ebx,res			    ;���������
out_str mes1			    ;��������� �� ����� ���������� �����������
out_str mes22			    ;��������� �� ����� ���������� �����������
scr_ddw a1
cursor				   ;��������� �� �����  ������� ������ ��������
out_str mes23			    ;��������� �� ����� ���������� �����������
scr_ddw a2
cursor				   ;��������� �� �����  ������� ������ ��������
movq mm0,[esi]			    ;������������ ������� ������ � ��� ����������
paddusw mm0,[edi]	    ; Packed ADDitin Unsigned with Saturation Word
movq[ebx],mm0			    ;���������� ������ ���� � �����
out_str mes24			    ;��������� �� ����� ���������� �����������
scr_ddw res			    ;��������� �� ����� ���� ������ ��������
cursor
cursor
out_str mes2
out_str mes23			 ;��������� �� ����� ���������� �����������
scr_ddw a1
cursor				   ;��������� �� �����  ������� ������ ��������
out_str mes23			    ;��������� �� ����� ���������� �����������
scr_ddw a2
cursor				   ;��������� �� �����  ������� ������ ��������
movq mm0,[esi]			    ;������������ ������� ������ � ��� ����������
psubsw mm0,[edi]		;Packed SUBtractin signed with Saturation Word
movq[ebx],mm0			    ;���������� ������ ���� � �����
out_str mes24			    ;��������� �� ����� ���������� �����������
scr_ddw res			    ;��������� �� ����� ���� ������ ��������
cursor
cursor
out_str mes20			    ;��������� �� ����� ���������� �����������
cursor
kay
mov ax, 4c00h		    ;���������� � ����������
int 21h 			    ;������� ���������
	mes21 db '               ARITHMETIC PACKED WORDS START',0ah,0dh,'$'
	mes20 db '               ARITHMETIC PACKED WORDS STOP',0ah,0dh,'$'
	mes22 db '               Pack_X: ','$'
	mes23 db '               Pack_Y: ','$'
	mes24 db '               Pack_Z: ','$'
	mes1 db '                    PADDUSW mm1, mm2/m64   ',0ah,0dh,'$'
	mes2 db '                    PSUBSW mm1, mm2/m64 ',0ah,0dh,'$'
	a1 db  45h,0BAh,6Eh,0D5h,23h,09h,9Ah,3Fh
	a2 db  0C7h,73h,00h,00h,00h,80h,00h,00h
	res db a2-a1 dup(' ')




