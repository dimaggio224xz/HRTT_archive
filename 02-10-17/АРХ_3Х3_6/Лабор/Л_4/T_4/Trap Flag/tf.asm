masm
model small
         scr macro xxx    ;������ ������ �� ����� ��������� �������� SI
            local nxt                  ;�������� �����
            push ds
            mov bx,2d94h    ;������� ������, ����������� �����������
            mov ds,bx         ;(INT 01h) �� ������ TF=1
            mov bx,1                ;����� ������
            mov cx,2                ;������� ���������
       nxt: xor ah,ah              ;����� 
            mov al,xxx[bx]       ;������� ���������
            mov dh,100            ;��������
            div dh                     ;������� �� 100
            mov dl,al               ;�����
            mov al,ah               ;�������
            push ax
            or dl,30h                ;ASCII c����� �����
            mov ah,2
            int 21h                   ;����� �� �����
            pop ax
            xor ah,ah
            mov dh,10
            div dh                    ;������� �� 10
            mov dl,al
            mov al,ah
            or dl,30h
            mov ah,2
            push ax
            int 21h                   ;����� �� ����� ��������
            pop ax
            mov dl,al
            or dl,30h
            int 21h                   ;����� �� ����� ������
            mov dl,20h
            int 21h                  ;����� �� ����� �������
            dec bx                   ;��������� �����
            loop nxt
            pop ds
            endm
      out_scr macro mes      ;������ ������ �� ����� ���������
           mov dx,offset mes
           mov ah,09h
           int 21h
           endm
 .stack 100h
.data
mes_1 db 'Flag TF=0', 0dh, 0ah, '$'
mes_2 db 'Flag TF=1', 0dh, 0ah, '$'
mes_3 db 'SI = ', '$'
.code
strt:mov ax,@data     
      mov ds,ax
      mov si,0ffaah        ; �������� ��� ��� SI
      pushf
      mov bp,sp                ; ���������� ����������� ������ TF
       xor word ptr [bp], 100h 
      ;out_scr mes_1
       out_scr mes_2
       popf                     ; ��������� ������ TF � �������
      out_scr mes_3
      scr 9c70h         ;������ ������, ��� ���������� �������� SI
      mov dl,0dh       ; ������� �������  
      int 21h              ; �� ����� ������
       mov dl,0ah       ; ������� �������  
      int 21h              ; � ������ ������
      mov ax,4c00h      
      int 21h              
      end strt 
