     format mz		;�������� �������� ������������
     push cs
     pop ds			    ;������������ �������� �����
     jmp qqq

       macro out_str mes       ;������ ��������� �����������
	     {mov dx,mes
	      mov ah,9
	      int 21h}

	macro kay	    ;������ ���������� ������� �������
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
	      int 21h}	       ;�� � �� �������

	macro curs		;������ ���������� ��������� �������
	     {mov ah,2
	      mov dl,20h
	      int 21h}

	macro hex	       ;������ ����� �������
	    { mov ah,2
	      mov dl,'h'
	      int 21h }

	  macro scr_byt 		      ;��������� ������ �����
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

	  macro scr_quw m,t,n		     ;��������� ����������� m, ����� �� t ������� n �����
	 {local nxt
		out_str m
		mov si,t		    ;�������� ������
		add si,n-1		    ;����������� �� ������� ����
		mov cx,n		    ;ʳ������ ���
	   nxt: scr_byt 		    ;��������� �� ����� ����� �������
		curs			    ;������� ���� �������
		dec si			    ;���� ������
		loop nxt		    ;���������� ��� �����
		hex			    ;���� ������ �
		cursor
		cursor}

 qqq:cursor		    ;������� ��������
     cursor
     out_str me1	    ;��������� �� ����� ���������� �����������
     cursor
     cursor
     finit
     scr_quw mes1,X1,L1     ;���� � ����������� ������
     scr_quw mes2,X2,L2     ;����� Single ��������
     mov bx,X1		    ;������ �������� �����
     fld dword [bx]	    ;�������� �� �������
     mov bx,X2		    ;������ ������� �����
     fadd  dword [bx]	    ;��������� � �����������
     mov bx,X3		    ;������ ����������
     fstp dword [bx]	    ;���������� ����������
     scr_quw mes3,X3,L3     ;���� ����������
     mov bx,S1		    ;������ ����� ���������
     FSTCW  [bx]	    ;STore  Control Word;  MEM:= (CWR)
     scr_quw ms1,S1,M1	    ;���� ����� ���������
     mov bx,S2		    ;������ ����� �����
     FSTCW  [bx]	    ;STore  Control Word;  MEM:= (SWR)
     scr_quw ms2,S2,M2	    ;���� ����� �����
     cursor
     out_str me2	    ;��������� �� ����� ���������� �����������
     kay			 ;���������� ������� ������
     mov ax,4c00h		 ;���������� � ����������
     int 21h			 ;������� ����'�����
	me1 db '          Study of arithmetic coprocessor start',0ah,0dh,'$'
	ms1 db '         State CW : ','$'
	ms2 db '         State SW : ','$'
	mes1 db '               X1 : ','$'
	mes2 db '               X2 : ','$'
	mes3 db '            X1+X2 : ','$'
	me2 db '         Study of arithmetic coprocessor  stop','$'
      X1 DD 7645.67  ;������ �������
      L1=$-X1	     ;�� ���� ���������
      X2 DD -7645.67 ;������ �������
      L2=$-X2	     ;�� ���� ���������
      X3 DD ?	     ;��������� ���������� � �����������
      L3=$-X3	     ;�� ���� ���������
      S1 DD ?	     ;���������� ����� ���������
      M1=$-S1	     ;�� ���� ���������
      S2 DD ?	     ;���������� ����� �����
      M2=$-S2	     ;�� ���� ���������