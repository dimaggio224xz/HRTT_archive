;��������� ����મ��쪨� �. �.
;test.asm
model small
.stack 100h
;����� ��ࠡ�⪨ ����㥬��� ���� � �����
write macro cod
      mov ah,cod
      call filcmp  ;���������� � �ࠢ����� ��⮢��� ����
      endm
;����� �뤠� ᮮ�饭��
scren macro msi
      mov ah,09h
      mov dx,offset msi
      int 21h
      endm
;����� ����樨 �訡��
eml_err macro
        local exm
        cmp si,cx
        jne exm
        dec byte ptr [bx] ;���諥��� ���� �訡��
   exm: endm
.data
ms1 db '                            ������ ������ �i�����',0ah,0dh,0ah,'$'
ms2 db '                  �������� ������� �� ����� DS:BX � ����� � AL',0ah,0dh,0ah,'$'
ms3 db '                       ����㢠��� �஢����� ������������',0ah,0dh,0ah,'$'
ms4 db '      �i�����⨪� i���䥩�� ����⨢��� �����i � �������� �i�ய���஬ ',0ah,0dh,0ah,'$'
ms5 db '                              ��������� ���K',0ah,0dh,0ah,'$'
mem_tst db 32768 dup(?) ;������� ����� ���஢����
spc_tst equ 400h       ;𬪮��� ����� ���஢����
.code
strt:jmp exe
;��楤�� ���������� � �ࠢ����� ��⮢��� ����
filcmp proc
       push bx
       push cx
 fillp:mov [bx],ah ;������ � �祩�� ��⮢��� ����
       ;eml_err     ;������ �訡��
       inc bx      ;���४�� ���� �����
       loop fillp  ;���室 �� ��ࠡ��� ᫥���饩 �祩��
       pop cx
       pop bx
       push bx
       push cx
 cmplp:cmp [bx],ah  ;�ࠢ����� � �祩�� � ��⮢� �����
       jnz stop     ;�����㦥�� �訡��
       inc bx       ;���४�� ���� �����
       loop cmplp   ;���室 �� ��ࠡ��� ᫥���饩 �祩��
       pop cx
       pop bx
       jmp yyy
  stop:mov al,ah     ;���⮢� ��� � AL
       stc           ;��⠭���� �訡��
       pop cx
       pop si
   yyy:ret
filcmp endp
exe:mov ax,@data          ;���樠������ ᥣ���� ������
    mov ds,ax
    scren ms4             ;����饭�� � �ணࠬ��
    scren ms5             ;����饭�� � �ணࠬ��  
    mov bx,offset mem_tst ;��砫�� ���� ����� ���஢����
    mov cx,spc_tst        ;𬪮��� ����� ���஢����
    mov si,spc_tst/2      ;���� �।��� ���� ����㥬�� �����
    mov al,cl             ;�஢�ઠ �� 䠪�
    or al,ch              ;������ ����� ���஢����
    jnz next              ;���� ������ ���஢����
    scren ms1             ;����饭�� �� ������⢨� ����� ���஢����
    jmp xxx
next:write 0              ;��ࠡ�⪠ ��⮢��� ���� 00h
     jc errr              ;�����㦥�� �訡��
     write 0ffh           ;��ࠡ�⪠ ��⮢��� ���� 0ffh
     jc errr              ;�����㦥�� �訡��
     write 0aah           ;��ࠡ�⪠ ��⮢��� ���� 0aah
     jc errr              ;�����㦥�� �訡��
     write 55h            ;��ࠡ�⪠ ��⮢��� ���� 55h
     jc errr              ;�����㦥�� �訡��
wkl:mov al,80h            ;��ࠧ�來� 
wrl:mov [bx],al           ;� �祩�� �����
    cmp [bx],al           ;� ��᫥���騬 �ࠢ������
    stc                   ;��⠭���� ����⭮� �訡�� 
    jne errr              ;�����㦥�� �訡��
    ror al,1              ;����䨪��� ��⮢��� �������饣��� ����
    cmp al,80h            ;���� ��ࠡ�⪨ �祩�� 
    jne wrl               ;�� �������
    mov byte ptr [bx],0   ;���㫥��� ⥪�饩 �祩��
    inc bx                ;���室 �� ��ࠡ���
    loop wkl              ;��।��� �祩��
    scren ms3             ;����饭�� �� ����砭�� ���஢����
    jmp xxx
errr:scren ms2            ;����饭�� � �訡�� � ࠡ�� ����� 
xxx:mov ax,4c00h          ;������ �
    int 21h               ;MS DOS 
    end strt
