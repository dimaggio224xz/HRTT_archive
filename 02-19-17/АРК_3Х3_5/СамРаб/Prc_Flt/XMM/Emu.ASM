;Емуляція множення змінних в форматі SPFP      
.model small
.586p
.stack 256
out_str macro str         ;Виведення текстового повідомлення    
    mov dx,offset str
        mov ah,9             ;Функція переривання
        int 21h
        endm
scr_ddw macro adr          ;Виведення змінної SPFP
        local nxt
        lea si,adr                ;Адреса змінної
        mov cx,4                ;Число байтів
    nxt:scr_byt                 ;Виведення байту змінної
        dec si                    ;Зменшення числа байтів
        loop nxt                 ;Перехід на повторення
        cursor                     ;Зміщення курсору
        endm
scr_byt macro               ;Виведення байту змінної
        local w_0,w_1,tst
        mov bl,128            ;Маска тестування
        mov ah,2               ;Функція переривання
    tst:test [si]+3,bl       ;Тестування байту
        jz w_0                 ;Біт дорівнює нолю
        mov dl,'1'             ;Формування одиниці
        jmp w_1               ;Перехід на запис
    w_0:mov dl,'0'        ;Формування ноля
    w_1:int 21h             ;Запис на екран біту
        shr bl,1               ;Зсув управо маски
        jne tst                 ;Повторити тестування
        mov dl,' '              ;Запис
        int 21h                 ;пропуску
        endm
zer_tst macro opr             ;Тестування нуля    
        local nnx,stp
        lea si,opr                ;Адреса байтів змінної
        mov cx,4                 ;та лічильник
    nnx:or byte ptr [si],0   ;Формування прапора ZF
        jne stp                    ; Прапор ZF не ноль
        inc si                      ; Адреса наступного байту
        loop nnx                 ;Перхід на повторення 
        xor si,si                 ; Установка ZF в одиницю
    stp:endm
zer_loa macro                   ;Завантаження нуля
        local mnx
        lea bx,opr_x               ;Адреса байтів змінної
        mov cx,4                     ;та лічильник
    mnx:mov byte ptr [bx],0  ;Завантаження нуля
        inc bx                          ; Адреса наступного байту
        loop mnx                     ;Перхід на повторення 
        endm
