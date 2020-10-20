format MZ
push cs 				    
pop ds				  ;����������� �������� �����
push ds
pop ss				  ;����������� �������� �����
jmp mt1 				  ;������� �� ������� ��������
       mes db '              TECHNOLOGY MULTIMEDIA  ADDITION THE PENTIUM PROCESSOR',0ah,0dh,'$'
     mes0 db '                ------- SINGLE PRECESSION FLOATING POINT -------',0ah,0dh,'$'
     mes1 db '          addps xmm0,xmm1;ADDition Packed Single-precision float-point',0ah,0dh,'$'
     mes2 db '                  ---------------------------------------------',0ah,0dh,'$'
   Oper1 db '          Packed_X: ','$'
   Oper2 db '          Packed_Y: ','$'
      Sum db '          Packed_Z: ','$'
	a1 dd -51.7, 0.0, 1.0, -142.6	    ; ������������ ���'�� �� �����
	a2 dd -90.9, 0.0, -1.0, 0.0		   ;�������� �� ���������� �� ��������
	res dd a2-a1 dup('?')	      ; �������� � ������������  ������  SPFP     
			    macro out_str str	      ;���� ���������� �����������
	    {mov dx,str
	      mov ah,9
	      int 21h}
		      macro cursor		  ;������ ��������� ������� �������
	    {mov ah,2
	      mov dl,0dh	
	       int 21h				  ;������  ������� �� ����� ������
	       mov dl,0ah	  
	       int 21h} 			  ;�������  ������� � ������ ������
       macro scr_ddw adr		     ;���� ������ �����
	{local nxt		      
	push bx
	mov bx,adr		      ;��������� ������ ������
	add bx,15		      ;ʳ����� ������ ������
	mov cx,16		      ;������ ������ � ������
	    nxt:scr_byt 	      ;���� ������ �����
		dec bx	     ;��������� ������ ������
		loop nxt	     ;������� �� �������� ������� ������
		mov dl,'h'
		int 21h 	     ;���� �������
		pop bx
	cursor}

	 macro scr_byt		    ;���� ������ �����
	 {local  comp,symb,scrn,exit
		mov ah,2		     ;�������  ����������
		mov dh,1		     ;��������� ������� �����������
		mov dl,[bx]		     ;�������� �������� �����
		shr dl,4		     ;�������� ������ ������� � �������
		    comp:cmp dl,10		     ;��������� � ��������
		jnc symb		       ;������ ������� ��� ����� ������
		add dl,30h		      ;���������� ASCII ������� ����� 0,1,..,9
		jmp scrn		       ;������� �� ���� �������
		    symb: add dl,37h	     ;���������� ASCII ������� ����� 10,11,..,15
		  scrn: int 21h 	     ;���� �������
		or dh,dh		      ;������
		jz exit 		      ;������� �����������
		mov dh,0		      ;���� ������� �����������
		mov dl,[bx]		      ;�������� �������� �����
		and dl,0fh		      ;���������� ������� �������
		jmp comp		      ;������� �� �������  �������  �������
		       exit: mov dl,' ' 
		int 21h}		    ;���� �������
		 
 mt1:cursor			   ;������� ������� ��������
 cursor 			   ;������ ��������� ������� 
  cursor	   
   out_str mes0 		    ;���� �� ����� ���������� �����������
 cursor 
 out_str mes			    ;���� �� ����� ���������� �����������
    out_str mes2		    ;���� �� ����� ���������� �����������
 cursor 			       
 out_str mes1			    ;���� �� ����� ���������� �����������
    cursor	
 out_str Oper1		    ;���� �� ����� ���������� �����������
  scr_ddw a1			    ;���� �� ����� ������� ������ ������ � ������ SPFP           
    cursor	
 out_str Oper2		    ;���� �� ����� ���������� �����������
  scr_ddw a2			     ;���� �� ����� ������� ������ ������ � ������ SPFP      
    cursor
     mov esi,a1 		    ;�����������     
     mov edi,a2 		     ;��������
     mov ebx,res		     ;�������
 movups xmm0,[esi]		    ;MOVe Unaligned four Pakced Single-precesion float-point 
 movups xmm1,[edi]		     ;��������� ����������� ���������� �������  � ������ SPFP  
addps xmm0,xmm1 		      ;������� ��������� �������� ������� � ��������� ������
 movups[ebx],xmm0		    ;������������ ������ ������� 64 ��� ������������ ������
 out_str Sum			   ;���� �� ����� ���������� �����������
scr_ddw res			     ;���� �� �����  ������ ���� ������ � ������ SPFP    
 cursor 			  
mov ax, 4c00h		    ;���������� ���������� � ����������
int 21h 			    ; ��������� ��������� ����������         



