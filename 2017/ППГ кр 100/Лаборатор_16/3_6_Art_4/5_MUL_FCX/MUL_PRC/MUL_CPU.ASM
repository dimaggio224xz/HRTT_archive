.model small  ;�����?� �������� � CPU PENTIUM 
.stack 256
out_str macro str         ;��������� ���?窨
        mov dx,offset str
        mov ah,9
        int 21h
        endm
zer_tst macro opr             ;����㢠��� �� ����
        local nnx,stp
        lea si,opr
        mov cx,4
    nnx:or byte ptr [si],0
        jne stp
        inc si
        loop nnx
        xor si,si
    stp:endm
zer_loa macro                   ;�����⠦���� ���
        local mnx
        lea bx,opr_x
        mov cx,4
    mnx:mov byte ptr [bx],0
        inc bx
        loop mnx
        endm
cursor macro                     ;��६?饭��  ������ 
        mov ah,2                    ; �� ����
        mov dl,0ah                  ;� � ���⮪
        int 21h                         ;���?窨
        mov dl,0dh
        int 21h
        endm
curs_beg macro                     ;��६i饭�� ������ � ���⮪ 
        mov ah,2                        ;���筮� ���i窨
        mov dl,0dh
        int 21h
        endm
inp_dat macro ope                 ;��������  ������ � ����i����
        local lpp,rpt,s30,cor,sto
        mov ah,7                         ;�㭪�i� ���
        lea bx,ope                        ;���� ��i���� � �����i
        mov dh,4                       ; �i��i��� ����i� ��i����
  lpp:mov dl,2                       ;�i��i��� ��ࠤ � ����i�
  rpt:int 21h                           ;�������� ᨬ���� � ����i����
        cmp al,30h
        jb rpt                             ;������ �� � ஡�稬
        cmp al,40h                 
        jb s30                             ;ASCII ᨬ��� � ����
        cmp al,60h
        jbe rpt                            ;ASCII ᨬ��� �� � ����
        cmp al,67h
        jnb rpt                            ;ASCII ᨬ��� �� � ����
        sym                                ;���������� ᨬ���
        sub al,57h                      ;���⢮७�� ASCII � ���
        jmp cor
    s30:cmp al,3ah 
       jae rpt                                 ;������ �� � ஡�稬
        sym                                    ;���������� ���
        sub al,30h                          ;���⢮७�� ASCII � ���� 
    cor:dec dl
        je sto                                  ;����i� �� ���०����
        mov cl,4
        shl al,cl
        mov [bx]+3,al                   ;���०���� ����� ��ࠤ�
        jmp rpt
    sto:add [bx]+3,al                   ;���०���� ������ ��ࠤ�
         push ax 		                     ;����ᮢ� ���०����
         push dx 
         mov ah,2
         mov dl,' '
         int 21h                                ;���������� �ய��
         pop dx
         pop ax
        dec bx                                ;����襭�� ����
        dec dh                                ;��४�i� �i稫쭨�� 横��
        jne lpp
        mov ah,2
       mov dl, 'h'                 
       int 21h	                               ;���������� ᨬ���
      curs_beg 
       endm
    sym macro                              ;�뢮� ᨬ����
       push ax
       push dx
       mov ah,2
       mov dl,al
       int 21h
       pop dx
       pop ax
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
                   scr_byt macro 	    ;��������� ������ �����
	       local comp,symb,scrn,exit
		mov ah,2		     ;�㭪�i� ��⥬���� ���ਢ����
		mov dh,1		     ;��⠭���� �࠯�� �����㢠�
		mov dl,[bx]		     ;��।�� ⥪箣� �����
		shr dl,4	                ;��।�� ����� ��ࠤ� � �������
	           comp:cmp dl,10	      ;���i��ﭭ� � ����⪮�
		jnc symb		       ;����i� �i��� ��� �i��� ������
		add dl,30h	                 ;���㢠��� ASCII ᨬ���� �ᥫ 0,1,..,9
		jmp scrn		       ;����i� �� ���i� ᨬ����
	           symb:add dl,37h	       ;���㢠��� ASCII ᨬ���� �ᥫ 10,11,..,15
	             scrn:int 21h	      ;���i� ᨬ����
		or dh,dh		      ;����i�
		jz exit 		      ;�࠯�� �����㢠�
		mov dh,0		     ;����  �࠯�� �����㢠�
		mov dl,[bx]		     ;��।�� ⥪�箣� �����
		and dl,0fh		      ;���㢠��� ������� ��ࠤ�
		jmp comp	                 ;����i� �� ��஡�� �������  ��ࠤ�  ᨬ����
             exit:mov dl,' '	                 ;��������� ᨬ����
		int 21h 
                     endm
