format mz ;������� �������� ���������� ������
push cs
pop ds			;������������ �������� �����
jmp qqq
       macro out_str mes       ;������ ��������� �����������
	     {mov dx,mes
	      mov ah,9
	      int 21h}
	macro kay	  ;������ ���������� ������� �������
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
	macro curs	       ;������ �������� 
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
		mov dl,[bx]	     ;�������� ��������� �����
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
		mov dl,[bx]	     ;�������� �������� �����
		and dl,0fh		     ;���������� ������� �������
		jmp comp		     ;������� �� ������� �������  �������  �������
		   exit:nop }
	   macro scr_quw m,n	   ;��������� ����������� m, ����� n �����
		 {local nxt
		out_str m
		add bx,n-1	    ;����������� �� ������� ����
		mov cx,n		    ;ʳ������ ���
			    nxt: scr_byt		    ;��������� �� ����� ����� �������
		curs		    ;������� ���� �������
		dec bx		    ;���� ������
		loop nxt		    ;���������� ��� �����
		hex		    ;���� ������ �
		cursor}
	   macro bas_ind adr,sel	;������ ���������� ����������
	     {mov [xxx],dword 0 	     ;��� ��������� ������
	      mov ax,word [adr+2]	    ;������ �� ����������
	      or word[xxx],ax		   ;���� ��� ������������
	      mov al,byte [adr+4]	   ; �������� �����
	      or byte [xxx+2],al		 
	      mov al,byte [adr+7]		
	      or byte [xxx+3],al
	      and [sel],0fff8h
	      xor eax,eax
	      mov ax,[sel]
	      add [xxx],eax
	      int 21h}
	  macro bas_seg dsc	      ;������ ���������� ����������
	   {mov [xxx],dword 0	 ;��� ��������� ������
	    mov ax,word[dsc+2]	;�� �����������
	    or word[xxx],ax
	    mov al,byte[dsc+4]
	    or byte[xxx+2],al
	    mov al,byte[dsc+7]
	    or byte[xxx+3],al}
qqq:cursor	;������� ������� ��������
out_str mes00
cursor
out_str mes01	 ;��������� �� ����� ���������� �����������
out_str mes02
cursor
out_str mes03
cursor
out_str mes00
cursor
cursor
	 mov bx,gdtr
	 scr_quw mes04,6
	 cursor
	 mov eax,dword[gdtr+2]
	 mov dword[gdtr],eax
	 mov bx,gdtr
	 scr_quw mes05,4
	 cursor
	 mov bx,ldtr
	 scr_quw mes06,2
	 cursor
     and [ldtr],0fff8h
     mov ax,[ldtr]
     and eax,0ffffh
     mov dword [xxx],eax
     mov eax,dword[gdtr]
     add dword[xxx],eax
	 mov bx,xxx
	 scr_quw mes07,4
	 cursor
	  mov bx,dldt
	 scr_quw mes08,8
	 cursor
      bas_seg dldt
      mov bx,xxx
      scr_quw mes09,4
      cursor
	 mov bx,sds
	 scr_quw mes10,2
	 cursor
   bas_ind dldt,sds
		    mov bx,xxx
	 scr_quw mes11,4
	 cursor
	  mov bx,dds
	 scr_quw mes12,8
	 cursor
		       bas_seg dds
		       mov bx,xxx
		       scr_quw mes13,4
cursor
mov bx, xxx
mov [xxx],dword aea
scr_quw mes14,4
 cursor
   bas_seg dds
   mov bx,xxx
   add [xxx],dword aea
   scr_quw mes15,4 
mov bx, xxx
mov [xxx],dword mem
cursor
scr_quw mes16,4
mov bx, xxx
mov [xxx],dword dxe
cursor
scr_quw mes17,4
mov edx,dword dxe
sub edx,mem
pushfd
mov bx,xxx
mov [xxx],edx
cursor
scr_quw mes18,4
mov bx,xxx
popd [xxx]
cursor
scr_quw mes19,4
cursor
cursor
out_str mes00
cursor
out_str mes20
out_str mes00
cursor
kay				     ;���������� ������
mov ax, 4c00h	  ; ���������� � ����������
int 21h 		 ;������� ���������
	mes00 db '             __________________________________________________________',0dh,0ah,'$'
	mes01 db '             *       Control work after a text of administration      *',0ah,0dh,0ah,'$'
	mes02 db '             *  Educational discipline is "Architecture of computers" *',0ah,0dh,'$'
	mes03 db '             *     The student of group OT-324 Ivan Petrov executed   *','$'
	mes04 db '             01 State system register    GDTR: ','$';��������� �� ����� ���������� �����������
	mes05 db '             02 State base address BASE32_GDT: ','$'
	mes06 db '             03 State system register    LDTR: ','$'
	mes07 db '             04 State address descriptor LDTR: ','$'
	mes08 db '             05 State system descriptor  LDTR: ','$'
	mes09 db '             06 State base address BASE32_LDT: ','$'
	mes10 db '             07 State selector segment     DS: ','$'
	mes11 db '             08 State address descriptor   DS: ','$'
	mes12 db '             09 State descriptor segment   DS: ','$'
	mes13 db '             10 State base address  BASE32_DS: ','$'
	mes14 db '             11 State ([EBX]+[EDI*4]+DISP) EA: ','$'
	mes15 db '             12 State address operand      DS: ','$'
	mes16 db '             13 State operand to memory   MEM: ','$'
	mes17 db '             14 State before SUB EDX,MEM  EDX: ','$'
	mes18 db '             15 State after  SUB EDX,MEM  EDX: ','$'
	mes19 db '             16 State flags register      EFX: ','$'
	mes20 db '             *           A teacher Alex Bezditko checked              *',0ah,0dh,'$'
	   dxe = 896202057		     ;�������� ���� ������� �������� edx
	   aea = 244a2h+66140h*4h-2015+22+11; [EBX]+[EDI*4]+DISP  DISP=-2015+d+m d=22 m=11
	   mem = 211842894  ;������ ������� � ���'�� �������  SUB EDX,[EBX]+[EDI*4]+DISP
	  gdtr dq 54864783ffffh 	;������ ��������� ������������ �������
	  ldtr dw 3373h 		       ;������ �������� ������������ �������
	  dldt dq 7777ffff7740e277h;���������� �������� ������� ������ � ��������� �������
	   sds dw 0EEEBh		      ;�������� �������� �����
	   dds dq 744ff3445566ffffh ;���������� �������� ����� ������ � ��������� ������� 
		      xxx dd ?				      ;����� � ����� � �������� �����