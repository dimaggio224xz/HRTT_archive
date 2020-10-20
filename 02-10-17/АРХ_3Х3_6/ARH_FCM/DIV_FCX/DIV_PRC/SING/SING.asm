;Presentation PENTIUM-coprocessor data SINGLE
.586p
masm             
model use16  small
.stack 256
.data
;(1,1754943)*10-38  = < | X | < = (3,4028234)*10+38 .
x dd 1.0754940E-38  
y dd 3.7028234E+38 
z dd 1.0
ms db '      Presentation SINGLE of coprocessor PENTIUM start   $ '
me db '      Presentation SINGLE of coprocessor PENTIUM stop  $ '
m1 db '                   X = $'
m2 db '                   Y = $'
m3 db '                   Z = $'
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
scr m1,x           ;������ �� ����� ����� X  
scr m2,y           ;������ �� ����� ����� Y   
scr m3,z            ;������ �� ����� ����� Z
 curs 
 curs 
mess me             ;����������� ��� ��������� ����������
curs 
curs 
mov ax,4c00h   ;���������� 
int 21h              ;� ���
end main