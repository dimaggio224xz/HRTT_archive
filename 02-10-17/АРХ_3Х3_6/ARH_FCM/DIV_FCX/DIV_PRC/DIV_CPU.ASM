.model small
.stack 256
out_str macro str         ;�������� ���i窨 �� ��࠭
        mov dx,offset str
        mov ah,9
        int 21h
        endm
inp_key macro         ;�������� ᨬ���� � ����i����
           mov ah,07h
    lpp: int 21h
           cmp al, 'x'
           jne lpp
           endm
inp_dat macro ope                ;��������  ������ � ����i����
        local lpp,rpt,s30,cor,sto
        mov ah,7                     ;�㭪�i� ���
        lea bx,ope                   ;���� ��i���� � �����i
        mov dh,4                     ; �i��i��� ����i� ��i����
  lpp:mov dl,2                     ;�i��i��� ��ࠤ � ����i�
  rpt:int 21h                        ; �������� ᨬ���� � ����i����
        cmp al,30h
        jb rpt                           ; ������ �� � ஡�稬
        cmp al,40h                 
        jb s30                           ; ASCII ᨬ��� � ����
        cmp al,60h
        jbe rpt                          ; ASCII ᨬ��� �� � ����
        cmp al,67h
        jnb rpt                          ; ASCII ᨬ��� �� � ����
        sym                               ;���������� ᨬ���
        sub al,57h                     ;���⢮७�� ASCII � ���
        jmp cor
    s30:cmp al,3ah 
       jae rpt                                 ;������ �� � ஡�稬
        sym                                     ;���������� ���
        sub al,30h                          ;���⢮७�� ASCII � ���� 
    cor:dec dl
        je sto                                  ;����i� �� ���०����
        mov cl,4
        shl al,cl
        mov [bx]+3,al               ;���०���� ����� ��ࠤ�
        jmp rpt
    sto:add [bx]+3,al              ;���०���� ������ ��ࠤ�
    push ax 		  ;����ᮢ� ���०����
    push dx 
        mov ah,2
        mov dl,' '
        int 21h                     ;���������� �ய��
     pop dx
     pop ax
        dec bx                 ;����襭�� ����
        dec dh                 ;��४�i� �i稫쭨�� 横��
        jne lpp
        mov ah,2
       mov dl, 'h'                 
       int 21h	                  ;���������� ᨬ���
      curs_beg 
       endm
       
scr_ddw macro adr          ;��������� ���i窨
        local nxt
        push bx
       push cx
        lea bx,adr                ;���⪮�� ���� ���i窨
       add bx,3
        mov cx,4                  ;������� ���i窨
    nxt:scr_byt                  ;��������� ⥪�箣� ����� ���i窨
        dec bx
        loop nxt                    ;����i� �� ����㯭�� ����
      pop cx
       pop bx
       mov ah,2
       mov dl, 'H'
       int 21h	                    ;���������� ᨬ���
       cursor 
       endm
                    scr_byt macro 		    ;��������� ������ �����
	 local comp,symb,scrn,exit
		mov ah,2		     ;�㭪�i� ��⥬���� ���ਢ����
		mov dh,1		     ;��⠭���� �࠯�� �����㢠�
		mov dl,[bx]		     ;��।�� ⥪箣� �����
		shr dl,4	     ;��।�� ����� ��ࠤ� � �������
	           comp:cmp dl,10		      ;���i��ﭭ� � ����⪮�
		jnc symb		       ;����i� �i��� ��� �i��� ������
		add dl,30h	      ;���㢠��� ASCII ᨬ���� �ᥫ 0,1,..,9
		jmp scrn		       ;����i� �� ���i� ᨬ����
	           symb:add dl,37h	       ;���㢠��� ASCII ᨬ���� �ᥫ 10,11,..,15
	             scrn:int 21h		      ;���i� ᨬ����
		or dh,dh		      ;����i�
		jz exit 		      ;�࠯�� �����㢠�
		mov dh,0		     ;����  �࠯�� �����㢠�
		mov dl,[bx]		     ;��।�� ⥪�箣� �����
		and dl,0fh		      ;���㢠��� ������� ��ࠤ�
		jmp comp	     ;����i� �� ��஡�� �������  ��ࠤ�  ᨬ����
	               exit:mov dl,' '	                  ;���i� ᨬ����
		int 21h 
                     endm
                     
       zer_tst macro opr             ;����㢠��� ��i窨 �� ����
        local nnx,stp
        lea bx,opr
        mov cx,4
    nnx:or byte ptr [bx],0     ;������i� ���'�i�
        jne stp
        inc bx
        loop nnx
        xor bx,bx                     ;��⠭���� �࠯�� ZF
   stp:endm
           
 cursor macro                     ;��६i饭�� ������
        mov ah,2                       ;�㭪�i� ���
        mov dl,0ah                   
        int 21h
        mov dl,0dh
        int 21h
        endm
