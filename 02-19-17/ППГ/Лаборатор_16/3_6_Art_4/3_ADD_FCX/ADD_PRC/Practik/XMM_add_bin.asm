format MZ
push cs 				    
pop ds				  ;������������� �������� ������
push ds
pop ss				  ;������������� �������� �����
jmp mt1 			  ;������� �� �������� ���������
      mes db '           TECHNOLOGY XMM THE PENTIUM PROCESSOR ',0ah,0dh,'$'
   Oper1 db '           PACKED OPERAND1 FORMAT SPFP ',0ah,0dh,'$'
   Oper2 db '           PACKED OPERAND2 FORMAT SPFP',0ah,0dh,'$'
   Sum	 db '       PACKED SUMMA FORMAT SPFP ',0ah,0dh,'$'
	a1 dd -100.0, 0.0, 0.0,-51.7 ; �������������� ������ ��� �����
	a2 dd 0.1, 0.0, 0.0, -90.9 ;��������� � ���������� �� ������ 
	res dd a2-a1 dup('?')	     ; ��������� � �����������  �������  SPFP     

  macro out_str str		  ;����� ���������� ���������
	    {
	      mov dx,str
	      mov ah,9
	      int 21h
	     }

  macro cursor		 ;������� ��������� ������� ��������
	    { mov ah,2
	      mov dl,0dh
	      int 21h
	      mov dl,0ah
	      int 21h }
  macro scr_ddw adr		   ;����� ������ ������
	{
	local nxt
	mov si,adr
	add si,15
	mov cx,16
    nxt:scr_byt
	dec si
	loop nxt
	cursor
	}

  macro scr_byt 		    ;����� ������ �����
	{
	local tst,w_0,w_1
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
	mov dl,' '
	int 21h
	}
 
 mt1:				    ;������ �������� ���������
 out_str mes			    ;����� �� ����� ���������� ����������
 cursor 			    ;������� ��������� ������� � ������ ����� ������
 out_str Oper1			    ;����� �� ����� ���������� ����������
 cursor 			   
scr_ddw a1
 cursor 	
 out_str Oper2			    ;����� �� ����� ���������� ����������
 cursor 			   
scr_ddw a2
 cursor 			
  mov esi,a1
 mov edi,a2
  mov ebx,res
 movups xmm0,[esi]
 movups xmm1,[edi]
addps xmm0,xmm1
 movups[ebx],xmm0		     ;�������� ������ 64 ���� ����������� ������
 out_str Sum			    ;����� �� ����� ���������� ����������
 cursor 		
scr_ddw res
 cursor 		
mov ax, 4c00h
int 21h 			   



