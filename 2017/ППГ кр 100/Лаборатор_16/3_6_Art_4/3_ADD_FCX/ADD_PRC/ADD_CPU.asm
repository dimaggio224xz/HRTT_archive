MASM                          ;Presentation  Addition SINGLE type
MODEL USE16  SMALL
.STACK 256
.DATA
;������� ����������     Minimum    [1.1754943E-38  ..  3.4028234E+38]   Maximum
;�������� ����������    Underflow [-0.0000001E-38]  [+0.0000002E+38]  Overflow 
X  DD  -3.1754941e-0
   DD   3.1754941e+0
   DD  -2.4028235e+8
  DD - 2.4028235e-8
Y DD  2.1754941e-0
 DD  -2.1754941e-0
   DD  2.4028235e+8
  DD   2.4028235e-8
MS DB '              Presentation ADDition Single of CPU PENTIUM start',13,10,' $ '
ME DB '              Presentation ADDition Single of CPU PENTIUM stop',13,10,'$ '
M1 DB '                      Operand X = $'
M2 DB '                      Operand Y = $'
M3 DB '                      Result  Z = $'
MO DB '                Exception extremum maximum - Overflow!','$'
MU DB '                Exception extremum minimum - Underflow!','$'
.CODE
  TSZ  MACRO P             ; ���������� ����� �� ���� �� ������� �
       LOCAL N1, EXT
       PUSH P
       PUSH CX
       XOR AL,AL
 N1:OR AL,[P]
       JNZ  EXT
       INC  P
       LOOP N1
       OR   AL, AL
 EXT:POP  CX
        POP  P
        ENDM   
    RST  MACRO O               ; ���������� � ����� ����������� ���  
              SHL WORD PTR [O] +2,1
               STC                              
               RCR BYTE PTR [O]+2,1  
               ENDM              
    EXCH  MACRO        ; ���� ������� � ����� ���������
        LOCAL N2
        PUSH DI
        PUSH SI
        PUSH CX
 N2:MOV AL, [SI]
        XCHG AL,[DI]    
        MOV [SI],AL
        INC SI
        INC DI
        LOOP N2
        POP CX
        POP SI
        POP DI
        ENDM            
       scr_sym macro        ;������ ASCII Hexmal �������  
        local fri,sym
        cmp dl,0ah          ;��������� � ��������
        jb fri                   ;����� �������
        or dl,40h             ;���������� ������� 
        sub dl,09h           ;����� ���� 
        jmp sym              ;������� �� ������
   fri:or dl,30h             ;���������� ������� 
 sym:int 21h               ;������ ������� �� �����   
        endm  
scr_byte macro             ;������ ����� ASCII Hexmal �������
         mov dl,[bx]        ;������������ � ����� 
         push cx             ;���������� � �����
         mov cl,4            ;���������� �������
         shr dl,cl             ; Pced ������ �� ������
         pop cx               ;���������� ��������
         scr_sym            ;������ �������� ������� �����
         mov dl,[bx]       ;������������ ���� � ����� � ����� 
         and dl,0fh         ;�������� ������� �������
         scr_sym             ;������ ��������� ������� �����
         mov dl,20h        ;������  ������� 
         int 21h               ;�������
         endm
         
      xyz macro             ;������ ����� ASCII ������� �����   
             local next
    next:scr_byte       ;������ ����� ASCII �������
             dec bx            ;��������� ������
             loop next        ;��������� ��������� �� �������
             mov dl,'h'       ;������
             int 21h            ;������� h
             endm             
    curs macro                ;����������� ������ ������
            push ax
            mov ah,2
            mov dl,0ah         ;������� �� ��������     
            int 21h               ;������
            mov dl,0dh        ;������� �� ������� 
            int 21h               ;������
            pop ax
            endm            
   mess macro adr                ;������
           push ax                      ;����������
           lea dx,adr                  ;�����������
           mov ah,9                    ;�� �����
           int 21h                       ;�������
           pop ax                        ;���������
           endm             
       scr macro m,t        ;�����������   
             push cx
             curs                  ;������� �� ���� �� �������� ������
             mess m             ;³������� �����������
             mov cx,4          ;����������� ��������� ��
             mov bx,t          ; ��������� ������
            add bx,3
             xyz                    ;������ �� ����� ����� Single    
             pop cx 
            endm
        RROT  MACRO           ;���� ������ �������
         LOCAL N3
         PUSH SI
         PUSH CX
         DEC CX                   
  N3: RCR BYTE PTR [SI]+2,1            
          DEC SI                
          LOOP N3     
           POP CX
           POP SI
           ENDM    
