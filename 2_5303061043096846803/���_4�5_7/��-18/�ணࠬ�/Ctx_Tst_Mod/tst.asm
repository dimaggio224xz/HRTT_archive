  masm  ;��������� ������ ���������� tst.asm � ���� ����� ������� ��������
    model small                                                    
   .stack 100h                                                                   ; ���������� �������� �����
   .data                                                                              ;���������� �������� �����
      CT_L db 000,000,127,127           ;���������� ���� CTL
      CT_H db 000,128,000,128          ;���������� ���� CTH
    mes_1 db '            1 State  CTX before testing',0dh,0ah,0ah, '$'
    mes_2 db '            -----------------------------------------------',0dh,0ah, '$'
    mes_3 db '              CTL:',20h,'$'
    mes_4 db '              CTH:',20h,'$'
   mes_5 db '                   Program testing OT-416_09_Petrenko',0dh,0ah, '$'
   mes_6 db '            __________________________________________________________',0dh,0ah, '$'
   mes_7 db '  ',0dh,0ah, '$'
   mes_8 db '            2 State after testing oper While CTH<CTL do CTH:=CTH+1',0dh,0ah, 0ah,'$'
   mes_9 db '            3 State after testing oper Repeat CTL:=CTL-1 Until CTL>CTH',0dh,0ah,0ah, '$'
   mes_10 db '            4 State after testing oper Func CTL:=not CTL',0dh,0ah,0ah, '$'
      len equ 4           ;ʳ������ ���������� �����
       .code                 ;���������� ����������� �������� 
inp_key macro         ;������ ���������� ���������� ������ �
             local lpp 
             mov ah,07h
      lpp: int 21h
             cmp al, 'x'
             jne lpp
             endm
        Whil proc near                   ;��������� ����� �������� �����
                 mov cl,CT_l[bx]         ;CTX := �������� ���������� ���� 
           cc1:cmp CT_h[bx],cl        ;��������� (CTH)-(CTL)
                 jae cc2                        ;����������� ������  Con_1             
                 inc byte ptr CT_h[bx] ;��������� ��������� Oper_1           
                 jmp cc1                        ;���������� �������   
           cc2:ret
         endp
       Rpet proc near                    ;��������� ���� �������� �����
                mov ch,CT_h[bx]      ;CTX := �������� ���������� ����
         cc3:dec byte ptr CT_l[bx]  ; ��������� ��������� Oper_2
                cmp CT_l[bx] , ch       ; ���������  (CTL) - (CTH)            
                jbe cc3                         ; ����������� ������  Con_2
                ret
         endp
  Funk proc near                  ;��������� ���������� �������
             mov cl,CT_l[bx]  
             not cl                     ; �����������
             mov CT_l[bx], cl
             ret
      endp
         scr macro x                  ;������ ������ �� ����� ����� CTX
                local nxt                 ;���� ������
                xor bx,bx                ;���� ������
                mov cx,len              ;˳������� �����
         nxt: xor ah,ah                ;������� �������
                mov al,x[bx]           ;�������� ����
                trn                          ;��������� �� ����� �����
                mov ah,2     
                mov dl,20h
                int 21h                    ;���� �� ����� ��������
                inc bx                      ;�������� ������
                loop nxt                   ;������� �� ����������
                mov dl,0dh                
                int 21h                     ;�������� ������� �� ����� �����
                 mov dl,0ah
                int 21h                     ;�������� ������� � ������� �����
       endm
          trn macro                      ;������ ������������ �� ���������
                local mxt                 ;���� ������
                mov dh,100             ;ĳ�����
        mxt: div dh                       ;ĳ����� 
                mov dl,al;                ;������ �� ������
                mov al,ah                ;������ �� ������
               xor ah,ah
                push ax	             ;���������� � �����
                or dl,30h                  ;ASCII ������ 
                mov ah,2                 ;������� DOS
                int 21h                     ;��������� �� ����� 
               xor ah,ah
               mov al,dh
               mov dh,10
               div dh                      ;ĳ����� �� 10
               mov dh,al
               pop ax	            ;���������� �� �����
               or dh,dh	            ;������� �������
               jnz mxt                    ;������� �� ����������             
        endm
   out_scr macro mes	   ;������ ������ �� ����� �����������
                mov dx,offset mes  ;������ �����������
                mov ah,09h	        ;������� DOS
                int 21h
    endm
 Stat  macro 	         ;������ ������ �� ����� �����������
           out_scr mes_3          ;�� �����  
            scr CT_L                 ;�����
            out_scr mes_4         ;���������
            scr CT_H                ;��  ����������
            out_scr mes_7         ;������� ����� ������
            out_scr mes_6         ; ����������� �����
    endm
    Exe_Scr   macro  P       ;������ ���������� �����
          local lp
             mov di,len              ;˳������� �����  
            xor bx,bx                 ;�������� ��������� �������
        lp:call P                       ;������ ��������� ���������� 
            inc bx                       ;�������� ������ ����� � ����� 
            dec di                       ;��������  ��������� �����   
            jnz lp	          ;������� �� ��������� ����
      endm
                       start:mov ax,@data        ;������� ��������
                               mov ds,ax                ;��������� �������� �����
                               out_scr mes_5        ; ����������� ��� �����
                               out_scr mes_2        ; ����������� ����������� ��
                               out_scr mes_1         ;����������� ��� ���� �� ����������
                               Stat                          ;��������� ����� ���������
                               Exe_Scr Whil          ;���������� ����� � ����� ����� ������� ������
                               out_scr mes_8         ;����������� ��� ���� ���� 䳿 ����� �������� �����
                               Stat                          ;��������� ����� ���������
                               Exe_Scr Rpet           ;���������� ����� � ����� ���� ������� ������
                               out_scr mes_9          ;����������� ��� ���� ���� 䳿 ���� �������� �����
                               Stat                           ;��������� ����� ���������
                               Exe_Scr  Funk         ;���������� ����� � ����� ���� ���������� �������
                               out_scr mes_10        ;����������� ��� ���� ���� 䳿 ��������� �������
                               Stat                           ;��������� ����� ���������
                               inp_key                     ;��������� ���������� ������� ������� �
                               mov ax,4c00h         
                               int 21h                      ;����������  � DOS
                        end start