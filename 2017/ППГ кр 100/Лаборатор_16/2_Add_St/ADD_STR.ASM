     format mz			
     push cs
     pop ds
     jmp qqq

       macro out_str mes       ;������ ��������� �����������
	     {mov dx,mes
	      mov ah,9
	      int 21h}

	macro kay	 ;������ ���������� ������� ������
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

	  macro scr_byt 		      ;��������� ������ �����
	 {local comp,symb,scrn,exit
		mov ah,2		     ;������� ���������� �����������
		mov dh,1		     ;��������� ������� �����������
		mov dl,[si]	     ;�������� ��������� �����
		shr dl,4		     ;�������� ������ ������� � �������
	   comp:cmp dl,10		     ;��������� � ��������
		jnc symb		     ;������ ����� ��� ������� ������
		add dl,30h	     ;���������� ASCII ������� ����� 0,1,..,9
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

	  macro scr_quw m,t,n	     ;��������� ����������� m, ����� �� t ������� n �����
	 {local nxt
		out_str m
		mov si,t		    ;�������� ������
		add si,n-1		    ;����������� �� ������� ����
		mov cx,n		    ;ʳ������ ���
	   nxt: scr_byt 		    ;��������� �� ����� ����� �������
		curs		    ;������� ���� �������
		dec si		    ;���� ������
		loop nxt		    ;���������� ��� �����
		hex		    ;���� ������ �
		cursor
		cursor}
qqq:cursor	  ;������� ��������
    out_str mes1	  ;��������� �����������
    cursor
    mov bx,x	  ;������������
    inc bx		  ;�������� ���������
    mov di,y
    inc di		  ;���������� ���������� �����
    mov al,len	  ;���������� �� ������
    or al,al		  ;��������� �������
    jnz arb		  ;������ ���������
    out_str mes7	  ;������ ��������
    jmp stp		  ;����� � ��������
arb:scr_quw mes2,bx,len   ;��������� �������
    scr_quw mes3,di,len   ;�������� �����
    mov cl,4	  ;���������� �������
    mov ax,len	  ;��������
    div cl		  ;���
    mov cl,al	  ;� cl �� ������ � ah
    xor ch,ch	  ;���������� ������
    or cx,cx		  ;������� �������� ���
    pushf		  ;���������� �������� �����������
    jz exn		  ;��������� ��� ����
ccl:popf		;���������� �������� �����������
    mov edx,[di]	;��������� ������� ��������
    adc [bx],edx	;�� ������� � �����
    pushf		;���������� �� ������� ���������� �����������
    sub di,4	;���������� ������� �����
    sub bx,4	;�������
    loop ccl		;�������� �� �� ���� ���� �� �������
exn:cmp ah,0	;�������� ��
    jz ext		;������ ����
nxt:cmp ah,03	;���������� ������ ������� �� ��� �����
    jnz cm1		;���� ����� ������ � ����� �������
lba:popf		;���������� �������� ����������
    mov dx,[di] 	;��������� ���
    adc [bx],dx 	;� �����
    pushf		;���������� ��������� ����������
    cmp ah,2	;���������� ������ ������� �� ��� �����
    jnz lbt		;������� �� ������� ������ �����
ext:popf		;���������
    jmp ovr		;��� �����
lbt:popf		;���������� �������� �����������
    mov dl,[di+2]	;��������� �����
    adc [bx+2],dl	;� ���'��
    jmp ovr		;� ��������� �� �������� ��������
cm1:cmp ah,1	;� ����� �������
    jnz lba		;��� �����
    sub di,2		;� ����� �������
    sub bx,2	;���������
    jmp lbt		;���� ����
ovr:mov bx,x	;������ ����������
    pushf		;����������� �������
    inc bx		;���������� ���������� �����
    scr_quw mes4,bx,len ;��������� ������� ���������� ���������
    popf		;���������� �������
    jo ooo		;� ������������
    out_str mes6	;���� ������������
    jmp stp		;������� �� ���������
ooo:out_str mes5	;� ������������
stp:out_str mes8	;ϳ�������� �����������
    kay 			;���������� ������� ������
    mov ax,4c00h		;���������� � ����������
    int 21h			;������� ����'�����
	mes1 db '                   Study addition of lines of data start',0ah,0dh,'$'
	mes2 db '               Operand_X : ','$'
	mes3 db '               Operand_Y : ','$'
	mes4 db '               Rezult _W : ','$'
	mes5 db '                   A Overflow is present afte addition',0ah,0ah,0dh,'$'
	mes6 db '                   A Overflow absents afte addition',0ah,0dh,0ah,'$'
	mes7 db '                   Not of operands data before addition',0ah,0dh,0ah,'$'
	mes8 db '                   Stop testing addition of lines of data',0ah,0dh,0ah,'$'
	 x db ?
	   dd 0AFFCD09Dh,0F049F924h ; - 2 147 483 648 .. 2 147 483 647: 80 00 00 00h .. 7F FF FF FFh
	   dw 36CDh; 9D38h                 ; -32 768 .. 32 767               : 80 00h .. 7F FFh
	  db 97 		  ; -128 .. 127                     : 80h .. 7Fh
	 y db ?
	   dd 800197B1h,88DB036Eh   ;0 .. 4 294 967 294               : 00 00 00 00h .. FF FF FF FFh
	   dw 31945; 7CC9h          ;0 .. 65 535                      : 00 00h .. FF FFh
	  db -37		  ;0 .. 255                         : 00h .. FFh
	 len = $-y-1
