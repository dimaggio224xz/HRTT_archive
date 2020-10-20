MASM                          ;Presentation  Addition SINGLE type
MODEL USE16  SMALL
.STACK 256
.DATA
;Область визнацення     Minimum    [1.1754943E-38  ..  3.4028234E+38]   Maximum
;Дискрети визначення    Underflow [-0.0000001E-38]  [+0.0000002E+38]  Overflow 
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
  TSZ  MACRO P             ; Тестування змінної на нуль за адресою Р
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
    RST  MACRO O               ; Поновлення в пам’яті прихованого біту  
              SHL WORD PTR [O] +2,1
               STC                              
               RCR BYTE PTR [O]+2,1  
               ENDM              
    EXCH  MACRO        ; Обмін змінними в пам’яті комп’ютера
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
scr_byte macro             ;Видача байту ASCII Hexmal символів
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
    next:scr_byte       ;Видача байту ASCII символів
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
             mov bx,t          ; покажчика адреси
            add bx,3
             xyz                    ;Видача на екран змінної Single    
             pop cx 
            endm
        RROT  MACRO           ;Зсув управо мантиси
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
NXCH  MACRO ;Зміна знаку та обмін
             NEG  DL ; Дія    DL:= not (DL) +1
             EXCH     ; Обмін числами  (Х)  « (Y)
             ENDM  
       PCOM  MACRO    ;Порівняння порядків
                     MOV  DL, [DI]  + 3 ; Характеристика числа X
                     SUB  DL, [SI]  + 3     ; Різниця порядків 
                     ENDM
         EEXP  MACRO             ;Вирівнювання порядків
          LOCAL N4, STT
          CMP DL, 24       ;Для визначення межі 
           JAE STT            ;Мантиса  операнду за межами сітки
     N4:CLC                   ;Логічний зсув
           RROT                ;управо на  
           DEC DL            ; величину різниці  
           JNE N4             ; порядків
   STT: ENDM         
ADD_M  MACRO     ;Додавання мантис
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
SUB_M  MACRO         ;Віднімання мантис
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
MCOM  MACRO      ;Порівняння мантис
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
           OR CL, CH        ;Формування ознаки ZF:=1
  EX1:POP CX
           POP SI
           POP DI
           ENDM     
LADZ  MACRO            ;Завантаження ноля
          LOCAL NX2 
          PUSH DI
          PUSH CX
  NX2:MOV BYTE PTR [DI], 0 
           INC DI        
           LOOP NX2      
           POP CX
           POP DI
           ENDM         
LROT MACRO                ;Зсув уліво мантиси
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
             JS CON                             ;Мантиса результату нормалізована
             CLC                                       ; Нормалізація
             LROT                                    ; уліво
             DEC BYTE PTR [DI] +3     ; мантиси
             JNZ TTT                                ; результату
             JNZ EQZ
            JMP UND                                  ; Виключення екстремуму 
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
               JAE CAE                              ; Число X більше або дорівнює Y
               NXCH                               ; Формування додатної різниці та обмін
      EXP:EEXP                                       ;Вирівнювання порядків
               JZ EXE                                    ; Різниця порядків була меншою 24
       STP1:RET                                          ; Вихід з процедури
       CAE:JNZ EXP                                 ;Число X більше за число Y
       EXE:ADD_M                                  ; Додавання вирівняних мантис
                JNC STP1                                 ; Переповнення сітки відсутнє
                XCHG SI,DI                           ; Виконання
                RROT                                      ; денормалізації 
                XCHG SI,DI                           ; управо
                INC BYTE PTR [DI]+3          ; результату
                CMP BYTE PTR [DI]+3, 255; Для виключення переповнення
                JNZ STP1                               ; Виключення екстремуму  відсутнє
               JMP OVR                                  ; Є виключення екстремуму            
               ENDP                                      ; Кінцевий оператор процедури            
 main:                 ;Основная программа
mov ax,@data    ;Будова сегменту
mov ds,ax           ;даних
mov ah,2             ;Функція ДОС
lea di,x               ;Ініціалізація покажчиків
lea si,y               ;адреси операндів
mov cx,4            ;та лічильника циклів
curs   
mess ms            ;Повідомлення про початок тестування
mov bp, 4          ;Кiлькiсть варіантів додавань 
              nxt:  push si    ;Збереження
                      push di    ;покажчиків
                      push cx    ;та лічильника
scr m1,di         ;Видача на екран змінної X  
scr m2,si         ;Видача на екран змінної Y   
       tsz si
       jz sstp       ;Операнд  Y =  0
       tsz di
       jnz exc      ;Операнд  Х ?  0
       exch
       jmp  sstp            ;Операнд  Х =  0
 exc:mov ah, [di]+3  ;Для визначення
        mov al, [si]+3    ;знаків чисел
        rst  di                 ;Поновлення прихованого біту
         rst  si                ;та позування характеристик
        xor al, ah          ;Обчислення знаків
        js fsb                 ;Знаки операндів різні
        call m_add        ;Обчислення при однакових знаках
        jmp pstp
  fsb:call m_sub        ;Обчислення при різних знаках
pstp:shl byte ptr  [di]+2,1 ;Формування прихованого біту
       clc                                 ;Для знаку результату
        rcr word ptr  [di]+2,1;Депозування характеристики 
       and ah, 80h                  ;Селекція знаку
        or [di]+3, ah                ;Запис знаку
sstp: mov ah,2            ;Функція ДОС
        scr m3,di           ;Видача на екран результату 
       curs 
       jmp tpr              ;Керування на продовження 
ovr:  curs  
       mess mo              ;Повідомлення про переповнення
       ret
       jmp tpr
und: curs 
        mess mu             ;Повідомлення про антипереповнення
        ret
tpr: pop cx            ;Поновлення 
       pop di             ;лічильника та
       pop si              ;покажчиків
      add di,4            ;Збільшення адреси
      add si,4             ; операндів
      dec bp                     ;Корекція лічильника зовнішнього циклу
            je ntx1                ;Цикл виконано чотири рази
            jmp nxt             ;Галуження на наступний варіант циклу
    ntx1: curs
        mess me            ;Повідомлення про закінчення тестування
        mov ax,4c00h   ;Повернення 
       int 21h                  ;в ДОС
       end main