NXCH  MACRO ;���� ����� �� ����
             NEG  DL ; ĳ�    DL:= not (DL) +1
             EXCH     ; ���� �������  (�)  � (Y)
             ENDM  
       PCOM  MACRO    ;��������� �������
                     MOV  DL, [DI]  + 3 ; �������������� ����� X
                     SUB  DL, [SI]  + 3     ; г����� ������� 
                     ENDM
         EEXP  MACRO             ;����������� �������
          LOCAL N4, STT
          CMP DL, 24       ;��� ���������� ��� 
           JAE STT            ;�������  �������� �� ������ ����
     N4:CLC                   ;������� ����
           RROT                ;������ ��  
           DEC DL            ; �������� ������  
           JNE N4             ; �������
   STT: ENDM         
ADD_M  MACRO     ;��������� ������
            LOCAL N5
            PUSH DI
            PUSH SI
            PUSH CX
            DEC CX
            CLC
   N5: MOV AL, [SI]            
           ADC  [DI],AL
           INC  SI
           INC  DI
           LOOP N5
           POP CX
           POP SI
           POP DI
           ENDM        
SUB_M  MACRO         ;³������� ������
 LOCAL NX3 
            PUSH DI
            PUSH SI
            PUSH CX
            DEC CX
            CLC
 NX3: MOV AL, [SI]            
           SBB  [DI],AL
           INC  SI
           INC  DI
           LOOP NX3
           POP CX
           POP SI
           POP DI
           ENDM                
MCOM  MACRO      ;��������� ������
LOCAL NX1, EX1 
            PUSH DI
            PUSH SI
            PUSH CX
            DEC CX
 NX1: MOV AL, [DI]+2           
           CMP  AL,[SI]+2
           JC EX1                  ;MX < MY
           JNZ EX1                ;MX > MY
           DEC  SI
           DEC  DI
           LOOP NX1
           OR CL, CH        ;���������� ������ ZF:=1
  EX1:POP CX
           POP SI
           POP DI
           ENDM     
LADZ  MACRO            ;������������ ����
          LOCAL NX2 
          PUSH DI
          PUSH CX
  NX2:MOV BYTE PTR [DI], 0 
           INC DI        
           LOOP NX2      
           POP CX
           POP DI
           ENDM         
LROT MACRO                ;���� ���� �������
           LOCAL NX4 
           PUSH DI
           PUSH CX
           DEC CX
 NX4: RCL BYTE PTR [DI],1            
           INC DI        
           LOOP NX4      
           POP CX
           POP DI
           ENDM                              
 M_SUB PROC NEAR                   ; ���������� �������� ���������
               PCOM                               ; ��������� �������
               JZ EQZ                              ; ������� ����� ���
               JNC ABU                           ; ������� ������ �� ����
               NXCH                                 ; г����� ������� ���� �䒺����
               XOR AH,80H                      ; ���� ������� �������� 
     ABU:EEXP                                    ;����������� �������
              JNZ CON                              ; г����� ������� ����� 23
     EEX:SUB_M                                  ; ³������� ������
     TTT:TEST BYTE PTR [DI] +2, 80H; �������� �������� ���
             JS CON                             ;������� ���������� ������������
             CLC                                       ; �����������
             LROT                                    ; ����
             DEC BYTE PTR [DI] +3     ; �������
             JNZ TTT                                ; ����������
             JNZ EQZ
            JMP UND                                  ; ���������� ���������� 
    EQZ:MCOM                                    ;��������� ������
             JNC TTZ                                ;������� M� ����� ��� ���� MY
              EXCH                                      ; ������� M� ����� ��  MY
              XOR AH,80H                         ; ������� �����
             JMP EEX                                 ; �� ���������� ������
    TTZ:JNZ EEX                                  ; ������� M� �����  MY
             LADZ                                        ; ������� M� ���� MY
            OR AH,AH                                ; ���� ������
            JNS CON                                  ; ��������
            XOR AH, 80H                          ; ���� ����� ����������
  CON:RET                                          ; ����� � ���������                                   
            ENDP                                       ; ʳ������ �������� ���������
