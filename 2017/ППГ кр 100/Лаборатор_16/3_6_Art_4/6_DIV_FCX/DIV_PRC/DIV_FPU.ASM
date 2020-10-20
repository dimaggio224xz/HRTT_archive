.model small
.stack 256
out_str macro str         ;Виведення стрiчки
        mov dx,offset str
        mov ah,9
        int 21h
        endm
inp_key macro         ;Введення символу з клавiатури
           mov ah,07h
    lop: int 21h
           cmp al, 'x'
           jne lop
           endm
 cursor macro           ;Перемiщення курсору
        mov ah,2
        mov dl,0ah       ;На нову стрiчку
        int 21h
        mov dl,0dh       ;В початок стрiчки
        int 21h
        endm
scr_ddw macro adr         ;Виведення даних
        local nxt
       push bx
       push cx
       mov bx, adr    ;Адреса змiнної Single
       add bx, 3        ;Адреса старшого байту змiнної Single
       mov cx,4        ;Кiлькiсть байтiв елементу пакета
  nxt:scr_byt
        dec bx
        loop nxt
        pop cx
        pop bx
       mov ah,2
       mov dl, 'H'
       int 21h	
       cursor
       endm
                               scr_byt macro 			     ;Виведення одного байту
	                     local comp,symb,scrn,exit
		mov ah,2		     ;Функцiя системного переривання
		mov dh,1		     ;Установка прапора користувача
		mov dl,[bx]                            ;Передача текчого байту
		shr dl,4	       ;Передача старшої тетради в молодшу
	           comp:cmp dl,10		      ;Порiвняння з десяткою
		jnc symb		       ;Симвiл бiльше або рiвен десять
		add dl,30h	      ;Формування ASCII символу чисел 0,1,..,9
		jmp scrn		       ;Перехiд на вивiд символу
	           symb:add dl,37h	       ;Формування ASCII символу чисел 10,11,..,15
	             scrn:int 21h		      ;Вивiд символу
		or dh,dh		      ;Аналiз
		jz exit 		      ;прапора користувача
		mov dh,0		     ;Скид  прапора користувача
		mov dl,[bx]   	                         ;Передача текучого байту
		and dl,0fh		      ;Формування молодшої тетради
		jmp comp	     ;Перехiд на обробку молодшої  тетради  символу
	               exit:mov dl,' '		      ;Виведення символу
		int 21h 
                                             endm
.data
 ;Область визнацення     Minimum    [1.1754943E-38  ..  3.4028234E+38]   Maximum
;Дискрети визначення    Underflow [-0.0000001E-38]  [+0.0000002E+38]  Overflow 
X DD 1.0;
    DD 1.1754942E-37;
    DD -3.4028234E+37;
    DD -3.4028236E+37;

Y DD 1.0
    DD 10.0
    DD  0.1
    DD  0.1

z dd 4 dup (?)                                       ;Резерв пiд частку
stat dw ?                                               ;Для слова стану
mes0 db '               EXECUTE DIVISION COPROCESSOR FPU PENTIUM',0ah,0dh,0ah,'$'
mes1 db '                      Dividend: ','$'
mes2 db '                      Divisor : ','$'
mes3 db '                      Quotient: ','$'
mes4 db '                         Exception Overflow', 0ah,0dh, '$'
mes5 db '                         Exception Underflow', 0ah,0dh,'$'
mes6 db '                         Exception Absents', 0ah,0dh, '$'
mes7 db '               STOP TESTING DIVISION COPROCESSOR FPU PENTIUM',0ah,0dh,'$'
 .code
main: mov ax,@data
        mov ds,ax
        out_str mes0
       lea bx, x                      ;iнiцiалiзацiя 
       lea si, y                       ;регiстрiв 
       lea di, z                       ;адреси
       mov cx,4     
  nxt:finit                            ;iнiцiалiзацiя  спiвпроцесора
       fld dword ptr [bx]       ;Дiлене в спiвпроцесор
       fdiv dword  ptr [si]     ;Дiлення
       fstp dword  ptr[di]      ;Збереження в пам'ятi частки
        fstsw stat                    ;Збереження в пам'ятi слова стану
       out_str mes1               ;Виведення першого
        scr_ddw bx                 ;операнду
        out_str mes2              ;Виведення друггого
        scr_ddw si                  ;операнду
        out_str mes3              ;Виведення на екран
       scr_ddw di                  ;частки
       Test word ptr stat, 8    ;Переповнення
       jz exe                          ;немає
        out_str mes4              ;Переповнення
        jmp et                        ;присутнє
exe:Test word ptr stat, 16  ;Антипереповнення 
       jz stp                            ;немає
       out_str mes5              ;Антипереповнення 
       jmp et                        ;присутнє
 stp:out_str mes6              ;Виключення вiдсутнi
   et: add bx, 4                   ;Змiна
       add si, 4                     ;адреси
       add di,4                     ;елементiв
      dec cx                        ;та кiлькостi
       jz exit                        ;Вихiд iз циклу
       jmp nxt                     ;Повторення циклу
exit:cursor
      out_str mes7             ;Завершення програми
       inp_key
       mov ax,4c00h           ;Повернення
       int 21h                      ;в ДОС
       end main
