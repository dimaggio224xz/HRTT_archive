;˳����� 2 � �������� ��������� ������� ���������� ���������
         
model small 
scr macro x              ;������ ������ �� ����� ���������� ����������� 
local lpp,ext               ;���� ������ � ������
     xor bx,bx               ;���� � ����
lpp:mov al, x[bx]        ; ������� ������� � ���'��  
     cmp al,0                ; ��������� � �����
     je ext                     ; ��� � ���� �� ����� � �����
     mov ah, 0eh          ; ������� �����������
     int 10h                  ;��������� ������� �� �����
     inc bx                    ; �������� �� ���� ���� ������ 
     jmp lpp                 ; ������� �� ����������
ext:cur                       ; ����������� �������
     endm
cur macro               ;�������� ������� �� ����� �����
      mov ah,2
      mov dl,0dh                
      int 21h                     
      mov dl,0ah
      int 21h               
      endm
sign macro xxx    ;���������� �������� ���������
       mov al,xxx     ;������������ BSR ��� ���������
       out ppi+2,al   ;��������� �� � �������
       dely                ;����� ���� �������� 
       dec al             ;����������  BSR ��� �����
       out ppi+2,al   ;���� �� � ����
       paus               ;�������� �����
       endm
dely macro       ;���������� �������� 
local nn
         xor cx,cx  ;������������ �������� ��������
    nn:loop nn     ;���������� �� �������� ��������
         endm
paus macro        ;���������� �����
       local  mm
       mov cx, 3     ;���������� �������� �������
mm:dely              ;����� ��������
        loop mm      ;���������� �� ����� �������� 
        endm
kayx macro      ;������ ���������� ������� �
local wit
        mov ah,7
   wit:int 21h
        cmp al,'x'
        jne wit
        endm
init macro           ;������ ������������� ��������
      mov al, ms     ;����� ������������� �������� 
      out ppi+4, al  ;���� �������� �����
      xor al,al          ;���������� ����
      out ppi+2, al   ;���� ��� ����� �
      endm
.stack 100h
.data
ms equ 98h           ;����� MS ������ ������ ��������
stb equ 01h           ;����� BSR ��� ��������� STB 
clk equ 03h           ;����� BSR ��� ��������� CLK
clr equ 07h            ;����� BSR ��� ��������� CLR
mde equ 05h         ;����� BSR ��� ��������� MDE
ppi equ 4Bh         ;������ ��������
pb equ ppi             ;���������� ���� ��������
mesk equ 10h        ;����� �������� ����� �������
k equ 6                    ;���������� �������
mes_1 db '                                               TKZ-2',0
mes_2 db '                                           Romasenko Denis',10,13,0
.code 
stt:mov ax,@data    ;������� ������� ��������   
    mov ds,ax             ;���������� �������� �����
    init                        ;����������� ��������
    scr mes_1            ;��������� �����������
    jmp exit                ;����� ��������� ����� � �������� 
    in al, ppi+2           ;������� ����� �
    and al, mesk         ;�������� ����� �������
    je skip                   ;������ � ���
    sign clr                   ;���� ������� � ����
skip:mov al,16-k      ;������������ �������� 
       out ppi,al            ;�������� ������
        sign stb              ;����� �������� � ��������
next:sign clk             ;�������� �������        
        in al, ppi+2       ; ������� ����� ����� �
        and al,mesk       ;�������� ����� �������
        jz next                ;������ � ���
        in al, ppi+6       ; ������� ����� ����� �
        and al,0Fh         ;�������� ����� ���������
        jnz exut              ;˳������� �� � ���
exit:cur                       ; �������� ��������� �������     
       kayx                 ; ���������� ������� ������  
exut:scr mes_2            ;��������� �����������       
       mov ax,4c00h     ;����� �
        int 21h                ;���������� �������      
       end stt 
