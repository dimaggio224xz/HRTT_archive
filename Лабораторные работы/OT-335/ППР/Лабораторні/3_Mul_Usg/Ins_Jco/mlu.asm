;���������� ������ �������� ����������
masm
.model small                                     ;��� ����� �����
.stack 100h                                      ;������� �����
.data                                            ;������� �����
X db 99;������ �������-�������  
Y db 88;������ �������-�������   
Z dw ? ;���������-�������                                               
mes_1 db 'Unsigned multiplication start',0ah,0dh,'$' 
mes_2 db ' Unsigned multiplication stop',0ah,0dh,'$'
len equ 8 ;����������� �����������
.code  ;������� ��������                                          
mes macro mes                      ;������ �����������
    mov ah,09h                     ;��������� 
    mov dx,offset mes              ;�����������
    int 21h                        ;�� ������������                             
    endm
   uml proc near             ;������������������ ������� 
        mov cx,len             
        mov dh,0         ;��������� ���� �������� �������
   @nxt:ror byte ptr Y,1 ;���������� ��� �������� � CF    
        jnc @nad         ;��������� ������� ������� ����
        add dh,X         ;���������� ������ ���� �������� �������
   @nad:rcr dx,1         ;�������� ���� ������ ������ ���� �������� �������
        loop @nxt        ;�������� ����������� ��������� �������� ��������� 
        mov z,dx         ;��������� ������� � ������� � ���'��
        ret
        endp uml  
   exc:mov ax,@data                    ;�����������        
       mov ds,ax                       ;�������� DS  
       mes mes_1                       ;���� ����������� �� �����
       call uml                        ;�������� �����
       mes mes_2                       ;���� ����������� �� �����
       mov ax,4c00h                    ;���������
       int 21h                         ;���������� � MS DOS 
       end exc














