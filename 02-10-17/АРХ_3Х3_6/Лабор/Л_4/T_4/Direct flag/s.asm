;������������ ����� DF
masm
model small
.stack 100h
.data
oper_1 db 0c7h, 2dh, 0bdh, 4eh ; ������� �������� 
oper_z dd 0
oper_2 db 4 dup ('X')                 ; ������� ������� 
.code
exe:mov ax,@data                      ; �������� DS, ES       
       mov ds,ax                            ; � ������ ��������  
       mov es,ax                            ; ���� �� �����
       lea si,oper_1+3                   ; ������������� �������
       lea di, oper_2+3                  ;�� ����� ������� 
        mov cx, 2                            ;����� �������
        std                                       ;��������� DF:=1
cli
hlt
        rep movsb                           ; �������� �����
       lea si,oper_1                        ; ������������� �������
       lea di, oper_2                       ;�� ������ �������
        mov cx, 2                             ;����� �������
       cld                                        ;��������� DF:=0
       rep movsb                             ; �������� �����
       mov ax,4c00h                        ; �����������
       int 21h                                   ; ������� � MS DOS
       end exe 

