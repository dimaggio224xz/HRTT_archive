;˳����� 1 � �������� ��������� ������� ���������� ���������
masm                                     
model small 
scr macro x              ;������ ������ �� ����� ���������� ����������� 
mov dx, offset x
mov ah, 09h
int 21h
 endm
init macro           ;������ ������������� ��������
     mov al, ms     ;����� ������������� �������� 
     out ppi+4, al  ;���� �������� �����
     xor al,al          ;���������� ����
      out ppi+2, al   ;���� ��� ����� �
      endm
.stack 100h
.data
ms equ 6Bh                 ;����� MS ������ ������ ��������
PC1_1 equ 03h           ;����� BSR ��� ��������� PC1
PC1_0 equ 02h           ;����� BSR ��� ����� PC1
ppi equ 0a3h               ;������ ��������
pb equ ppi                  ;���������� ���� ��������
pc equ pb+2                ;���������� �����
cr equ pb+4                ; �����
pa equ pb+6                ; �������� 
mes_1 db '                                        TKZ-1',10,13,10,'$'
mes_2 db '  PB - 6B H; PC - 6D H; CR - 6F H; PA - 71 H ', 10,13, 10,'$'
.code 
        stt:mov ax,@data    ;������� ������� ��������   
    mov ds,ax             ;���������� �������� �����
    init                        ;����������� ��������
    mov al, pc1_1      ;��������� � �������
     out pc,al              ; �� ����� ��1
     mov al, pc1_0     ;���� � ����
     out pc,al              ;�� ����� ��1
    scr mes_1            ;��������� �����������
     scr mes_2            ;��������� �����������       
     mov ax,4c00h     ;����� �
      int 21h                ;���������� �������      
      end stt 
