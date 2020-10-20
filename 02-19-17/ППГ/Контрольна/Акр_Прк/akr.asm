 ;���������� ������ �������� ����������
.model small					 ;��� ����� �����
.stack 100h					 ;������� �����
.data						 ;������� �����
X db 0, 126, 64, 1, 255, 193, 64, 192;������ ������� 
Y db 0, 64, 126, 0, 128, 127, 248, 15;������ �������   
len equ $-Y  
Z db len*2*4 dup (?)
    mes_1 db '              Beginning of the job processing',0dh,0ah,0ah,'$'
    mes_2 db '              1 Initial state',0dh,0ah,'$' 
    mes_3 db '              2 State after While  Y<X  do Y:=Y-1',0dh,0ah,'$'
    mes_4 db '              3 State after execute function X:=X xor  Y',0dh,0ah, '$'
    mes_5 db '              4 State after Repeat  X:=X+1  Until X>=Y ',0dh,0ah,'$'
    mes_6 db '              Completion of the job processing',0dh,0ah, '$'  
   mes_7 db ' X:',20h,'$'
   mes_8 db ' Y:',20h,'$'  
   mes_9 db '  ',0dh,0ah, '$'			
.code  ;������� ��������  

                 srv macro  Pnt	    ;����� ��������� ���������
	   local lop
	    mov cx,len	     ;˳������� �����  
	    mov bx,offset x	     ;������ ������ �����
                lop:call Pnt	                         ;���������� �� ��������� ����  
	    inc bx		     ;�������� ������
	    loop lop		     ;��������  ��������� �����   	  
	    endm  

                Whi proc near	;���������� ��������� ������������� �����
	    mov al,[bx] 	;������� �������� ������� �������� 
                Whl:cmp [bx]+len,al	;��������� �� ���������� ��� ������� �����
	    jge nx1		; ������� ������ ��������� Y >= X
	    dec byte ptr [bx]+len ; ĳ� ����������Y:=Y - 1
	    jmp Whl		      
                nx1:ret 
	    endp Whi  

                fnc proc near
	    mov al,[bx]+len	 ;������� �������� ������� �������� 
	    xor [bx],al                 ;������� ���������	   
	    ret 
	    endp  fnc 

                        rpi proc near	 ;���������� ��������� �������
	    mov al,[bx]+len	 ;������� �������� ������� �������� 
                 rip:inc byte ptr [bx]	  ;��������� X:=X - 1         
	   cmp [bx],al	 ;��������� �� ���������� ��� ������� �����
	    jl rip		  ;������� ������ ��������� X<Y
	    ret 
	    endp rpi

                  trn macro p	    ;��������� ����� � len*p   �����
	    mov cx,len                    ;˳������� �����
	    lea si, x	                        ;��������� ������
                        mov di,len*p               ;�=2,4,6,8
                rep movsw	                        ;������� ���������
	    endm
				  
	mes macro msg			       ;������ �����������
	    mov ah,09h			       ;��������� 
	    mov dx,offset msg		       ;�����������
	    int 21h			       ;�� ������������   
	    endm

                                 scr macro xx		 ;������ ������ �� ����� ����� CTX
		local nxt		  ;���� ������
		xor bx,bx		 ;���� ������
		mov cx,8	                     ;˳������� �����
	            nxt: xor ah,ah 		 ;������� �������
		mov al, xx[bx]	;�������� ����
		 mov dh,100	 ;ĳ�����
		div dh		  ;ĳ����� �� 100
		mov dl,al                        ;����
		mov al,ah		 ;������ �� ������
		push ax                           ;���������� � �����
		or dl,30h		   ;ASCII ������ ������
		mov ah,2		   ;������� DOS
	                    int 21h		   ;���������  �� ����� ������
	                    pop ax	                     ;���������� �� �����
		xor ah,ah	                      ;������� �������
		mov dh,10
		div dh		   ;ĳ����� �� 10
		mov dl,al		  ;�������  
		mov al,ah		  ;�������
		or dl,30h		   ;ASCII ������ �������
	                   mov ah,2 		  ;������� DOS
	                   push ax		  ;���������� � �����
		int 21h 		    ; ����������� ����� �������         
		pop ax		 ;���������� �� �����
		mov dl,al
		or dl,30h		   ;ASCII ������ �������
		int 21h 		    ;��������� �� ����� �������
		mov dl,20h
		int 21h 		    ;��������� �� ����� ��������
		inc bx		    ;�������� ������
		loop nxt		   ;������� �� ����������
		mov dl,20h		  
		int 21h 		      ;��������� �� ����� ��������
		mov dl,20h		   
		int 21h 		      ;��������� �� ����� ��������
                                       endm

               exe macro 		                      ; ������ ����������� ������ �����
	  mes mes_9		   ; ������ �� ������� �� �� ���� ������
	  mes mes_7		   ; ����� �
	  scr  x		                       ; ��������� � DEC ������
	  xyz	x		   ; ��������� � HEX ������
	  mes mes_9		   ; ������ �� ������� �� �� ���� ������
	  mes mes_8		   ; ����� Y
	  scr  y		                       ; ��������� � DEC ������
	  xyz	y		   ; ��������� � HEX ������
	  mes mes_9;                                      ; ������ �� ������� �� �� ���� ������
	  mes mes_9;                                      ; ������ �� ������� �� �� ���� ������
	  endm

 scr_sym macro	           ;������ ASCII Hexmal �������  
	local fri,sym
	cmp dl,0ah          ;��������� � ��������
	jb fri	           ;����� �������
	or dl,40h	          ;���������� ������� 
	sub dl,09h	          ;����� ���� 
	jmp sym 	          ;������� �� ������
              fri:or dl,30h	          ;���������� ������� 
          sym:int 21h 	         ;������ ������� �� �����   
                  endm  

