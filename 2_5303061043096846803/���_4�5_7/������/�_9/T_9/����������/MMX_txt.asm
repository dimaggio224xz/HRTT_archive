format MZ
push cs 				    
pop ds				  ;������������� �������� ������
push ds
pop ss				  ;������������� �������� �����
jmp mt1 			  ;������� �� �������� ���������
   mes db '           TECHNOLOGY MMX THE PENTIUM PROCESSOR ',0ah,0dh,'$'
	src db 'PHILADELPHIA  FLYERS MIKROPROCESSOR THE PENTIUM TECHNOLOGY','$'
	tmp db	tmp-src-1 dup(20h)
	dst db	tmp-src-1 dup('?'),'$'

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
 
 mt1:				    ;������ �������� ���������
 out_str mes			    ;����� �� ����� ���������� ����������
 cursor 			    ;������� ��������� ������� � ������ ����� ������
 out_str src			    ;����� �� ����� ���������� ����������
 cursor 			    ;������� ��������� ������� � ������ ����� ������
 cursor
 mov eax,tmp-src-1		    ;����� ������ �������
 mov ebx,8			    ;����� ��� ���������� � ������
 xor edx,edx			    ;����� � ����
 div ebx			    ;������ �� ����� ������ � ������
 mov ecx,eax			    ;����� ������� � ������
 mov esi,src
 mov edi,dst
 mov ebx,tmp
 next:
 movq mm0,[esi] 		     ;�������� ������ 64 ���� ����������� ������
 paddb mm0,[ebx]		     ;�������� �������� ������ � ���������� ���
 movq [edi],mm0 		     ;���������� ������ 64 ���� ����������� ������
 add esi,8
 add edi,8
 add bx,8
 dec ecx
 jnz next
 mov ecx,edx
 next1:
 mov al,[esi]
 add al,20h
 mov [edi],al
 inc esi
 inc edi
dec ecx
jnz next1
exit:
out_str dst		     ;����� �� ����� ���������� ����������
cursor
mov ax, 4c00h
int 21h 			   



