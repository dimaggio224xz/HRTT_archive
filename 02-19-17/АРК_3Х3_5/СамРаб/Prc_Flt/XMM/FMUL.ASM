;Множення з залученнням співпроцесора        
model small
.stack 256
out_str macro str         ;Вивід стрічки
        mov dx,offset str
        mov ah,9             ;Функція ДОС
        int 21h
        endm
 cursor macro            ;Переміщення курсору
        mov ah,2            ;Функція ДОС
        mov dl,0ah        ;На початок
        int 21h               ;стрічки
        mov dl,0dh        ;На нову
        int 21h               ;стрічку
        endm
scr_ddw macro adr          ;Вивід змінної 
        local nxt
        push si                     ;Тимчасове
        push cx                    ;збереження
        mov si,adr               ;Початкова адреса
        add si,3                   ;Адреса старшого байту
        mov cx,4                 ;Кількість байтів
   nxt:scr_byt                   ;Вивід текучого байту
         dec si                     ;На молодшу адресу
         loop nxt                  ;Повторити
         pop cx                    ;Поновлення 
         pop si                     ;даних
         cursor                    ;Початок нової стрічки
        endm
scr_byt macro               ;Вивід байту змінної 
        local w_0,w_1,tst
        push bx                 ;Буфермизація
        mov bl,128           ;Динамічна маска
        mov ah,2               ;Функція ДОС
   tst:test [si],bl             ;Тестування байту
        jz w_0                  ;Біт дорівнює нолю
        mov dl,'1'             ;Установка одиниці
        jmp w_1               ;Біт дорівнює одиниці
w_0:mov dl,'0'             ;Установка ноля
w_1:int 21h                  ;Запис біту на екран
        shr bl,1                 ;Зсув маски управо 
        jne tst                    ;Перейти, якщо не ноль
        mov dl,' '               ;Запис 
        int 21h                   ;пропуску
       pop bx                    ;Поновлення
       endm
.data
x dd  3.4028234E+37, 3.4028236E+37;Набір даних
   dd 1.1754943E-37, 1.1754942E-37 ;множеного
y dd 10.0, 10.0                                     ;Множники, які призводят
   dd 0.1, 0.1                                        ;до екстремумів та виключень
z dd 4 dup (?)                                       ;Резерв під добуток
stat dw ?                                               ;Для слова стану
mes0 db '                  EXECUTE MULTIPLICATION COPROCESSOR FPU PENTIUM',0ah,0dh,'$'
mes1 db '                  Multiplicand:','$'
mes2 db '                  Multiplier:  ','$'
mes3 db '                  Product:     ','$'
mes4 db '                               Exception Overflow', 0ah,0dh, '$'
mes5 db '                               Exception Underflow', 0ah,0dh,'$'
mes6 db '                               Exception Absents', 0ah,0dh, '$'
mes7 db '                STOP TESTING  MULTIPLICATION COPROCESSOR  PENTIUM',0ah,0dh,'$'
 .code
       main:mov ax,@data    ;Програмн6ий 
      mov ds,ax                    ;сегмент
      out_str mes0                ;Назва програми
       lea bx, x                      ;Ініціалізація 
       lea si, y                       ;регістрів 
       lea di, z                       ;адреси
        mov cx,4                    ;Кількість елементів
  nxt:finit                            ;Ініціалізація співпроцесора
       fld dword ptr [bx]       ;Множене в співпроцесор
       fmul dword  ptr [si]    ;Множення
       fstp dword  ptr[di]      ;Збереження в пам'яті добктку
        fstsw stat                    ;Збереження в пам'яті слова стану
       out_str mes1               ;Вивід першого
        scr_ddw bx                ;операнду
        out_str mes2              ;Вивід друггого
        scr_ddw si                 ;операнду
        out_str mes3              ;Вивід на екран
       scr_ddw di                  ;добутру
       Test word ptr stat, 8    ;Переповнення
       jz exe                          ;немає
        out_str mes4              ;Переповнення
        jmp et                        ;присутнє
exe:Test word ptr stat, 16  ;Антипереповнення 
       jz stp                          ;немає
       out_str mes5              ;Антипереповнення 
       jmp et                        ;присутнє
 stp:out_str mes6              ;Виключення відсутні
   et:add bx, 4                   ;Зміна
      add si, 4                     ;адреси
      add di,4                     ;елементів
      dec cx                        ;та кількості
       jz exit                        ;Вихід із циклу
       jmp nxt                     ;Повторення циклу
exit:out_str mes7             ;Завершення
       cursor                       ;програми
       mov ax,4c00h           ;Повернення
       int 21h                      ;в ДОС
       end main
