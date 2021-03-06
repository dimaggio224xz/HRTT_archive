      format mz 		     ;��������� �������� �������� ������ EXTENDED
     push cs
     pop ds			    ;������������ �������� �����
     jmp qqq

       macro out_str str       ;������ ��������� �����������
	     {mov dx,str
	      mov ah,9
	      int 21h}

	macro kay	 ;������ ���������� ������� �������
       {local prs
	      mov ah,7
	  prs:int 21h
	      cmp al,'x'
	      jne  prs}

	macro cursor	       ;������ ���������� ��������� �������
	     {mov ah,2
	      mov dl,0dh
	      int 21h	       ;�� �������� ������
	      mov dl,0ah
	      int 21h}	      ;�� � �� �������

	macro curs	       ;������ ���������� ��������� �������
	     {mov ah,2
	      mov dl,20h
	      int 21h}

	macro hex	       ;������ ����� �������
	    { mov ah,2
	      mov dl,'h'
	      int 21h }

	  macro scr_byt 		     ;��������� ������ �����
	 {local comp,symb,scrn,exit
		mov ah,2		     ;������� ���������� �����������
		mov dh,1		     ;��������� ������� �����������
		mov dl,[si]		     ;�������� ��������� �����
		shr dl,4		     ;�������� ������ ������� � �������
	   comp:cmp dl,10		     ;��������� � ��������
		jnc symb		     ;������ ����� ��� ������� ������
		add dl,30h		     ;���������� ASCII ������� ����� 0,1,..,9
		jmp  scrn		     ;������� �� ���� �������
	   symb:add dl,37h		     ;���������� ASCII ������� ����� 10,11,..,15
	   scrn:int 21h 		     ;��������� �������
		or dh,dh		     ;�����
		jz exit 		     ;������� �����������
		mov dh,0		     ;����  ������� �����������
		mov dl,[si]		     ;�������� �������� �����
		and dl,0fh		     ;���������� ������� �������
		jmp comp		     ;������� �� ������� �������  �������  �������
	   exit:nop }

	  macro scr_quw t,n		      ;��������� �� ����� ������ �����
	 {local nxt,tyu
		push ax
		mov si,t		    ;�������� ������
		add si,n-1		      ;����������� �� ������� ��
		mov cx,n		   ;ʳ������ ���
	   nxt: scr_byt 		    ;��������� �� ����� ����� �������
	  ; mov ax,cx
	  ; dec ax
	  ; mov dl,4
	  ; div dl
	   ;or ah,ah
	   ;jnz tyu
		curs
		; curs
	  ; tyu: curs;������� ���� �������
		dec si			    ;���� ������
		loop nxt		    ;���������� ��� �����
		hex			    ;���� ������ �
		cursor
		cursor
		pop ax}

 qqq:cursor		    ;������� ��������
     cursor
     out_str mes1	     ;��������� �� ����� ���������� �����������
     cursor

   ;finit
   ;fld dword [x]
  ; fstp qword [y]
   out_str mes2
   scr_quw x,4
   out_str mes3
   scr_quw y,10

   out_str mes4
   scr_quw w,8
   out_str mes5
   scr_quw w,16
; mov ebx,x
 ;emms
;  mov ebx,x
; movq mm0,[ebx]
;  mov ebx,y
 ; movq [ebx],mm0
 ;  out_str mes10
 ; scr_quw y,8
 ooo:out_str mes6		 ;��������� �� ����� ���������� �����������
     kay			 ;���������� ������� ������
     mov ax,4c00h		 ;���������� � ����������
     int 21h			 ;������� ����'�����
	mes1 db '                   Presentation data to processor PENTIUM start',0ah,0dh,'$'
	mes2 db '  Present LongInteger CPU:                                     ','$'
	mes3 db '     Present Extended FPU:                   ','$'
	mes4 db '       Present Packed MMX:                         ','$'
	mes5 db '       Present String XMM: ','$'
	mes6 db '                   Presentation data to processor PENTIUM stop',0ah,0dh,'$'

	      x  dd  -1294967295 ;               4 294 967 295 = FF FF FF FF
	      y  db  34,255,-98,3,109,-122,99,23,45,-33
	      w  db   -56, 44, 35, 127, -128,50,-50,78
	      z  db   110, 23, 56, -44, -22, 99, 35, 0, 70, -70, 67, -22, 87, 63, 41, 127