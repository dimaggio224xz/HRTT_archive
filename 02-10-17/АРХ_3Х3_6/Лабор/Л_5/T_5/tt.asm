masm               ;��������� ������������� �������� 
model small     ; � �������� �� ������������   
.stack 100h
.data
message_1 db 'Overflow', 13, 10,'$'          ;��������� � ��������
message_2 db 'NoOverflow', 13,10, '$'      ;�����������  ����������
oper_1 db 0fh, 0fah, 0f5h,  8fh              ;����������� 
oper_2 db 87h, 5Dh, 74h,  76h              ;���������
summ db 4 dup (?)                                 ;� ����������  
.code
stt:jmp exe
err_sum proc near                        ;��������� ������ ���������
       mov ah,09h
       mov dx,offset message_1
       int 21h
       ret
       endp
exe:mov ax,@data         ;����������� ������ 
       mov ds,ax                ;�������� ���������
       mov ax,3            ;������� ������ 
       int 10h                ;��������
xor si,si                       ; �������������  
xor di,di                      ; ��������
lea bx,summ                ; ��������� �
mov  cx, 4                  ; �������� ������
clc                                ;��������� CF:=0 
        cycle:  mov al, oper_1[si]            ; �������� �������
adc al, oper_2[di]             ; ������ �� ������ � 
mov [bx],al                        ; ������������ ����������
pushf
inc si                           ;��������� �� ���� ����
inc di                           ;��������
inc bx                          ;���������
popf
loop cycle                                 ;������������
jo ero                         ; ������ �� ������������ 
 mov ah,09h                             ;��������� ��
 mov dx,offset message_2        ;����������
 int 21h                                     ;������������
jmp ext                         
ero: call err_sum        ;�������� ������������   
       ext:mov ax,4c00h     ;����������� ����  
  int 21h                  ; � ����� MS DOS
                      end stt
   
 
