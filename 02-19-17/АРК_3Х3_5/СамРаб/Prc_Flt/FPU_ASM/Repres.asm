;Represention PENTIUM-coprocessor data 
.586p
masm             
model use16  small
.stack 256
.data
x dd 0.000006 ; -19300.091796875Single     (1.1755e-38 =< |X| <= 3.4028e+38)
y dq 0.000006               ;Double    (2.2250e-308 =< |Y| <= 1.7977e+308)
z dt  0.000006           ;Extended (3.3620e-4932 =< |Z| <= 1.1899e+4932)
m db '         Represent data FPU processor PENTIUM  start $ '
m1 db '         SINGLE  : $'
m2 db '         DOUBLE  : $'
m3 db '         EXTENDED: $'
m4 db '         Represent data FPU processor PENTIUM  stop $ '

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
         mov dl,[bx]       ;Завантаження з памяті 
         push cx            ;Збереження в стеку
         mov cl,4           ;Розрядність тетради
         shr dl,cl            ; Pced управо на чотири
         pop cx             ;Поновлення регыстру
         scr_sym           ;Видача старшого символу байту
         mov dl,[bx]      ;Завантаження того ж числа з памяті 
         and dl,0fh         ;Знищення старшоъ тетради
         scr_sym           ;Видача молодшого символу байту
         mov dl,20h        ;Видача  символу 
         int 21h               ;пропуск
         endm
         init macro cnt,per        ;Ініціалізація   
              mov cx,cnt             ;лічильника та
              mov bx,offset per  ; показника адреси
              endm
        zzz macro             ;Видача байтів ASCII символів змінної   
             local next
        next:scr_byte       ;Видача байту ASCII символів
             dec bx            ;Зменшення адреси
             loop next        ;Зменшення лічильника та перехід
             mov dl,'h'        ;Видача
             int 21h             ;символу h
             endm
       curs macro             ;Перевід стрічки екрану
            mov dl,0ah         ;Перехід на наступну     
            int 21h               ;стрічку
            mov dl,0dh        ;Перехід на початок 
            int 21h               ;стрічки
            endm
   mess macro adr                  ;Видача
           push ax                      ;текстового
           lea dx,adr                   ;повідомлення
           mov ah,9                    ;на екран
           int 21h                        ;монітора
           pop ax                       ;компютера
           endm   
main:                                        ;Основная программа
mov ax,@data     ;Будова сегменту
mov ds,ax           ;даних
finit                    ;Ініціалізація співпроцесора
fld1                   ;Завантаження одиниці в співпроцесор
fmul x               ;Множення на одиниці на змінну Single    
fst y                   ;Збереження як Double
fstp z                 ;Збереження як Extended 
mov ah,2            ;Функція ДОС
mess m              ;Повідомлення Represent data FPU processor PENTIUM
curs                    ;Перехід
curs                    ;на нову стрічку екрану
mess m1             ;Відповідне повідомлення
init 4,x+3            ;Ініціалізація  покажчиків 
zzz                   ;Видача на екран змінної Single     
curs                  ;Перехід на нову
curs                  ;стрічку екрану
mess m2           ;Відповідне повідомлення
init 8,y+7          ;Ініціалізація  покажчиків 
zzz                   ;Видача на екран змінноїDouble
curs                  ;Перехід на нову
curs                  ;стрічку екрану
mess m3           ;Відповідне повідомлення
init 10,z+9        ;Ініціалізація  покажчиків 
zzz                   ;Видача на екран змінної Extended 
curs                  ;Перехід на нову
curs                  ;стрічку екрану
mess m4   
curs                  ;Перехід на нову
curs                  ;стрічку екрану
mov ax,4c00h   ;Повернення 
int 21h              ;в ДОС
end main
