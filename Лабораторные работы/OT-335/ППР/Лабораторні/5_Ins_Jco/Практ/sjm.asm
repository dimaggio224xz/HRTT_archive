;���������� ������ �������� ����������
masm
.model small                                     ;��� ����� �����
.stack 100h                                      ;������� �����
.data                                            ;������� �����
X db -67, -78, 127, -128, 0, 99, -71, 13;������ ������� 
Y db 88, 0h, -45h, -127, 0, -105, 0, -59;������ �������   
len equ $-Y                             ;ʳ������ ����� 
Z db len dup (?)                        ;������� ���������                                                
mes_E db 'E',20h,20h,'$'; 45h - ASCII 'E';����������� ��� ������
mes_L db 'L',20h,20h,'$'; 47h - ASCII 'L';����������� ��� �����
mes_G db 'G',20h,20h,'$'; 4Ch - ASCII 'G';����������� ��� �����
msk_OF equ dword ptr 800h  ;����� ������� ������� OF 
msk_SF equ dword ptr 80h   ;����� ������� ������� SF
msk_ZF equ dword ptr 40h   ;����� ������� ������� ZF
E equ byte ptr 'E';����������� 
L equ byte ptr 'L';���������� �
G equ byte ptr 'G';������ ASCII
.code  ;������� ��������                                          
mes macro elg,P                        ;������ �����������
    push ax                            ;������������ �������
    mov [bx],elg                       ;� ����� �� 
    mov ah,09h                         ;��������� 
    mov dx,offset P                    ;�����������
    int 21h                            ;�� ������������   
    pop ax                              
    endm
exe:mov ax,@data                       ;�����������        
       mov ds,ax                       ;�������� DS                      
       lea si,X                  ;����������� �����
       lea di,Y                  ;������� ����� �������� 
       lea bx,Z                  ;�� ������� ��������
        mov cx,len               ;������� �������
   ckl:mov al,[si]               ;������� �������� ������� �������� 
       cmp al,[di]      ;��������� �� ���������� ��� ������� �����
       pushf                     ;��������� (FX)
       pop bp                    ;����� ���� � BP
       test bp,msk_ZF   ;��������� ����������� ����������
       jz nxt                   ;(ZF)=0 Less or Greate
       mes e,mes_E              ;(ZF)=1 Equate
       jmp ext         ;���������� ������ ���� ��������
   nxt:test bp,msk_SF  ;��������� ����������� ����������
       jz res                   ;(SF)=0           
       mov ah,1                 ;(SF)=1        
       jmp xet                   
   res:mov ah,0       
   xet:test bp,msk_OF  ;��������� ����������� ����������
       jz rse          ;(OF)=0               
       mov al,1        ;(OF)=1 
       jmp mdd              
   rse:mov al,0       
   mdd:xor al,ah     ;(SF)mod(OF)           
       Jz zer        ;(SF)mod(OF)=0 Greate
       mes l,mes_L   ;(SF)mod(OF)=1 Less
       jmp ext       ;���������� ������ ���� ��������
   zer:mes g,mes_G   ;���������� ������ ���� ��������
   ext:inc si        ;�������� ���������   
       inc di        ;����� ������
       inc bx        ;�� ��������� �����
       loop ckl      ;� ����������
       mov ax,4c00h  ;���������
       int 21h       ;���������� � MS DOS
       end exe       ;��������� ��������

