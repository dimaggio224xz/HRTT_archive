.model small
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
;������� �����業��     Minimum    [1.1754943E-38  ..  3.4028234E+38]   Maximum
;����� �����祭��    Underflow [-0.0000001E-38]  [+0.0000002E+38]  Overflow 
X DD 19.175387E-7;
   DD -9421.1754E+3;
   DD 3.34E+7;
   DD 3.4025678E+7;
Y DD 0.00
    DD -0.94228;
   DD 100.90E-7;
   DD -17800.82377;
z dd 4 dup (?)                                       ;����� �i� ���
stat dw ?                                               ;��� ᫮�� �⠭�
mes0 db '                   EXECUTE MULTIPLICATION COPROCESSOR  PENTIUM',0dh,0ah,'$'
mes1 db '                          Operand X:','$'
mes2 db '                          Operand Y:','$'
mes3 db '                          Result   :','$'
mes4 db '                             Exception Overflow', 0ah,0dh, '$'
mes5 db '                             Exception Underflow', 0ah,0dh,'$'
mes6 db '                             Exception Absents', 0ah,0dh, '$'
mes7 db '                 STOP TESTING MULTIPLICATION COPROCESSOR PENTIUM',0ah,0dh,'$'
 .code
main: mov ax,@data
        mov ds,ax
        out_str mes0
       lea bx, x                      ;?�i�i��i���i� 
       lea si, y                       ;ॣi���i� 
       lea di, z                       ;����
       mov cx,4                                     
  nxt:finit                            ;?�i�i��i���i�  �i������
       cursor
       fld dword ptr [bx]       ;���訩 ���࠭� � �i������
       fmul dword  ptr [si]     ;�������� � �?������?
       fstp dword  ptr[di]      ;���०���� � ���'��i �㬨
       fstsw stat                    ;���०���� � ���'��i ᫮�� �⠭�
       out_str mes1               ;��������� ���讣�
       scr_ddw bx                 ;���࠭��
       out_str mes2              ;��������� ��㣣���
       scr_ddw si                  ;���࠭��
       out_str mes3              ;��������� �� ��࠭
       scr_ddw di                  ;�㬨
       Test word ptr stat, 8    ;��९�������
       jz exe                          ;�����
       out_str mes4              ;��९�������
       jmp et                        ;������
exe:Test word ptr stat, 16  ;��⨯�९������� 
       jz stp                            ;�����
       out_str mes5              ;��⨯�९������� 
       jmp et                        ;������
 stp:out_str mes6              ;�����祭�� �i����i
   et: add bx, 4                   ;��i��
       add si, 4                     ;����
       add di,4                     ;�������i�
      dec cx                        ;� �i�쪮��i
       jz exit                        ;���i� i� 横��
       jmp nxt                     ;����७�� 横��
exit:cursor
      out_str mes7             ;�����襭�� �ணࠬ�
       mov ax,4c00h           ;����୥���
       int 21h                      ;� ���
       end main
