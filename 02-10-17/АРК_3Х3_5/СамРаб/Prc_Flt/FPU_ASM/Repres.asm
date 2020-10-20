;Represention PENTIUM-coprocessor data 
.586p
masm             
model use16  small
.stack 256
.data
x dd 0.000006 ; -19300.091796875Single     (1.1755e-38 =< |X| <= 3.4028e+38)
y dq 0.000006               ;Double    (2.2250e-308 =< |Y| <= 1.7977e+308)
z dt  0.000006           ;Extended (3.3620e-4932 =< |Z| <= 1.1899e+4932)
m db '         Represent data FPU processor PENTIUM  start $ '
m1 db '         SINGLE  : $'
m2 db '         DOUBLE  : $'
m3 db '         EXTENDED: $'
m4 db '         Represent data FPU processor PENTIUM  stop $ '

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
         mov dl,[bx]       ;������������ � ����� 
         push cx            ;���������� � �����
         mov cl,4           ;���������� �������
         shr dl,cl            ; Pced ������ �� ������
         pop cx             ;���������� ��������
         scr_sym           ;������ �������� ������� �����
         mov dl,[bx]      ;������������ ���� � ����� � ����� 
         and dl,0fh         ;�������� ������� �������
         scr_sym           ;������ ��������� ������� �����
         mov dl,20h        ;������  ������� 
         int 21h               ;�������
         endm
         init macro cnt,per        ;�����������   
              mov cx,cnt             ;��������� ��
              mov bx,offset per  ; ��������� ������
              endm
        zzz macro             ;������ ����� ASCII ������� �����   
             local next
        next:scr_byte       ;������ ����� ASCII �������
             dec bx            ;��������� ������
             loop next        ;��������� ��������� �� �������
             mov dl,'h'        ;������
             int 21h             ;������� h
             endm
       curs macro             ;������ ������ ������
            mov dl,0ah         ;������� �� ��������     
            int 21h               ;������
            mov dl,0dh        ;������� �� ������� 
            int 21h               ;������
            endm
   mess macro adr                  ;������
           push ax                      ;����������
           lea dx,adr                   ;�����������
           mov ah,9                    ;�� �����
           int 21h                        ;�������
           pop ax                       ;���������
           endm   
main:                                        ;�������� ���������
mov ax,@data     ;������ ��������
mov ds,ax           ;�����
finit                    ;����������� ������������
fld1                   ;������������ ������� � �����������
fmul x               ;�������� �� ������� �� ����� Single    
fst y                   ;���������� �� Double
fstp z                 ;���������� �� Extended 
mov ah,2            ;������� ���
mess m              ;����������� Represent data FPU processor PENTIUM
curs                    ;�������
curs                    ;�� ���� ������ ������
mess m1             ;³������� �����������
init 4,x+3            ;�����������  ��������� 
zzz                   ;������ �� ����� ����� Single     
curs                  ;������� �� ����
curs                  ;������ ������
mess m2           ;³������� �����������
init 8,y+7          ;�����������  ��������� 
zzz                   ;������ �� ����� �����Double
curs                  ;������� �� ����
curs                  ;������ ������
mess m3           ;³������� �����������
init 10,z+9        ;�����������  ��������� 
zzz                   ;������ �� ����� ����� Extended 
curs                  ;������� �� ����
curs                  ;������ ������
mess m4   
curs                  ;������� �� ����
curs                  ;������ ������
mov ax,4c00h   ;���������� 
int 21h              ;� ���
end main
