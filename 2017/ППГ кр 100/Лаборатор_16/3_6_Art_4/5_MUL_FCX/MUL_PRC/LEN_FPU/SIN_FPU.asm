masm          ;��������� �� ����� ���������  ������� ����   
model   small
.stack 256
.data
pi equ 3.1415926               ;������� ��������
R dd 1.5                             ;����� R
L dd  9.4247778                 ;������� L=2*pi*R
ms db '              Testing of length of circuit $'
me db '           Stop execute of length of circuit  $ '
m1 db '               Radius  R=$'
m2 db '               Length  L=$'
.code
scr_sym macro              ;������ ASCII �������
        local fri,sym
        cmp dl,0ah          ;��������� � ��������
        jb fri                   ;����� �������
        or dl,40h             ;���������� ������� 
        sub dl,09h           ;����� ���� 
        jmp sym              ;������� �� ������
   fri:or dl,30h             ;���������� ������� 
 sym:int 21h              ;������ ������� �� �����   
        endm  
scr_byte macro          ;������ ����� ASCII �������
         mov dl,[bx]        ;������������ � ����� 
         push cx             ;���������� � �����
         mov cl,4            ;���������� �������
         shr dl,cl             ; Pced ������ �� ������
         pop cx               ;���������� ��������
         scr_sym            ;������ �������� ������� �����
         mov dl,[bx]       ;������������ ���� � ����� � ����� 
         and dl,0fh         ;�������� ������� �������
         scr_sym             ;������ ��������� ������� �����
         mov dl,20h        ;������  ������� 
         int 21h               ;�������
         endm
      xyz macro             ;������ ����� ASCII ������� �����   
             local next
     next:scr_byte       ;������ ����� ASCII �������
             dec bx            ;��������� ������
             loop next        ;��������� ��������� �� �������
             mov dl,'h'       ;������
             int 21h            ;������� h
             endm
    curs macro                ;������ ������ ������
            mov dl,0ah         ;������� �� ��������     
            int 21h               ;������
            mov dl,0dh        ;������� �� ������� 
            int 21h               ;������
            endm
   mess macro adr                ;������
           push ax                      ;����������
           lea dx,adr                   ;�����������
           mov ah,9                    ;�� �����
           int 21h                        ;�������
           pop ax                       ;���������
           endm  
       scr macro m,t        ;�����������   
             curs                  ;������� �� ���� �� �������� ������
             mess m             ;³������� �����������
             mov cx,4          ;����������� ��������� ��
             lea bx,t+3        ; ��������� ������
             xyz                    ;������ �� ����� ����� Single     
             endm
 main:                  ;�������� ���������
mov ax,@data     ;������ ��������
mov ds,ax           ;�����
mov ah,2            ;������� ���
curs 
mess ms              ;����������� ��� ������� ����������
curs    
scr m1,r           ;������ �� ����� �������
scr m2,l          ;������ �� ����� �������   
curs 
curs 
mess me             ;����������� ��� ��������� ����������
curs 
curs 
mov ax,4c00h   ;���������� 
int 21h              ;� ���
end main