scr_byte macro		   ;������ ����� ASCII Hexmal �������
	 mov dl,[di]	    ;������������ � ����� 
	 push cx	     ;���������� � �����
	 mov cl,4	     ;���������� �������
	 shr dl,cl	       ; ����  ������ �� ������
	 pop cx 	      ;���������� �������
	 scr_sym	    ;������ �������� ������� �����
	 mov dl,[di]	   ;������������ ���� � ����� � ����� 
	 and dl,0fh	    ;�������� ������ �������
	 scr_sym	     ;������ ��������� ������� �����
	 mov dl,20h	   ;������  ������� 
	 int 21h	       ;�������
	 endm
	 
               xyz macro   adr  ;������ ����� ASCII ������� �����   
	  local next
	   mov cx,8
	   lea di, adr
             next:scr_byte       ;������ ����� ASCII �������
	     inc di	       ;��������� ������
	     loop next	      ;��������� ��������� �� �������
	     mov dl,'h'       ;������
	     int 21h		;������� h
	     endm	      
    
  sta:mov ax,@data			 ;�����������        
      mov ds,ax 			 ;������� �� 
      mov es,ax 			 ;���������� ��������
      cld 
 mes mes_9;
      mes mes_1 	  ;����������� ��� ������� ���������� ������
      mes mes_2; 
exe                                    ;���� ���� ������ ��������� �����
       trn 2		   ;��������� ��������� �����
      srv Whi                       ; ���������� ����� �������� �����
      mes mes_3               ; ���� ��������� ����� �������� �����
exe                                    ;���� ���� ������ ��������� ����� �������� �����
      trn 4		   ;��������� ������������� ����� �������� �����
      srv fnc                         ; ���������� �������
      mes mes_4               ; ���� ��������� �������
exe                                    ;���� ���� ������ ����������������
      trn 6		   ;��������� ���� �������� �������                                     
      srv rpi                        ; ���������� ���� �������� �����
      mes mes_5               ; ���� ��������� ����  �������� �����
exe                                    ;���� ���� ������ ��������� ����  �������� �����
      trn 8		     ;��������� ������������� ����  �������� �����
      mes mes_6 	   ;����������� ��� ��������� ���������� ������  
      mes mes_9               ;������ �� ���� ����
      mov ax,4c00h	   
      int 21h			   ;����������  � DOS
      end sta