;Presentation Subtraction testing data SINGLE
.586p
masm             
model use16  small
.stack 256
.data
;Область визнацення       Minimum  [1.1754943E-38 .. 3.4028234E+38]  Maximum 
;Дискрети визнацення    Underflow [-0.0000001E-38] [0.0000002E+38]  Overflow
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
  tsz  macro p             ; Тестування змінної на нуль за адресою Р
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
              rst  macro o               ; Поновлення в пам’яті прихованого біту  
              shl word ptr [o] +2,1;
              stc                              ;
              rcr byte ptr [o]+2,1  ;
              endm              
exch  macro        ; Обмін змінними в пам’яті комп’ютера
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
       scr_sym macro        ;Видача ASCII Hexmal символу  
        local fri,sym
        cmp dl,0ah          ;Порівняння з десяткою
        jb fri                   ;Менше десятки
        or dl,40h             ;Формування символу 
        sub dl,09h           ;велікої літері 
        jmp sym              ;Перехід на видачу
   fri:or dl,30h             ;Формування символу 
 sym:int 21h               ;Видача символу на екран   
        endm  
         ;Видача байту ASCII Hexmal символів
scr_byte macro    
         mov dl,[bx]        ;Завантаження з памяті 
         push cx             ;Збереження в стеку
         mov cl,4            ;Розрядність тетради
         shr dl,cl             ; Pced управо на чотири
         pop cx               ;Поновлення регыстру
         scr_sym            ;Видача старшого символу байту
         mov dl,[bx]       ;Завантаження того ж числа з памяті 
         and dl,0fh         ;Знищення старшоъ тетради
         scr_sym             ;Видача молодшого символу байту
         mov dl,20h        ;Видача  символу 
         int 21h               ;пропуск
         endm        
      xyz macro             ;Видача байтів ASCII символів змінної   
             local next
    next:scr_byte         ;Видача байту ASCII символів
             dec bx            ;Зменшення адреси
             loop next        ;Зменшення лічильника та перехід
             mov dl,'h'       ;Видача
             int 21h            ;символу h
             endm             
    curs macro                ;Переведення стрічки екрану
            push ax
            mov ah,2
            mov dl,0ah         ;Перехід на наступну     
            int 21h               ;стрічку
            mov dl,0dh        ;Перехід на початок 
            int 21h               ;стрічки
            pop ax
            endm            
   mess macro adr                ;Видача
           push ax                      ;текстового
           lea dx,adr                  ;повідомлення
           mov ah,9                    ;на екран
           int 21h                       ;монітору
           pop ax                        ;компютера
           endm             
       scr macro m,t        ;Ініціалізація   
             push cx
             curs                  ;Перехід на нову та впочаток стрічки
             mess m             ;Відповідне повідомлення
             mov cx,4          ;Ініціалізація лічильника та
             lea bx,t+3        ; покажчика адреси
             xyz                    ;Видача на екран змінної Single    
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
             NEG  DL ; Дія    DL:= not (DL) +1
             EXCH     ; Обмін числами  (Х)   (Y)
             ENDM  
       PCOM  MACRO 
                     MOV  DL, [DI]  + 3 ; Характеристика числа X
                     SUB  DL, [SI]  + 3     ; Різниця порядків 
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
                    
 M_SUB PROC NEAR                   ; Початковий оператор процедури
               PCOM                               ; Порівняння порядків
               JZ EQZ                              ; Порядки чисел рівні
               JNC ABU                           ; Додатна різність та обмін
               NXCH                                 ; Різниця порядків була від’ємною
               XOR AH,80H                      ; Знак другого операнду 
     ABU:EEXP                                    ;Вирівнювання порядків
              JNZ CON                              ; Різниця порядків більше 23
     EEX:SUB_M                                  ; Віднімання мантис
     TTT:TEST BYTE PTR [DI] +2, 80H; Перевірка старшого біту
             JS CON                                 ;Мантиса результату нормалізована
             CLC                                       ; Нормалізація
             LROT                                     ; уліво
             DEC BYTE PTR [DI] +3      ; мантиси
             JNZ TTT                                ; результату
             JZ UND                                   ; Виключення екстремуму 
    EQZ:MCOM                                    ;Порівняння мантис
             JNC TTZ                                ;Мантиса MХ більша або рівна MY
              EXCH                                      ; Мантиса MХ менша за  MY
              XOR AH,80H                         ; Інверсія знаку
             JMP EEX                                 ; Но обчислення мантис
    TTZ:JNZ EEX                                  ; Мантиса MХ більша  MY
             LADZ                                        ; Мантиса MХ рівна MY
            OR AH,AH                                ; Знак різниці
            JNS CON                                  ; додатний
            XOR AH, 80H                          ; Скид знаку результату
  CON:RET                                          ; Вихід з процедури                                   
            ENDP                                       ; Кінцевий оператор процедури

M_ADD PROC NEAR                           ; Початковий оператор процедури
               PCOM                                      ; Порівняння порядків
               JAE CAE                                 ; Число X більше або дорівнює Y
               NXCH                                      ; Формування додатної різниці та обмін
      EXP:EEXP                                       ;Вирівнювання порядків
               JZ EXE                                    ; Різниця порядків була меншою 24
       STP1:RET                                          ; Вихід з процедури
       CAE:JNZ EXP                                 ;Число X більше за число Y
       EXE:ADD_M                                  ; Додавання вирівняних мантис
                JNC STP1                                 ; Переповнення сітки відсутнє
                XCHG SI,DI                           ; Виконання
                RROT                                      ; нормалізації 
                XCHG SI,DI                           ; управо
                INC BYTE PTR [DI]+3          ; результату
                CMP BYTE PTR [DI]+3, 255; Для виключення переповнення
                JZ OVR                                   ; Є виключення екстремуму 
               JMP STP1                                 ; Виключення екстремуму  відсутнє
               ENDP                                      ; Кінцевий оператор процедури             
 main:                 ;Основная программа
mov ax,@data    ;Будова сегменту
mov ds,ax           ;даних
mov ah,2             ;Функція ДОС
lea di,x
lea si,y
mov cx,4 
mess ms            ;Повідомлення про початок тестування
scr m1,x           ;Видача на екран змінної X  
scr m2,y           ;Видача на екран змінної Y   
curs   
mess mc
scr m3,z           ;Видача на екран змінної Z  
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
 mov ah,2            ;Функція ДОС
       mess mr
     scr m3,x           ;Видача на екран змінної Z  
       curs 
       jmp tpr
ovr:  curs 
 mess mo              ;Повідомлення про переповнення
       jmp stp1
und: curs 
  mess mu             ;Повідомлення про антипереповнення
  jmp con
tpr: curs 
        mess me             ;Повідомлення про закінчення тестування
mov eax,x
mov ax,4c00h   ;Повернення 
int 21h              ;в ДОС
end main