exe_mts macro                    ;�������� �����
        local   lop,nos
             mov cx,24                 ;����來?���
      lop: mov dh,[di]               ;�����訩 ���� ��������
             rcr dh,1                      ;��� �࠯�� ��७�ᥭ�� CF
             rcr word ptr [di]+1,1 ;�?��楢�� ���      
             rcr byte ptr [di],1       ;�������� �ࠢ�
            jnc nos                       ;�࠯�� CF=0
            add [si],ax                 ;�㬠 �ਢ�⭨�
            adc [si]+2,dl              ;�����i�
    nos: rcr word ptr [si]+1,1  ;��� �ࠢ� �㬨       
            rcr byte ptr [si],1       ;�ਢ�⭨� �����?�
            loop lop                     ;��४�?� �?稫쭨�� � ����?�
            pushf                         ;��� �筮��?
           endm
      .data                                                                  ;������� �����
        mes1 db 'Exception Overflow',0ah,0dh,'$'
        mes2 db 'Exception Underflow',0ah,0dh,'$'
        mes3 db '                           Exception Absents',0ah,0dh,'$'
        mes4 db '                       Multiplicand:','$'
        mes5 db '                       Multiplier  :','$'
        mes6 db '                       Product     :','$'
        mes7 db '                 EMULATE MULTIPLICATION CPU  PENTIUM START',0ah,0dh,'$'
        mes8 db '                 Input multiplicand:','$'
        mes9 db '                 Input multiplier:  ','$' 
        mes10 db '                EMULATE MULTIPLICATION CPU  PENTIUM STOP',0ah,0dh,'$'
        opr_x db 4 dup (?)          ;�����㢠��� ���'��? 
        opr_y db 4 dup (?)          ;�?� ���࠭��
           .code                            ;������� ����
   main:mov ax,@data
             mov ds,ax
             mov bp,4                          ;�?��?��� ���?���?�
             out_str mes7                     ;���?�������� 7
     nex: cursor
             out_str mes8
             inp_dat opr_x                     ;�������� X
             out_str mes4                        ;����饭�� 4
             scr_ddw opr_x                     ;��������� ���� X
             out_str mes9
             inp_dat opr_y                      ;��������Y
             out_str mes5                        ;���?�������� 4
             scr_ddw opr_y                      
            out_str mes6                         ;���?�������� 6
             zer_tst opr_x                         ;����㢠��� X=0
             jz xex                                     ;����⮪ Z:=0
             zer_tst opr_y                          ;����㢠���  Y=0
             jnz exc                                    ;����⮪ Z:=0
             zer_loa                                    ;�?� X:=0
       xex:jmp eex                                  ;����⮪ Z:=0
     exc:lea si,opr_x                               ;?�?�?��?���?� 
           lea di,opr_y                               ;����
           mov bh,[si]+3                           ;���㢠��� 
           xor bh,[di]+3                             ;����� ������ Sz
           mov bl,[si]+2                           ;���᫥���
           add bl,bl                                   ;� �����⠦����
           mov bl,[si]+3                           ; �ࠪ���⨪�
           rcl bl,1                                      ;(bl)=Ex
           mov al,[di]+2                             ;���᫥���
           add al,al                                      ;� �����⠦����
           mov al,[di]+3                              ;�ࠪ���⨪�
           rcl al,1                                         ;(al)=Ey
           add bl,al                                ; ��������� Ez:=Ex+Ey
           jnc min                                 ; � ��讪  ��?饭�� 127
           add bl,129                             ;Ez:=Ez+256 -127 = Ez +129
           jnc sig                                   ;����?� �� ���᫥��� �����
     ovr:out_str mes1                          ; ���?�������� Overflow
           jmp xxx                                 ; � �?���� 横��
     min:sub bl,127                          ;����祭�� ����
           jnc sig                                    ;����?� �� ���᫥��� �����
    und:out_str mes2                             ; ���?�������� Overflow
           jmp xxx                                       ; � �?���� 横��
             sig:or byte ptr [si]+2,80h     ;���������� 
                   or byte ptr [di]+2,80h     ; ��客���� �?�?�
                   mov ax,[si]
                   mov dl,[si]+2            ;�����⠦���� (dl:ax)=Fx
                   xor [si],ax
                   xor [si]+2,dl              ;���� ����� Fz:=0
                   exe_mts                    ; �������� �����
                   cmp bl,255
                  jz  ovr                         ;� ��९�������
            mov al,[si]+2                   ;����㢠��� �� ����
            or al,al                              ; Fz(0) =1
            js nsh                                ;Fz(0) ���?���� ������? 
            popf                                  ;�������� ��?��� ������
            rcl word ptr [si],1              ;��ଠ�?���?� �?��
            rcl byte ptr [si]+2,1           ;����� ������
             cmp bl,0
             jz  und                                ;��ࠪ���⨪� � ���? ��⨯�९�������
            jmp eee
      nsh:popf                                    ;��� �?୮� ஡�� �⥪�
             inc bl                                   ;��ଠ�?���?� �?��
           cmp bl,255
           jz ovr                                     ;� ��९�������
eee:     and bh,80h                         ; ������?� ����� Sz
            mov [si]+3,bl                      ; ���������  �ࠪ���⨪� Ez,
            shl byte ptr [si]+2,1   ;�����
            add bh,bh                   ;� �����?�?� 
            rcr word ptr [si]+2,1  ;�ଠ�
      eex:scr_ddw opr_x            ;���������  ����⮪�  Z      
       out_str mes3                    ;���?�������� 3
     xxx:dec bp                          ;��४�?� �?稫쭨��
            je nxx                           ;���?��� ���?�稫���
            jmp nex                        ;�� ����㯭�� ���?���
    nxx: cursor            
            out_str mes10               ;���?��������10
             mov ax,4c00h
            int 21h
        end main