inp_dat macro ope                ;Уведення з клавіатури
        local lpp,rpt,s30,cor,sto
        mov ah,7                       ;Функція переривання
        lea bx,ope                     ;Адреса памяті
        mov dh,4                       ;Кількість байтів
    lpp:mov dl,2                     ;Прапор користувача
    rpt:int 21h                         ;Уведення з клавіатури
        cmp al,30h                    ;Уведений символ
        jb rpt                             ;не є визнаним
        cmp al,3ah                    ;Пошук визначених символів
        jb s30                            ;Символ є цифра
        cmp al,61h                    ;Пошук визначених символів
        jb rpt                             ;Символ не є визнаним
        cmp al,67h                   ;Пошук визначених символів
        jnb rpt                          ;Символ не є визнаним
        sym                               ;Виведення символу малої літери
        sub al,57h                    ;Знищення мнемоняки ASCII
        jmp cor                       ;Перехід на корекцію прапора
    s30:sym                       ;Виведення символу цифри
        sub al,30h                ;Знищення мнемоняки ASCII
    cor:dec dl                    ;Зменшення стану прапора
        je sto                       ;Перехід на завершення уведення
        mov cl,4                  ;Число зсувів
        shl al,cl                   ;Перміщення в старше тетраду
        mov [bx]+3,al         ;та збереження
        jmp rpt                   ;Перехід на введення молодшої тетради
  sto:add [bx]+3,al         ;Формування молодшої тетради
        push ax                   ;Тимчасове 
        push dx                  ;збереження
        mov ah,2                ;Функція переривання
        mov dl,' '                ; Зміщення екранного
        int 21h                    ;курсору
        pop dx                    ;Поновлення 
        pop ax                    ;стану
        dec bx                    ;Зменшення адреси
        dec dh                    ;та лічильника
        jne lpp                   ;Перхід на молодший байт
        cursor                    ;Зміщення курсору
        endm
 cursor macro   ;Переміщення курсору
        mov ah,2   ;Функція переривання
        mov dl,0ah
        int 21h
        mov dl,0dh
        int 21h
        endm
   sym macro         ;Виведення символу
       push ax
       push dx
       mov ah,2     ;Функція переривання
       mov dl,al
       int 21h
       pop dx
       pop ax
       endm
        .data                          ;Сегмент даних
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
        opr_x db 4 dup (?)  ;Резевування памяті під операнди                     
        opr_y db 4 dup (?)
       .code                        ;Програмній сегмент     
        main:mov ax,@data
             mov ds,ax
             out_str mes7      ;Виведення повідомлення 7
             mov bp,4            ;Кількість множень
  next:   out_str mes8
             inp_dat opr_x      ;УведенняX
             out_str mes9
             inp_dat opr_y     ;Уведення Y
             out_str mes4       ;Виведення повідомлення  4
             scr_ddw opr_x    ;Виведення X
             out_str mes5        ;Виведення повідомлення  5
             scr_ddw opr_y    ;ВиведенняY
             out_str mes6        ;Виведення повідомлення 6
             zer_tst opr_x      ;Тестування X=0
             jz xex                  ;На формування добутку  Z=0
             zer_tst opr_y       ;Тестування  Y=0
             jnz exc                 ;На множення
             zer_loa                 ;Завантаження нуля X:=0                     
      xex:jmp eex               ;На формування добутку Z=0
       exc:lea si,opr_x       ;Ініціалізація 
           lea di,opr_y         ;адраси
           mov bh,[si]+3      ;Обчислення знаку
           xor bh,[di]+3        ;добутку Sing Sz
           mov bl,[si]+2          ;Обчислення  
           add bl,bl                ;характеристики Ex
           mov bl,[si]+3          ;і збереження
           rcl bl,1                   ;в регістрі  (bl)=Ex
           mov al,[di]+2         ;Початок 
           add al,al                 ;обчислення Ey
           pushf                     ;Збереження знаку множника
           mov al,[di]+3        ; Завершення
           rcl al,1                  ; обчислення (al)=Ey
           add bl,al                ; Дія Ez:=Ex+Ey
           jnc min                  ;Треба вілучиті 127
           add bl,129             ;Не ураховано -(256 -127)= -129
           jnc sig                    ;Перхід на відновлення Hidden bit
           out_str mes1            ;Є переповнення
           jmp xxx                    ;На віхід із циклу
       min:sub bl,127            ;Усунення надлишку
           jnc sig                      ;Перхід на відновлення Hidden bit
           out_str mes2            ;Є антипереповнення
           jmp xxx                     ;На віхід із циклу
     sig:or byte ptr [si]+2,80h ;Поновлення
          or byte ptr [di]+2,80h  ;прихованих бітів
            mov ax,[si]                 ;Завантаження 3-х байт 
            mov dl,[si]+2            ; мантиси множеного (dl:ax)=Fx
             xor [si],ax                  ;Скид у ноль 
             xor [si]+2,dl              ; мантиси результатуFz:=0
            mov cx,24                  ; Лічильник мантиси множника
       lop:mov dh,[di]               ; Молодший біт
            rcr dh,1                      ; множника в CF
            rcr byte ptr [di]+2,1   ; Кільцевий
            rcr byte ptr [di]+1,1   ; зсув управо
            rcr byte ptr [di],1       ; множника 
            jnc nos                       ; Прапор CF не ноль
            add [si],ax                 ; Сума приватного
            adc [si]+2,dl              ; добутку
      nos:rcr byte ptr [si]+2,1   ;Зсув управо 
            rcr byte ptr [si]+1,1    ; приватного 
            rcr byte ptr [si],1        ; добутку
            loop lop                     ; Перхід на повторення
             pushf                        ; Для точності в CF загублений біт
            mov al,[si]+2            ;Тестування старшого біту           
            or al,al                      ; мантиси добутку
            js nsh                         ; Старший біт одиниця
            popf                           ; Поновлення загубленого біту
            rcl word ptr [si],1      ;Зсув уліво
            rcl byte ptr [si]+2,1   ; мантиси добутку 
            jmp anl                      ;Перехід на тестування 
      nsh:inc bl                        ; Формування цілой частини - одиниці
     anl:or bl,bl                      ; Тестування на ноль Ez
           jnz ppp                       ; Характеристика не ноль
        out_str mes2                  ; Є антипереповнення
            jmp xxx                      ; На віхід із множення
     ppp:cmp bl,0ffh               ; Тестування на максимум
            jnz rrr                       ; Характеристика не максимальна
           out_str mes1               ;Є переповнення
           jmp xxx                       ; На віхід із множення
         rrr: shl byte ptr [si]+2,1; Формування прихованого біту
            shr bl,1                       ; Зсув характеристики
            rcr byte ptr [si]+2,1   ; і запис молодшого її біту
            and bh,80h                 ; Селекція знаку добутку
            or bl,bh                      ; та запис згідно формату
            mov [si]+3,bl             ; Завантаження в память
            shl byte ptr [di]+2,1   ; Поновлення
            popf                           ; знаку
            rcr byte ptr [di]+2,1   ; множника
      eex:scr_ddw opr_x          ;Виведення добутку Z
         out_str mes3                  ;Виведення повідомлення 3 
       xxx:dec bp                      ;Зменшення лічильника множень 
              jnz next                    ;Перехід на наступне множення 
            out_str mes10            ;Виведення повідомлення 10
             mov ax,4c00h           ;Повернення в ДОС 
            int 21h
             end main

