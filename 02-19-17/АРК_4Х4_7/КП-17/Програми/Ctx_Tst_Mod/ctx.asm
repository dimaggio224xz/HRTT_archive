Masm        ;ctx.asm � ���� ����� ��������� ��������  ��������� ��'����� 
model small
.stack 100h
.data
MS equ 90h	;������� ������������� ��������
;������� ����������� ���� ����� � ��������
CNB_0 equ 00h	;�������� � ���� CNB 
CNB_1 equ 01h	;��������� � ������� CNB
WAY_0 equ 04h	;�������� � ���� WAY 
WAY_1 equ 05h	;��������� � ������� WAY
MOD_0 equ 08h	;�������� � ���� MOD
MOD_1 equ 09h	;��������� � ������� MOD
SEL_0 equ 0Ch	;�������� � ���� SEL
SEL_1 equ 0Dh	;��������� � ������� SEL
RED_0 equ 0Eh	;�������� � ���� RED 
RED_1 equ 0Fh	;��������� � ������� RED
time dw 3, 4, 6, 7, 8, 11, 12, 15, 16, 19, 20, 21, 24 ;��������� ��������� ��-������
del dw 1000, 2000, 3000, 4000, 5000, 6000, 7000, 8000, 9000
Q db 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12  ;ٳ������� ������� ���������
;���������� ������ ��������
cr equ 6Eh	;������ ���������
pa equ cr+2	;���� �
pb equ cr+4	;���� �
pc equ cr+6	;���� �
pio equ cr+7	;���� ��������-���������
mes_1 db '                  CONTROL COUNTER CTX_OT-416_09_Petrenko',0dh,0ah, 0ah,'$'
mes_2 db '                  ERROR STATE  CTX_OT-416_09_Petrenko', 0dh, '$'
mes_3 db '                  CONTROL SUCCESS CTX_OT-416_09_Petrenko',0dh,0ah, 0ah,'$'
        .code
inp_key macro         
           mov ah,07h
    lpp: int 21h
           cmp al, 'x'
           jne lpp
           endm
        stb proc near          ;��������� ���������� STB
       stb_1 equ 03h    ;������� BSR �������� 
       mov al, STB_1   ;������� ��������� STB
all: call imp	         ;���������� ��������
	 ret                        ;���������� �� ���������
  endp
clr proc near              ;��������� ���������� CLR
    clr_1 equ 0dh
	mov al, clr_1        ;������� ��������� CLR
	jmp all	         ;������� �� ����������
	endp 
clk proc near
       clk_1 equ 09h    ;��������� ���������� CLK
       mov al, clk_1
	  jmp all
	  ret                      ;���������� �� ���������
 endp
imp proc near          ;��������� ���������� ��������
	 out cr,al	        ;��������� � �������
	 call delay	        ;�������� ��������� ��������
	 dec al	        ;���������� ������� ��������
	 out cr,al	        ;�������� � ����
      call paus             ;�������� �����
	 ret                      ;���������� �� ���������
endp
delay proc near        ;��������� ���������� ��������
	   push cx	        ;ϳ�������� ��������� �����
	   mov cx, time+8	;�������� ����������� �����
  ext:push cx	        ;����������� ���������
	   mov cx, del+2   ;�������� ����������� �����
  ier:loop ier	       ;��������� ����
	   pop cx	       ;���������� ���������
	   loop ext	        ;��������� ����
	 pop cx	       ; ���������� ��������
      ret                       ;���������� �� ���������
endp
      paus proc near              ;��������� ���������� �����
	lea bx, Q+5	       ;����� ��������
	mov al, [bx]	        ;��������� ��������
       next:call delay             ;������ ��������
	dec al	                  ;�������� ���������
	jnz next
	 ret                       ;���������� �� ���������
endp
   out_scr macro mes	   ;������ ������ �� ����� �����������
                mov dx,offset mes  ;������ �����������
                mov ah,09h	        ;������� DOS
                int 21h
    endm
        start:   mov ax, @data          ;������� �������� ���������
	               mov ds,ax                 ;���������� �������� �����
                   out_scr  mes_1         ;����������� ��� ������ ���������
                   out_scr  mes_2          ;����������� ��� ������� ���������
jmp rrr
	              mov al, MS	         ;������������� 
	              out cr, al	                    ;��������
	              xor al, al	                    ;���� � ���� 
	              out pc, al	                    ;���� ����� �
	              in al, pio	                    ;������� �����
             out pb, al	                    ;����� � ���� �
              mov al, CNB_1  	;���������
	              out cr, al	                   ;� ������� ���� CNB
                   call stb	                    ;����� � �������� CTH
                   mov al, WAY_1	;��������� � �������
	              out cr, al	                    ;���� WAY
                   call stb	                    ;����� � �������� CTL
    in al, pa	                    ;������� ��������� CTX
    and al,0fh            	;���������� CTL
    mov ah, al	          ;���������� �������� CTL
    mov al, RED_1	          ;��������� � �������
    out cr, al	                    ;���� RED
                   mov al,MOD_1           ;��������� � �������
    out cr,al	                    ; ���� MOD
    mov al, 0fh	          ;������ ������� � �������
   out pb, al	                    ;�������  ����� �
           whil:in al,pa                      ;����� ������� ���� ��������  - ������� CTX
	              and al, 0fh	          ;���������� CTH
	              cmp al, ah	          ;��������� (CTH)-(CTL)
	              jae exec	                    ;������ ��� ������� (CTH)>=(CTL)
	              call stb	                    ;�����  CTL:=1111
	              call clk	                    ;ĳ� CTX:=CTX +1
	              jmp whil	                    ;���������
           exec:mov al,ah
                   out pb, al	                    ;������ � ���� � ������� �������� CTL
	              call stb	                    ;����� � CTL
	              in al,pa	                    ;������� �TX
	              and al, 0fh	          ;���������� CTH
	              mov ah,al	                    ;���������� CTH
                   mov al,MOD_0          ;��������� � ����
	              out cr,al	                    ;���� MOD
	    mov al,RED_0	          ;���� � ���� 
	    out cr,al	                    ;���� RED
             rpit:call clk                      ;���� ������� ����  - �������� CTL:=CTL - 1
	              in al,pa	                    ;������� ��������� CTX
	              and al,0fh	                    ;���������� � al �������� CTL
	              cmp al,ah	                   ;��������� (CTL)-(CTH)
                   jbe rpit                           ;����� (CTL) <= (CTH)
                   not al
                   out pb,al 
	    call stb	                    ;���������� CTH
	              mov al,CNB_0	          ;�������� � ���� 
    out cr,al	                    ;���� CNB
    mov al,WAY_0 	;�������� � ����
	    out cr,al	                    ;����  WAY
	    mov al,ah	                    ;�������� � ���� �
                   out pb,al             	;������� �������� CTH
          call stb	                   ;����� � CTL
         in al,pa	                    ;������� CTX
	    out pio, al	                   ;����� � ���� PIO
       rrr:            out_scr  mes_3           ;����������� ��� ���������� ���������
                  
               inp_key
               mov ax,4c00h            ;���������� � ����������
                   int 21h                       ; ���������� MS DOS
            end start
