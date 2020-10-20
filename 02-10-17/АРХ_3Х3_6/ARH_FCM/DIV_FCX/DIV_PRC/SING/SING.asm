;Presentation PENTIUM-coprocessor data SINGLE
.586p
masm             
model use16  small
.stack 256
.data
;(1,1754943)*10-38  = < | X | < = (3,4028234)*10+38 .
x dd 1.0754940E-38  
y dd 3.7028234E+38 
z dd 1.0
ms db '      Presentation SINGLE of coprocessor PENTIUM start   $ '
me db '      Presentation SINGLE of coprocessor PENTIUM stop  $ '
m1 db '                   X = $'
m2 db '                   Y = $'
m3 db '                   Z = $'
.code
scr_sym macro              ;Видача ASCII символу
        local fri,sym
        cmp dl,0ah          ;Порівняння з десяткою
        jb fri                   ;Менше десятки
        or dl,40h             ;Формування символу 
        sub dl,09h           ;велікої літері 
        jmp sym              ;Перехід на видачу
   fri:or dl,30h             ;Формування символу 
 sym:int 21h              ;Видача символу на екран   
        endm  
scr_byte macro          ;Видача байту ASCII символів
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
    curs macro                ;Перевід стрічки екрану
            mov dl,0ah         ;Перехід на наступну     
            int 21h               ;стрічку
            mov dl,0dh        ;Перехід на початок 
            int 21h               ;стрічки
            endm
   mess macro adr                ;Видача
           push ax                      ;текстового
           lea dx,adr                   ;повідомлення
           mov ah,9                    ;на екран
           int 21h                        ;монітора
           pop ax                       ;компютера
           endm  
       scr macro m,t        ;Ініціалізація   
             curs                  ;Перехід на нову та впочаток стрічки
             mess m             ;Відповідне повідомлення
             mov cx,4          ;Ініціалізація лічильника та
             lea bx,t+3        ; показника адреси
             xyz                    ;Видача на екран змінної Single     
             endm
 main:                  ;Основная программа
mov ax,@data     ;Будова сегменту
mov ds,ax           ;даних
mov ah,2            ;Функція ДОС
curs 
mess ms              ;Повідомлення про початок тестування
curs    
scr m1,x           ;Видача на екран змінної X  
scr m2,y           ;Видача на екран змінної Y   
scr m3,z            ;Видача на екран змінної Z
 curs 
 curs 
mess me             ;Повідомлення про закінчення тестування
curs 
curs 
mov ax,4c00h   ;Повернення 
int 21h              ;в ДОС
end main