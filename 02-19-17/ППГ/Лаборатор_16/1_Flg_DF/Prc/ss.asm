;���������� ������� DF
.model small                                     ;��� ����� �����
.stack 100h                                        ;������� �����
.data                                                  ;������� �����
Mes_1 db 'Study flag DF                                                              ',13,'$'
 Mes_2 db 'Bezditko A. M.',0dh,0ah,'$'; ����� �����������
oper_1 db 0c7h, 2dh, 0bdh, 34h    ; ���������� ������ 
len equ $-oper_1                          ;ʳ������ ����� �������
oper_2 db len dup ('X')              ; ������ �������� 
.code                                              ;������� ��������
   exe:mov ax,@data                      ; �������� DS, ES � �������       
       mov ds,ax                              ; �����  �������� 
       mov es,ax                               ; ���� �� ������
       Mov bl,2
   Nxt:mov ah,09                             ; ��������� 
       Cmp bl,1
       jnz mms
       mov dx, offset mes_2               ; �����������
       int 21h   
       jmp hod         
   mms:mov dx, offset mes_1         
       int 21h                                   ; �� ������������              
       lea si,oper_1+len-1                  ;����������� �����
       lea di,oper_2+len-1                ;�� ����� ������� ����� 
        mov cx, len/2                          ;������� �������
        std                                         ;��������� DF:=1
        rep movsb                           ; �������� �����
        mov si, offset  oper_1          ; ����������� �����
        mov di, offset oper_2            ;�� ������� �������
        mov cx, len/2                      ;������� �������
        cld                                        ;��������� DF:=0
        rep movsb                             ; �������� ������
    hod:dec bl
        jnz nxt
        mov ax,4c00h                        ; ���������
        int 21h                                   ; ���������� � MS DOS
        end exe                                  ; ��������� ��������

