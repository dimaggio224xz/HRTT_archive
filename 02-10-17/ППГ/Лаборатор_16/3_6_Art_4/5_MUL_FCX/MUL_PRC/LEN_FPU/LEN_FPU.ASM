.model small               ;���᫥��� ������� ����
.stack 256
out_str macro str         ;��������� ���i窨
        mov dx,offset str
        mov ah,9
        int 21h
        endm
 cursor macro           ;��६i饭�� ������
        mov ah,2
        mov dl,0ah       ;�� ���� ���i��
        int 21h
        mov dl,0dh       ;� ���⮪ ���i窨
        int 21h
        endm
scr_ddw macro adr         ;��������� �����
        local nxt
       push bx
       push cx
       mov bx, adr    ;���� ��i���� Single
       add bx, 3        ;���� ���讣� ����� ��i���� Single
       mov cx,4        ;�i��i��� ����i� �������� �����
  nxt:scr_byt
        dec bx
        loop nxt
        pop cx
        pop bx
       mov ah,2
       mov dl, 'H'
       int 21h	
       cursor
       endm
                              scr_byt macro 		    ;��������� ������ �����
	                     local comp,symb,scrn,exit
		mov ah,2		     ;�㭪�i� ��⥬���� ���ਢ����
		mov dh,1		     ;��⠭���� �࠯�� �����㢠�
		mov dl,[bx]                            ;��।�� ⥪箣� �����
		shr dl,4	       ;��।�� ����� ��ࠤ� � �������
	           comp:cmp dl,10		      ;���i��ﭭ� � ����⪮�
		jnc symb		       ;����i� �i��� ��� �i��� ������
		add dl,30h	      ;���㢠��� ASCII ᨬ���� �ᥫ 0,1,..,9
		jmp scrn		       ;����i� �� ���i� ᨬ����
	           symb:add dl,37h	       ;���㢠��� ASCII ᨬ���� �ᥫ 10,11,..,15
	             scrn:int 21h		      ;���i� ᨬ����
		or dh,dh		      ;����i�
		jz exit 		      ;�࠯�� �����㢠�
		mov dh,0		     ;����  �࠯�� �����㢠�
		mov dl,[bx]   	         ;��।�� ⥪�箣� �����
		and dl,0fh		      ;���㢠��� ������� ��ࠤ�
		jmp comp	     ;����i� �� ��஡�� �������  ��ࠤ�  ᨬ����
	               exit:mov dl,' '		      ;��������� ᨬ����
		int 21h 
                                             endm
.data
R DD 1.5;
L dd  ?
mes db '           Calculation of length of circuit',10, 13,10,'$'
mes0 db '                 Radius R=','$'
mes1 db '                 Length L=','$'
 .code
main: mov ax,@data
        mov ds,ax
out_str mes       ;����� �ணࠬ�
FLD1                ; �����⠦���� ������i  
FADD ST, ST   ;��ପ����� ��i���
FLDPI               ;�����⠦���� pi
FMUL               ;���᫥��� 2*�i
FMUL R           ;���᫥��� ������� 2*�i*R
FST L                ;���०���� ������� 
LEA DI,R           ;�����稪�
LEA SI,L            ;����
out_str mes0              ;��������� ࠤi���
scr_ddw di    
out_str mes1               ;��������� �������
scr_ddw si  
cursor   
       mov ax,4c00h           ;����୥���
       int 21h                      ;� ���
       end main
