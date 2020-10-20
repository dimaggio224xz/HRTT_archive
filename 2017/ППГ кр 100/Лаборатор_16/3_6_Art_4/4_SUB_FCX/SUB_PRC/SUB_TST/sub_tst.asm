;Presentation Subtraction testing data SINGLE
.586p
masm             
model use16  small
.stack 256
.data
;������� ����������       Minimum  [1.1754943E-38 .. 3.4028234E+38]  Maximum 
;�������� ����������    Underflow [-0.0000001E-38] [0.0000002E+38]  Overflow
X  DD  -.30071399e+23; 
Y  DD   -.20071399e+23
Z  DD  -.10000000e+23
ms db '      Presentation Subtraction Single of CPU start',13,10,' $ '
me db '      Presentation Subtraction Single of CPU stop',13,10,'$ '
M1 DB '             Operand X = $'
M2 DB '             Operand Y = $'
M3 DB '             Result  Z = $'
mo db '        Exception extremum maximum-Overflow!',13,10,'$'
mu db '        Exception extremum minimum-Underflow!',13,10,'$'
mr db '             Testing result after Subtraction','$'
mc db '             Control result of Subtraction','$'
.code
  tsz  macro p             ; ���������� ����� �� ���� �� ������� �
       local n1, ext
       push p
       push cx
       xor al,al
 n1:or al,[p]
       jnz  ext
       inc  p
       loop n1
       or   al, al
 ext:pop  cx
        pop  p
        endm       
              rst  macro o               ; ���������� � ����� ����������� ���  
              shl word ptr [o] +2,1;
              stc                              ;
              rcr byte ptr [o]+2,1  ;
              endm              
exch  macro        ; ���� ������� � ����� ���������
        local n2
        push di
        push si
        push cx
 n2:mov al, [si]
        xchg al,[di]    
        mov [si],al
        inc si
        inc di
        loop n2
        pop cx
        pop si
        pop di
        endm            
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
         ;������ ����� ASCII Hexmal �������
scr_byte macro    
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
    next:scr_byte         ;������ ����� ASCII �������
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
             lea bx,t+3        ; ��������� ������
             xyz                    ;������ �� ����� ����� Single    
             pop cx 
            endm      
rrot  macro 
         local n3
         push si
         push cx
         dec cx                   
   n3: rcr byte ptr [si]+2,1            
          dec si                
          loop n3     
           pop cx
           pop si
           endm      
    NXCH  MACRO 
             NEG  DL ; ĳ�    DL:= not (DL) +1
             EXCH     ; ���� �������  (�)   (Y)
             ENDM  
       PCOM  MACRO 
                     MOV  DL, [DI]  + 3 ; �������������� ����� X
                     SUB  DL, [SI]  + 3     ; г����� ������� 
                     ENDM
eexp  macro 
         local n4, stt
          cmp dl, 24 
           jae stt       
    n4:clc              
           rrot            
           dec dl         
            jne n4     
      stt: endm           
add_m  macro 
            local n5
            push di
            push si
            push cx
            dec cx
            clc
   n5: mov al, [si]            
           adc  [di],al
           inc  si
           inc  di
           loop n5
           pop cx
           pop si
           pop di
           endm              
MCOM  MACRO 
LOCAL NX1, EX1 
            PUSH DI
            PUSH SI
            PUSH CX
            DEC CX
 NX1: MOV AL, [DI]+2           
           CMP  AL,[SI]+2
           JC EX1
           JNZ EX1
           DEC  SI
           DEC  DI
           LOOP NX1
           OR CL, CH
  EX1:POP CX
           POP SI
           POP DI
           ENDM   
LADZ  MACRO 
          LOCAL NX2 
          PUSH DI
          PUSH CX
  NX2:MOV BYTE PTR [DI], 0 
           INC DI        
           LOOP NX2      
           POP CX
           POP DI
           ENDM         
SUB_M  MACRO 
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
LROT MACRO 
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
             JS CON                                 ;������� ���������� ������������
             CLC                                       ; �����������
             LROT                                     ; ����
             DEC BYTE PTR [DI] +3      ; �������
             JNZ TTT                                ; ����������
             JZ UND                                   ; ���������� ���������� 
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
               JAE CAE                                 ; ����� X ����� ��� ������� Y
               NXCH                                      ; ���������� ������� ������ �� ����
      EXP:EEXP                                       ;����������� �������
               JZ EXE                                    ; г����� ������� ���� ������ 24
       STP1:RET                                          ; ����� � ���������
       CAE:JNZ EXP                                 ;����� X ����� �� ����� Y
       EXE:ADD_M                                  ; ��������� ��������� ������
                JNC STP1                                 ; ������������ ���� ������
                XCHG SI,DI                           ; ���������
                RROT                                      ; ����������� 
                XCHG SI,DI                           ; ������
                INC BYTE PTR [DI]+3          ; ����������
                CMP BYTE PTR [DI]+3, 255; ��� ���������� ������������
                JZ OVR                                   ; � ���������� ���������� 
               JMP STP1                                 ; ���������� ����������  ������
               ENDP                                      ; ʳ������ �������� ���������             
 main:                 ;�������� ���������
mov ax,@data    ;������ ��������
mov ds,ax           ;�����
mov ah,2             ;������� ���
lea di,x
lea si,y
mov cx,4 
mess ms            ;����������� ��� ������� ����������
scr m1,x           ;������ �� ����� ����� X  
scr m2,y           ;������ �� ����� ����� Y   
curs   
mess mc
scr m3,z           ;������ �� ����� ����� Z  
curs   
       tsz si
       jz sstp
       xor byte ptr [si]+3,80h
       tsz di
       jnz exc
       exch
       jmp  sstp
 exc:mov ah, [di]+3
        mov al, [si]+3
        rst  di
        rst  si
        xor al, ah
        js fsb 
        call m_add
        jmp pstp
  fsb:call m_sub
pstp:shl byte ptr  [di]+2,1
       clc
        rcr word ptr  [di]+2,1
       and ah, 80h
        or [di]+3, ah
sstp:curs 
 mov ah,2            ;������� ���
       mess mr
     scr m3,x           ;������ �� ����� ����� Z  
       curs 
       jmp tpr
ovr:  curs 
 mess mo              ;����������� ��� ������������
       jmp stp1
und: curs 
  mess mu             ;����������� ��� ����������������
  jmp con
tpr: curs 
        mess me             ;����������� ��� ��������� ����������
mov eax,x
mov ax,4c00h   ;���������� 
int 21h              ;� ���
end main