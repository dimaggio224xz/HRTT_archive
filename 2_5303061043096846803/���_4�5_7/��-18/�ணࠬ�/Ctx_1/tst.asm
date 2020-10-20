  masm  ;��������� ������ ���������� tst.asm � ���� ����� ������� ��������
    model small                                                    
   .stack 100h                                                                   ; ���������� �������� �����
   .data                                                                              ;���������� �������� �����
      CT_L db 000,000,127,127,128,255           ;���������� ���� CTL
      CT_H db 000,128,000,128,255,128          ;���������� ���� CTH
    mes_1 db '1 State  CTX before testing',0dh,0ah,0ah, '$'
    mes_2 db '---------------------------------',0dh,0ah, '$'
    mes_3 db 'CTL:',20h,'$'
    mes_4 db 'CTH:',20h,'$'
   mes_5 db 'Program testing OT-419_06_Jemets',0dh,0ah, '$'
   mes_6 db '_________________________________',0dh,0ah, '$'
   mes_7 db '  ',0dh,0ah, '$'
 mes_8 db '3 State after testing oper WHILE',0dh,0ah, 0ah,'$'
 mes_9 db '4 State after testing oper REPEAT',0dh,0ah,0ah, '$'
mes_10 db '2 State after testing oper FUNCT',0dh,0ah, 0ah,'$'
       len equ 6          ;ʳ������ ���������� �����
       .code                 ;���������� ����������� �������� 
          fnc_B proc near                 ;��������� ��������� ����� ���������
                 mov cl,CT_l[bx]   ;CTX := �������� ���������� ���� 
           cc1:cmp CT_h[bx],cl                ;��������� (CTH)-(CTL)
                 jb cc2                      ;����������� ������  Con_1             
                 inc byte ptr CT_h[bx]   ;��������� ��������� Oper_1           
                 jmp cc1                     ;���������� �������   
          cc2:ret
        endp
    fnc_A proc near                 ;��������� ��������� ����� ���������
                mov ch,CT_h[bx]   ;CTX := �������� ���������� ����
         c3: dec byte ptr CT_l[bx]                    ; ��������� ��������� Oper_2
                cmp CT_l[bx] , ch               ; ���������  (CTL) - (CTH)            
                jb c3                        ; ����������� ������  Con_2
                ret
        endp
 fnc_F proc near    
            mov ch,CT_h[bx]   ; �������� ������
            and CT_l[bx], ch               ;������� ���������
            not byte ptr CT_l[bx]
             ret
      endp
          scr macro x                  ;������ ������ �� ����� ����� CTX
                local nxt                 ;���� ������
                xor bx,bx                ;���� ������
                mov cx,len              ;˳������� �����
         nxt: xor ah,ah                 ;������� �������
                mov al,x[bx]           ;�������� ����
                 mov dh,100            ;ĳ�����
                div dh                      ;ĳ����� �� 100
                mov dl,al;               ;����
                mov al,ah                ;������ �� ������
                push ax	;���������� � �����
                or dl,30h                  ;ASCII ������ ������
                mov ah,2                 ;������� DOS
      int 21h                     ;���� �� ����� ������
               pop ax	 ;���������� �� �����
                xor ah,ah	 ;������� �������
                mov dh,10
                div dh                      ;ĳ����� �� 10
                mov dl,al                 ;�������  
                mov al,ah                 ;�������
                or dl,30h                  ;ASCII ������ �������
      mov ah,2                  ;������� DOS
      push ax	                  ;���������� � �����
                int 21h                     ; ���� �� ����� �������         
                pop ax	         ;���������� �� �����
                mov dl,al
                or dl,30h                  ;ASCII ������ �������
                int 21h                     ;���� �� ����� �������
                mov dl,20h
                int 21h                     ;���� �� ����� ��������
                inc bx                      ;�������� ������
                loop nxt                   ;������� �� ����������
                mov dl,0dh                
                int 21h                     ;�������� ������� �� ����� �����
                 mov dl,0ah
                int 21h                     ;�������� ������� � ������� �����
       endm
   out_scr macro mes	   ;������ ������ �� ����� �����������
                mov dx,offset mes  ;������ �����������
                mov ah,09h	        ;������� DOS
                int 21h
    endm
 Stat  macro 	   ;������ ������ �� ����� �����������
           out_scr mes_3         ;�� �����  
            scr CT_L                 ;�����
            out_scr mes_4         ;���������
            scr CT_H                ;��  ����������
            out_scr mes_7         ;������� ����� ������
            out_scr mes_6         ; ����������� �����
    endm
    Exe_Scr   macro  P	   ;������ ������ �� ����� �����������
          local lp
             mov di,len              ;˳������� �����  
            xor bx,bx                ;�������� ��������� �������
        lp:call P                    ;���������� �� ��������� ����  
            inc bx                      ;�������� ������
           dec di                       ;��������  ��������� �����   
            jnz lp	                    ;������� �� ��������� ����
      endm
                       start:mov ax,@data	    ;������� ��������
                                 mov ds,ax               ;��������� �������� �����
                                 mov ax,3
                                ;int 10h                     ;��������� ����� ������� 80*25
	         out_scr mes_5        ; ����������� ����� 
                          out_scr mes_2        ; ����������� ����� 
                         out_scr mes_1         ;������
                         Stat 
  Exe_Scr fnc_F
   out_scr mes_10        ;������
   Stat 
                         Exe_Scr fnc_B
                         out_scr mes_8         ;������
                        Stat 
                        Exe_Scr fnc_A
                       out_scr mes_9         ;������
                       Stat 
                     
                     mov ax,4c00h         
                     int 21h                      ;����������  � DOS
                        end start