;�������� � ����������� ������������        
model small
.stack 256
out_str macro str         ;���� ������
        mov dx,offset str
        mov ah,9             ;������� ���
        int 21h
        endm
 cursor macro            ;���������� �������
        mov ah,2            ;������� ���
        mov dl,0ah        ;�� �������
        int 21h               ;������
        mov dl,0dh        ;�� ����
        int 21h               ;������
        endm
scr_ddw macro adr          ;���� ����� 
        local nxt
        push si                     ;���������
        push cx                    ;����������
        mov si,adr               ;��������� ������
        add si,3                   ;������ �������� �����
        mov cx,4                 ;ʳ������ �����
   nxt:scr_byt                   ;���� �������� �����
         dec si                     ;�� ������� ������
         loop nxt                  ;���������
         pop cx                    ;���������� 
         pop si                     ;�����
         cursor                    ;������� ���� ������
        endm
scr_byt macro               ;���� ����� ����� 
        local w_0,w_1,tst
        push bx                 ;������������
        mov bl,128           ;�������� �����
        mov ah,2               ;������� ���
   tst:test [si],bl             ;���������� �����
        jz w_0                  ;��� ������� ����
        mov dl,'1'             ;��������� �������
        jmp w_1               ;��� ������� �������
w_0:mov dl,'0'             ;��������� ����
w_1:int 21h                  ;����� ��� �� �����
        shr bl,1                 ;���� ����� ������ 
        jne tst                    ;�������, ���� �� ����
        mov dl,' '               ;����� 
        int 21h                   ;��������
       pop bx                    ;����������
       endm
.data
x dd  3.4028234E+37, 3.4028236E+37;���� �����
   dd 1.1754943E-37, 1.1754942E-37 ;���������
y dd 10.0, 10.0                                     ;��������, �� ���������
   dd 0.1, 0.1                                        ;�� ���������� �� ���������
z dd 4 dup (?)                                       ;������ �� �������
stat dw ?                                               ;��� ����� �����
mes0 db '                  EXECUTE MULTIPLICATION COPROCESSOR FPU PENTIUM',0ah,0dh,'$'
mes1 db '                  Multiplicand:','$'
mes2 db '                  Multiplier:  ','$'
mes3 db '                  Product:     ','$'
mes4 db '                               Exception Overflow', 0ah,0dh, '$'
mes5 db '                               Exception Underflow', 0ah,0dh,'$'
mes6 db '                               Exception Absents', 0ah,0dh, '$'
mes7 db '                STOP TESTING  MULTIPLICATION COPROCESSOR  PENTIUM',0ah,0dh,'$'
 .code
       main:mov ax,@data    ;��������6�� 
      mov ds,ax                    ;�������
      out_str mes0                ;����� ��������
       lea bx, x                      ;������������ 
       lea si, y                       ;������� 
       lea di, z                       ;������
        mov cx,4                    ;ʳ������ ��������
  nxt:finit                            ;������������ ������������
       fld dword ptr [bx]       ;������� � �����������
       fmul dword  ptr [si]    ;��������
       fstp dword  ptr[di]      ;���������� � ���'�� �������
        fstsw stat                    ;���������� � ���'�� ����� �����
       out_str mes1               ;���� �������
        scr_ddw bx                ;��������
        out_str mes2              ;���� ��������
        scr_ddw si                 ;��������
        out_str mes3              ;���� �� �����
       scr_ddw di                  ;�������
       Test word ptr stat, 8    ;������������
       jz exe                          ;����
        out_str mes4              ;������������
        jmp et                        ;��������
exe:Test word ptr stat, 16  ;���������������� 
       jz stp                          ;����
       out_str mes5              ;���������������� 
       jmp et                        ;��������
 stp:out_str mes6              ;���������� �������
   et:add bx, 4                   ;����
      add si, 4                     ;������
      add di,4                     ;��������
      dec cx                        ;�� �������
       jz exit                        ;����� �� �����
       jmp nxt                     ;���������� �����
exit:out_str mes7             ;����������
       cursor                       ;��������
       mov ax,4c00h           ;����������
       int 21h                      ;� ���
       end main
