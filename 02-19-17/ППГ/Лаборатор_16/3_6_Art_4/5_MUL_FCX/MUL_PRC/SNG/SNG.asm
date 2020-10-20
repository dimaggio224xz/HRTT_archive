;Presentation PENTIUM processor data SINGLE
masm             
model   small
.stack 256
.data
;������� ����������     Minimum    [1.1754943E-38  ..  3.4028234E+38]   Maximum
;�������� ����������                      [-0.0000001E-38]  [+0.0000002E+38]  
;�������� ����������    Underflow  [1.1754942E-38]   [ 3.4028236E+38]  Overflow 
x dd 10.0
y dd 0.1
;x dd 3.4028236E+37
;y dd 3.4028234E+37
;z dd 1.1754942E-37
;w dd  1.1754943E-37
ms db '      Presentation SINGLE of processor XMM start   $ '
me db '      Presentation SINGLE of processor XMM  stop  $ '
m1 db '             X(10.0) = $'
m2 db '             Y(0.10) = $'
;m1 db '             X(3.4028236E+37) = $'
;m2 db '             Y(3.4028234E+37) = $'
;m3 db '             Z(1.1754942E-37) = $'
;m4 db '             W(1.1754943E-37) = $'
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
scr m2,y          ;������ �� ����� ����� Y   
;scr m3,z           ;������ �� ����� ����� Z
;scr m4,w          ;������ �� ����� ����� W
curs 
curs 
mess me             ;����������� ��� ��������� ����������
curs 
mov ax,4c00h   ;���������� 
int 21h              ;� ���
end main