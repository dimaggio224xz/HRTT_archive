 ;������� �������� ���������� ������
use32
format mz
push cs
pop ds			       ;������������ �������� �����
 jmp qqq
    macro out_str str	       ;������ ��������� �����������
	     {mov dx,str
	      mov ah,9
	      int 21h}			    
	      macro kay        ;������ ���������� ������� �������
	     {local prs
	      mov ah,7
	  prs:int 21h	  
	      cmp al,'x'
	      jne  prs}
	macro cursor	      ;������ ���������� ��������� �������
	    { mov ah,2
	      mov dl,0dh
	      int 21h	      ;�� �������� ������
	      mov dl,0ah
	      int 21h }       ;�� � �� �������
	macro curs	      ;������ ���������� ��������� �������
	    { mov ah,2
	      mov dl,20h
	      int 21h }
	macro hex	      ;������ ����� �������
	    { mov ah,2
	      mov dl,'h'
	      int 21h } 		
	
	macro scr_byt rr		    ;��������� ������ �����
	 {local comp,symb,scrn,exit
		mov ah,2		     ;������� ���������� �����������
		mov dh,1		     ;��������� ������� �����������
		mov dl,rr		     ;�������� ��������� �����
		shr dl,4		     ;�������� ������ ������� � �������
	   comp:cmp dl,10		     ;��������� � ��������
		jnc symb		     ;������ ����� ��� ������� ������
		add dl,30h	     ;���������� ASCII ������� ����� 0,1,..,9
		jmp  scrn		     ;������� �� ���� �������
	       symb:add dl,37h		     ;���������� ASCII ������� ����� 10,11,..,15
		 scrn:int 21h		     ;��������� �������
		or dh,dh		     ;�����
		jz exit 		     ;������� �����������
		mov dh,0		     ;����  ������� �����������
		mov dl,rr		     ;�������� �������� �����
		and dl,0fh		     ;���������� ������� �������
		jmp comp		     ;������� �� ������� �������  �������  �������
		    exit:nop }
qqq:;������� ������� ��������

cursor
cursor
out_str mes21	 ;��������� �� ����� ���������� �����������
cursor
cursor

mov eax,CR0
or eax,1
mov  CR0,eax
jmp $+2
LLDT [sel_ldt]
SLDT cx
out_str mes19
scr_byt ch
scr_byt cl
curs
hex
cursor
cursor

mov SS, [sel_ss]
out_str mes18
mov cx,SS
scr_byt ch
scr_byt cl
curs
hex
cursor
cursor

LTR [sel_tr]
STR cx
out_str mes17
scr_byt ch
scr_byt cl
curs
hex
cursor
cursor

out_str mes22
;LGDT [base_lim_?]
SGDT pword [buf]
mov cx,word[buf+4]
scr_byt ch
scr_byt cl
mov cx,word[buf+2]
scr_byt ch
scr_byt cl
curs
mov cx,word[buf]
scr_byt ch
scr_byt cl
curs
hex
cursor
cursor

out_str mes23
;LIDT [base_lim_?]
SIDT pword [buf]
mov cx,word[buf+4]
scr_byt ch
scr_byt cl
mov cx,word[buf+2]
scr_byt ch
scr_byt cl
curs
mov cx,word[buf]
scr_byt ch
scr_byt cl
curs
hex
cursor
cursor

cursor
out_str mes24
cursor
kay
mov ax, 4c00h		    ;���������� � ����������
int 21h 		    ;������� ���������
			    ;��������� �� ����� ���������� �����������
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