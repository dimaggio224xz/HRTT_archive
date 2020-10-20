masm          ;Виведення на екран обчисленої  довжини кола   
model   small
.stack 256
.data
pi equ 3.1415926               ;Постійна величина
R dd 1.5                             ;Радіус R
L dd  9.4247778                 ;Довжина L=2*pi*R
ms db '              Testing of length of circuit $'
me db '           Stop execute of length of circuit  $ '
m1 db '               Radius  R=$'
m2 db '               Length  L=$'
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
scr m1,r           ;Видача на екран радіусму
scr m2,l          ;Видача на екран довжини   
curs 
curs 
mess me             ;Повідомлення про закінчення тестування
curs 
curs 
mov ax,4c00h   ;Повернення 
int 21h              ;в ДОС
end main