M_ADD PROC NEAR                           ; ���������� �������� ���������
               PCOM                                      ; ��������� �������
               JAE CAE                              ; ����� X ����� ��� ������� Y
               NXCH                               ; ���������� ������� ������ �� ����
      EXP:EEXP                                       ;����������� �������
               JZ EXE                                    ; г����� ������� ���� ������ 24
       STP1:RET                                          ; ����� � ���������
       CAE:JNZ EXP                                 ;����� X ����� �� ����� Y
       EXE:ADD_M                                  ; ��������� ��������� ������
                JNC STP1                                 ; ������������ ���� ������
                XCHG SI,DI                           ; ���������
                RROT                                      ; ������������� 
                XCHG SI,DI                           ; ������
                INC BYTE PTR [DI]+3          ; ����������
                CMP BYTE PTR [DI]+3, 255; ��� ���������� ������������
                JNZ STP1                               ; ���������� ����������  ������
               JMP OVR                                  ; � ���������� ����������            
               ENDP                                      ; ʳ������ �������� ���������            
 main:                 ;�������� ���������
mov ax,@data    ;������ ��������
mov ds,ax           ;�����
mov ah,2             ;������� ���
lea di,x               ;����������� ���������
lea si,y               ;������ ��������
mov cx,4            ;�� ��������� �����
curs   
mess ms            ;����������� ��� ������� ����������
mov bp, 4          ;�i���i��� ������� �������� 
              nxt:  push si    ;����������
                      push di    ;���������
                      push cx    ;�� ���������
scr m1,di         ;������ �� ����� ����� X  
scr m2,si         ;������ �� ����� ����� Y   
       tsz si
       jz sstp       ;�������  Y =  0
       tsz di
       jnz exc      ;�������  � ?  0
       exch
       jmp  sstp            ;�������  � =  0
 exc:mov ah, [di]+3  ;��� ����������
        mov al, [si]+3    ;����� �����
        rst  di                 ;���������� ����������� ���
         rst  si                ;�� ��������� �������������
        xor al, ah          ;���������� �����
        js fsb                 ;����� �������� ���
        call m_add        ;���������� ��� ��������� ������
        jmp pstp
  fsb:call m_sub        ;���������� ��� ����� ������
pstp:shl byte ptr  [di]+2,1 ;���������� ����������� ���
       clc                                 ;��� ����� ����������
        rcr word ptr  [di]+2,1;����������� �������������� 
       and ah, 80h                  ;�������� �����
        or [di]+3, ah                ;����� �����
sstp: mov ah,2            ;������� ���
        scr m3,di           ;������ �� ����� ���������� 
       curs 
       jmp tpr              ;��������� �� ����������� 
ovr:  curs  
       mess mo              ;����������� ��� ������������
       ret
       jmp tpr
und: curs 
        mess mu             ;����������� ��� ����������������
        ret
tpr: pop cx            ;���������� 
       pop di             ;��������� ��
       pop si              ;���������
      add di,4            ;��������� ������
      add si,4             ; ��������
      dec bp                     ;�������� ��������� ���������� �����
            je ntx1                ;���� �������� ������ ����
            jmp nxt             ;��������� �� ��������� ������ �����
    ntx1: curs
        mess me            ;����������� ��� ��������� ����������
        mov ax,4c00h   ;���������� 
       int 21h                  ;� ���
       end main
