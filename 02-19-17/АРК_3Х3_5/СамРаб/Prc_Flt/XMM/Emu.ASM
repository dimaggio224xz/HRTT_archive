;�������� �������� ������ � ������ SPFP      
.model small
.586p
.stack 256
out_str macro str         ;��������� ���������� �����������    
    mov dx,offset str
        mov ah,9             ;������� �����������
        int 21h
        endm
scr_ddw macro adr          ;��������� ����� SPFP
        local nxt
        lea si,adr                ;������ �����
        mov cx,4                ;����� �����
    nxt:scr_byt                 ;��������� ����� �����
        dec si                    ;��������� ����� �����
        loop nxt                 ;������� �� ����������
        cursor                     ;������� �������
        endm
scr_byt macro               ;��������� ����� �����
        local w_0,w_1,tst
        mov bl,128            ;����� ����������
        mov ah,2               ;������� �����������
    tst:test [si]+3,bl       ;���������� �����
        jz w_0                 ;��� ������� ����
        mov dl,'1'             ;���������� �������
        jmp w_1               ;������� �� �����
    w_0:mov dl,'0'        ;���������� ����
    w_1:int 21h             ;����� �� ����� ���
        shr bl,1               ;���� ������ �����
        jne tst                 ;��������� ����������
        mov dl,' '              ;�����
        int 21h                 ;��������
        endm
zer_tst macro opr             ;���������� ����    
        local nnx,stp
        lea si,opr                ;������ ����� �����
        mov cx,4                 ;�� ��������
    nnx:or byte ptr [si],0   ;���������� ������� ZF
        jne stp                    ; ������ ZF �� ����
        inc si                      ; ������ ���������� �����
        loop nnx                 ;������ �� ���������� 
        xor si,si                 ; ��������� ZF � �������
    stp:endm
zer_loa macro                   ;������������ ����
        local mnx
        lea bx,opr_x               ;������ ����� �����
        mov cx,4                     ;�� ��������
    mnx:mov byte ptr [bx],0  ;������������ ����
        inc bx                          ; ������ ���������� �����
        loop mnx                     ;������ �� ���������� 
        endm