curs_beg macro                     ;��६i饭�� ������ � ���⮪ ���i窨
        mov ah,2
        mov dl,0dh
        int 21h
        endm


   sym macro                      ;��������� ASCII ᨬ���� �����
       push ax
       push dx
       mov ah,2                   ;�㭪�i� ���
       mov dl,al
       int 21h
       pop dx
       pop ax
         endm

        ;������� �����
        .data
        mes1 db '                         Exeption Overflow',0ah,0dh,'$'
        mes2 db '                         Exeption Underflow',0ah,0dh,'$'
        mes3 db '                         Exeption Absents',0ah,0dh,'$'
        mes4 db '                      Dividend: ','$'
    mes5 db '                      Divisor : ','$'
    mes6 db '                      Quotient: ','$'
    mes7 db '              EMULATE DIVISION  SINGLE PROCESSOR CPU PENTIUM',0ah,0dh,'$'
   mes10 db '                STOP DIVISION  SINGLE PROCESSOR CPU PENTIUM',0ah,0dh,'$'
   mes11 db '                         Error division zero',0ah,0dh,'$'
opr_x  dd  ?            ;���i� �����  �i������ 
opr_y  dd  ?            ;�i�쭨��, �i ��������� � ����?���� 
        ;������� ��������
        .code
Man_Div proc near                        ;��楤�� �i����� �����
              mov cx, 24                          ;�i��i��� ஧��i�
               and word ptr [di]+2,0ffh  ;���� � ���� ���讣� ����� �i�쭨��
               mov ax,[si]                         ;�����⠦����
              mov dx,[si]+2                      ; � (dl:ax):=Mx
              and dx,0ffh                          ;���� � ���� ���讣� ����� �i������  
         lop:sub ax,[di]                        ;�i��i����� ���� ����i� 
               sbb dx,[di]+2                    ;�����, � � ����� 
               cmc                                    ;���㢠��� �i�� ��⪨
               pushf 
               jc nng
               add ax,[di]                          ;���������� �i�'󬭮� ����i  
               adc dx,[di]+2
      nng: popf      
              rcl word ptr [si],1                  ;��� �ࠢ� � 
              rcl byte ptr [si] +2,1               ;����� �i�� ��⪨
              shl ax,1                                    ;��� �ࠢ� 
              rcl dx,1                                    ; ����i
              loop lop                                    ; ����i� �� ����� 横�
              mov cl,[si]+2                              ;����㢠��� ���讣� 
              or cl,cl                                        ; �i�� ��⪨
              js nsh                                    ;����� ��ଠ�i������
              sub ax,[di]                            ;���㢠���
              sbb dx,[di]+2                        ;�i��
              cmc                                       ;��⪨
            rcl word ptr [si],1                  ;��� ��⪨ 
            rcl byte ptr [si]+2,1               ;�ࠢ�
            dec bl                                      ;����襭�� �ࠪ���⨪� ��⪨
            cmp bl,255                              ;����㢠��� �� ��⨯�९�������
             je und                                     ;� ��⨯�९�������
      zer: cmp bl,0                                ;����㢠��� �� ��⨯�९�������
              jne ext                                  ;����� ��⨯�९�������
   und:out_str mes2                           ;��⨯�९�������
   ext:  ret
     nsh:cmp bl,255                            ;����㢠��� �� ��९�������
             jne zer
            out_str mes1                            ;��९�������
            jmp ext
             endp
  main:mov ax,@data
           mov ds,ax
           out_str mes7            ;���i�������� 7
           lea si,opr_x              ;I�i�i��i���i� ����i�
           lea di,opr_y              ;���࠭�i� 
           mov bp, 4                 ;�i��i���� �i���� 
            cursor
   nxt:  out_str mes4
             inp_dat opr_x ;�������� �i������
             out_str mes4
             scr_ddw opr_x ;���祭�� �i������ �� ��࠭i
             out_str mes5
             inp_dat opr_y ;�������� �i�쭨��
             out_str mes5
             scr_ddw opr_y ;���祭�� �i�쭨�� �� ��࠭i
             zer_tst opr_y    ;����㢠���  Y=0
            jnz exc              ;����i� �� ����㯭� �i�
            out_str mes11    ;� ������� �i����� �� ����
            jmp xxx             ; ����㯭�� ���i� ���࠭�i�
       exc: zer_tst opr_x    ;����㢠���   X=0
             jz yyy               ;�i���� �� ����
           mov bh,[si]+3         ;�����祭�� �����
           xor bh,[di]+3          ;��⪨ �i� �i����� (BH[7])= Sz
           mov bl,[si]+2          ;���᫥���
           add bl,bl                 ;�ࠪ���⨪�
           mov bl,[si]+3          ;�i������
           rcl bl,1                    ;� (BL) = Ex
           mov al,[di]+2          ;��客���� �i� �i�쭨��
           add al,al                 ; � �࠯��i CF   
          mov al,[di]+3         ;��ࠪ���⨪� �i�쭨��
           rcl al,1                   ;� (AL)=Ey
          or byte ptr [si]+2,80h ;���������� � �����i ��客����
          or byte ptr [di]+2,80h ;�i�i� ���࠭�i�
          sub bl,al                         ;���᫥��� Ez:=Ex-Ey
           jnc min                           ;�i����� ������
           sub bl,129                     ;���᫥��� (256 - 129 )=127 
           jnc man                           ;�����祭�� �i�����
   xan:  out_str mes2              ;�����祭�� ��⨯�९�������
           jmp  xxx                      ;���i� � �ணࠬ� �i�����
   min: add bl,127                  ;��i饭�� ��⪨
           jnc man                                   ;�����祭�� �i�����
           out_str mes1           ;�����祭�� ��९�������
           jmp  xxx                  ;���i� � �ணࠬ� �i�����
   man:call Man_Div          
            shl byte ptr [si]+2,1 ;��� �i�� ���讣� ����� ����� ��⪨
            shr bl,1                     ;��� �ࠢ� ����� �ࠪ���⨪� ��⪨
            rcr byte ptr [si]+2,1;��� �ࠢ� ���讣� ����� ����� ��⪨
            and bh,80h               ;���㢠��� 
            or bl,bh                    ;����� ��⪨
            mov [si]+3,bl            ;� ����� � ������ 
  yyy:   out_str mes6       ;���i�������� 6
            scr_ddw opr_x    ;��������� ��⪨
             out_str mes3       ;���i�������� �� ��������i��
  xxx:   dec bp
            je ntx                ;���� �������� ��� ࠧ�
            jmp nxt             ;���㦥��� �� ����㯭�� 横�
    ntx: cursor
    out_str mes10              ;���i�������� �� ���i�祭�� �i�����
           inp_key
        mov ax,4c00h
            int 21h
        end main

