masm                                     ;��������� �������������� ��������� 
model small                           ;�������� �����   
mes_sb macro mes_i              ;������ ������ ���������
             mov ah,09h
             mov dx,offset mes_i
             int 21h
             endm
con_bd macro op_b, op_d    ;������ �������������� ���������                
            local nxt1                  ;����� � ������������� ������� ����������
            lea bx, op_d              ;����� ������������� ����������� ����
            mov cx,10000           ;������� �����
            mov si,10                  ;�������� ����������� ���� 
            mov ax,op_b             ;�������� ��� �� ������  
    nxt1:xor dx,dx
            div cx                        ;����������  � �����������
            mov [bx]+4,al           ;�������� ����������� �������
           dec bx
           mov ax,dx
           xor dx,dx
           xchg ax,cx                 ;����������
           div si                        ;����    
           xchg ax,cx                 ;����� 
           or cx,cx
           jnz nxt1                     ;�����, ���� ����� ����� ����  
           endm  
con_db macro                       ;������ �������������� ��������������  
            local nxt2                  ;������� ���������� ����� � ��������� 
            lea bx, opp_d            ;����� ������������� ����������� ����
            mov cx,1                   ;������� �����
            mov si,10                  ;�������� ����������� ���� 
           xor di,di
    nxt2:xor ah,ah 
            mov al, [bx]              ;���������� �������� ����������� �������
            inc bx
            mul cx                       ;��������� ������������    
            add di,ax                   ;����� ��������� ������������
            mov  ax,cx                 ;����������  
            mul si                        ;����
            mov cx, ax                 ;�����
            and dx,0ffffh
            jz nxt2                       ;�����, ���� ����� ������ 10000
            mov opp_b,di           ;���������� ��������� ���� 
           endm  
             
.stack 100h
.data
mes1 db 'Error product!', '$'          ;��������� � ��������
mes2 db 'Ok Key product!', '$'       ;�����������  ����������
op1_b dw  15888                   ;����������� 
op2_b dw  14288                    ;���������
opp_b dw  ?                          ;� ���������� ���������  
op1_d db 5 dup(?)                 ;�������� � ��
op2_d db 5 dup(?)                 ;�������� � �������������  
opp_d db 5 dup(?)                 ;���������� �������   
.code
stt:  mov ax,@data                ;����������� ������ 
       mov ds,ax                      ;�������� ���������
       mov ax,3                        ;������� ������ 
       int 10h                            ;��������
       con_bd op1_b, op1_d    ;�������������� ��������� ���� 
       con_bd op2_b, op2_d    ;��������� � ����������
       mov cx,5                        ;����������� ����������� ����   
       lea si, op1_d                   ;�������������
       lea di, op2_d                  ;��������
       lea bx, opp_d                 ;����������
       clc
nxt3:mov al,[si]                     ;��������� 
       sbb al,[di]                       ;������
       aas                                  ;� ����������
       mov [bx],al                     ;����������
       inc si                               ;�������������
       inc di                               ;����������
       inc bx                              ;�����
       loop nxt3                         ;���������  
       con_db                            ;��������� � �������� ��� 
       mov ax, op1_b                 ; ��������
      ; inc al
       sub ax, op2_b                  ; ���������
       cmp ax, opp_b                 ;��������� ���� �����������
       jz ner                                  
       mes_sb mes1                    ;������ ����������  
      jmp exit
ner:  mes_sb mes2                   ;������������ ����������
exit:mov ax,4c00h                   ;����������� ����  
       int 21h                              ; � ����� MS DOS
       end stt 