inp_dat macro ope                ;�������� � ���������
        local lpp,rpt,s30,cor,sto
        mov ah,7                       ;������� �����������
        lea bx,ope                     ;������ �����
        mov dh,4                       ;ʳ������ �����
    lpp:mov dl,2                     ;������ �����������
    rpt:int 21h                         ;�������� � ���������
        cmp al,30h                    ;�������� ������
        jb rpt                             ;�� � ��������
        cmp al,3ah                    ;����� ���������� �������
        jb s30                            ;������ � �����
        cmp al,61h                    ;����� ���������� �������
        jb rpt                             ;������ �� � ��������
        cmp al,67h                   ;����� ���������� �������
        jnb rpt                          ;������ �� � ��������
        sym                               ;��������� ������� ���� �����
        sub al,57h                    ;�������� ��������� ASCII
        jmp cor                       ;������� �� �������� �������
    s30:sym                       ;��������� ������� �����
        sub al,30h                ;�������� ��������� ASCII
    cor:dec dl                    ;��������� ����� �������
        je sto                       ;������� �� ���������� ��������
        mov cl,4                  ;����� �����
        shl al,cl                   ;��������� � ������ �������
        mov [bx]+3,al         ;�� ����������
        jmp rpt                   ;������� �� �������� ������� �������
  sto:add [bx]+3,al         ;���������� ������� �������
        push ax                   ;��������� 
        push dx                  ;����������
        mov ah,2                ;������� �����������
        mov dl,' '                ; ������� ���������
        int 21h                    ;�������
        pop dx                    ;���������� 
        pop ax                    ;�����
        dec bx                    ;��������� ������
        dec dh                    ;�� ���������
        jne lpp                   ;������ �� �������� ����
        cursor                    ;������� �������
        endm
 cursor macro   ;���������� �������
        mov ah,2   ;������� �����������
        mov dl,0ah
        int 21h
        mov dl,0dh
        int 21h
        endm
   sym macro         ;��������� �������
       push ax
       push dx
       mov ah,2     ;������� �����������
       mov dl,al
       int 21h
       pop dx
       pop ax
       endm
        .data                          ;������� �����
        mes1 db 'Exception Overflow',0ah,0dh,'$'
        mes2 db 'Exception Underflow',0ah,0dh,'$'
        mes3 db '                               Exception Absents',0ah,0dh,'$'
        mes4 db '                  Multiplicand:','$'
        mes5 db '                  Multiplier:  ','$'
        mes6 db '                  Product:     ','$'
        mes7 db '                  EMULATE MULTIPLICATION TECHNOLOGI XMM  PENTIUM',0ah,0dh,'$'
        mes8 db '                  Input multiplicand:','$'
        mes9 db '                  Input multiplier:  ','$' 
       mes10 db '                STOP TESTING  EMULATE MULTIPLICATION  XMM   PENTIUM',0ah,0dh,0ah,'$'
        opr_x db 4 dup (?)  ;����������� ����� �� ��������                     
        opr_y db 4 dup (?)
       .code                        ;���������� �������     
        main:mov ax,@data
             mov ds,ax
             out_str mes7      ;��������� ����������� 7
             mov bp,4            ;ʳ������ �������
  next:   out_str mes8
             inp_dat opr_x      ;��������X
             out_str mes9
             inp_dat opr_y     ;�������� Y
             out_str mes4       ;��������� �����������  4
             scr_ddw opr_x    ;��������� X
             out_str mes5        ;��������� �����������  5
             scr_ddw opr_y    ;���������Y
             out_str mes6        ;��������� ����������� 6
             zer_tst opr_x      ;���������� X=0
             jz xex                  ;�� ���������� �������  Z=0
             zer_tst opr_y       ;����������  Y=0
             jnz exc                 ;�� ��������
             zer_loa                 ;������������ ���� X:=0                     
      xex:jmp eex               ;�� ���������� ������� Z=0
       exc:lea si,opr_x       ;������������ 
           lea di,opr_y         ;������
           mov bh,[si]+3      ;���������� �����
           xor bh,[di]+3        ;������� Sing Sz
           mov bl,[si]+2          ;����������  
           add bl,bl                ;�������������� Ex
           mov bl,[si]+3          ;� ����������
           rcl bl,1                   ;� ������  (bl)=Ex
           mov al,[di]+2         ;������� 
           add al,al                 ;���������� Ey
           pushf                     ;���������� ����� ��������
           mov al,[di]+3        ; ����������
           rcl al,1                  ; ���������� (al)=Ey
           add bl,al                ; ĳ� Ez:=Ex+Ey
           jnc min                  ;����� ������ 127
           add bl,129             ;�� ��������� -(256 -127)= -129
           jnc sig                    ;������ �� ���������� Hidden bit
           out_str mes1            ;� ������������
           jmp xxx                    ;�� ���� �� �����
       min:sub bl,127            ;�������� ��������
           jnc sig                      ;������ �� ���������� Hidden bit
           out_str mes2            ;� ����������������
           jmp xxx                     ;�� ���� �� �����
     sig:or byte ptr [si]+2,80h ;����������
          or byte ptr [di]+2,80h  ;���������� ���
            mov ax,[si]                 ;������������ 3-� ���� 
            mov dl,[si]+2            ; ������� ��������� (dl:ax)=Fx
             xor [si],ax                  ;���� � ���� 
             xor [si]+2,dl              ; ������� ����������Fz:=0
            mov cx,24                  ; ˳������� ������� ��������
       lop:mov dh,[di]               ; �������� ��
            rcr dh,1                      ; �������� � CF
            rcr byte ptr [di]+2,1   ; ʳ�������
            rcr byte ptr [di]+1,1   ; ���� ������
            rcr byte ptr [di],1       ; �������� 
            jnc nos                       ; ������ CF �� ����
            add [si],ax                 ; ���� ����������
            adc [si]+2,dl              ; �������
      nos:rcr byte ptr [si]+2,1   ;���� ������ 
            rcr byte ptr [si]+1,1    ; ���������� 
            rcr byte ptr [si],1        ; �������
            loop lop                     ; ������ �� ����������
             pushf                        ; ��� ������� � CF ���������� ��
            mov al,[si]+2            ;���������� �������� ���           
            or al,al                      ; ������� �������
            js nsh                         ; ������� �� �������
            popf                           ; ���������� ����������� ���
            rcl word ptr [si],1      ;���� ����
            rcl byte ptr [si]+2,1   ; ������� ������� 
            jmp anl                      ;������� �� ���������� 
      nsh:inc bl                        ; ���������� ����� ������� - �������
     anl:or bl,bl                      ; ���������� �� ���� Ez
           jnz ppp                       ; �������������� �� ����
        out_str mes2                  ; � ����������������
            jmp xxx                      ; �� ���� �� ��������
     ppp:cmp bl,0ffh               ; ���������� �� ��������
            jnz rrr                       ; �������������� �� �����������
           out_str mes1               ;� ������������
           jmp xxx                       ; �� ���� �� ��������
         rrr: shl byte ptr [si]+2,1; ���������� ����������� ���
            shr bl,1                       ; ���� ��������������
            rcr byte ptr [si]+2,1   ; � ����� ��������� �� ���
            and bh,80h                 ; �������� ����� �������
            or bl,bh                      ; �� ����� ����� �������
            mov [si]+3,bl             ; ������������ � ������
            shl byte ptr [di]+2,1   ; ����������
            popf                           ; �����
            rcr byte ptr [di]+2,1   ; ��������
      eex:scr_ddw opr_x          ;��������� ������� Z
         out_str mes3                  ;��������� ����������� 3 
       xxx:dec bp                      ;��������� ��������� ������� 
              jnz next                    ;������� �� �������� �������� 
            out_str mes10            ;��������� ����������� 10
             mov ax,4c00h           ;���������� � ��� 
            int 21h
             end main

