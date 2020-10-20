;Presentation PENTIUM processor data SINGLE
masm             
model   small
.stack 256
.data
;������� ����������     Minimum    [1.1754943E-38  ..  3.4028234E+38]   Maximum
;�������� ����������                      [-0.0000001E-38]  [+0.0000002E+38]  
;�������� ����������    Underflow  [1.1754942E-38]   [ 3.4028236E+38]  Overflow 
;x DD 2.0000001E-38
      
 ;y DD  -0.0000002E+38
                  
X  DD   6000000.0E-12; 
Y  DD   5518968.46E-12
Z  DD    5990266.7E-12; 
W DD 3.4028234E+38  
ms db '      Presentation SINGLE of processor XMM start   $ '
me db '      Presentation SINGLE of processor XMM  stop  $ '
;m1 db '            (5990266,7E-12)=$'
;m2 db '            (-0.0000002E+38)=$'

m1 db '             Z(6000000.0E-12) = $'
m2 db '             Y(-200719.9E-6) = $'
m3 db '             Z(5990266.7E-12) = $'
m4 db '            (3.4028236E+38)=$'
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
;scr m2,y          ;������ �� ����� ����� Y   
scr m3,z           ;������ �� ����� ����� Z
;scr m4,w          ;������ �� ����� ����� W
curs 
curs 
mess me             ;����������� ��� ��������� ����������
curs 
mov ax,4c00h   ;���������� 
int 21h              ;� ���
end main