.model small
.stack 256
out_str macro str         ;Введення стрiчки на екран
        mov dx,offset str
        mov ah,9
        int 21h
        endm
inp_key macro         ;Введення символу з клавiатури
           mov ah,07h
    lpp: int 21h
           cmp al, 'x'
           jne lpp
           endm
inp_dat macro ope                ;Введення  данних з клавiатури
        local lpp,rpt,s30,cor,sto
        mov ah,7                     ;Функцiя ДОС
        lea bx,ope                   ;Адреса змiнної в памятi
        mov dh,4                     ; Кiлькiсть байтiв змiнної
  lpp:mov dl,2                     ;Кiлькiсть тетрад в байтiв
  rpt:int 21h                        ; Введення символу з клавiатури
        cmp al,30h
        jb rpt                           ; Символ не є робочим
        cmp al,40h                 
        jb s30                           ; ASCII символ є цифрою
        cmp al,60h
        jbe rpt                          ; ASCII символ не є цифрою
        cmp al,67h
        jnb rpt                          ; ASCII символ не є цифрою
        sym                               ;Виводиться символ
        sub al,57h                     ;Перетворення ASCII в код
        jmp cor
    s30:cmp al,3ah 
       jae rpt                                 ;Символ не є робочим
        sym                                     ;Виводиться цифра
        sub al,30h                          ;Перетворення ASCII в цифру 
    cor:dec dl
        je sto                                  ;Перехiд на збереження
        mov cl,4
        shl al,cl
        mov [bx]+3,al               ;Збереження старшої тетради
        jmp rpt
    sto:add [bx]+3,al              ;Збереження молошої тетради
    push ax 		  ;Тимчасове збереження
    push dx 
        mov ah,2
        mov dl,' '
        int 21h                     ;Виводиться пропуск
     pop dx
     pop ax
        dec bx                 ;Зменшення адреси
        dec dh                 ;Корекцiя лiчильника циклу
        jne lpp
        mov ah,2
       mov dl, 'h'                 
       int 21h	                  ;Виводиться символ
      curs_beg 
       endm
       
scr_ddw macro adr          ;Виведення стрiчки
        local nxt
        push bx
       push cx
        lea bx,adr                ;Початкова адреса стрiчки
       add bx,3
        mov cx,4                  ;Довжина стрiчки
    nxt:scr_byt                  ;Виведення текучого байту стрiчки
        dec bx
        loop nxt                    ;Перехiд на наступний байт
      pop cx
       pop bx
       mov ah,2
       mov dl, 'H'
       int 21h	                    ;Виводиться символ
       cursor 
       endm
                    scr_byt macro 		    ;Виведення одного байту
	 local comp,symb,scrn,exit
		mov ah,2		     ;Функцiя системного переривання
		mov dh,1		     ;Установка прапора користувача
		mov dl,[bx]		     ;Передача текчого байту
		shr dl,4	     ;Передача старшої тетради в молодшу
	           comp:cmp dl,10		      ;Порiвняння з десяткою
		jnc symb		       ;Симвiл бiльше або рiвен десять
		add dl,30h	      ;Формування ASCII символу чисел 0,1,..,9
		jmp scrn		       ;Перехiд на вивiд символу
	           symb:add dl,37h	       ;Формування ASCII символу чисел 10,11,..,15
	             scrn:int 21h		      ;Вивiд символу
		or dh,dh		      ;Аналiз
		jz exit 		      ;прапора користувача
		mov dh,0		     ;Скид  прапора користувача
		mov dl,[bx]		     ;Передача текучого байту
		and dl,0fh		      ;Формування молодшої тетради
		jmp comp	     ;Перехiд на обробку молодшої  тетради  символу
	               exit:mov dl,' '	                  ;Вивiд символу
		int 21h 
                     endm
                     
       zer_tst macro opr             ;Тестування срiчки на ноль
        local nnx,stp
        lea bx,opr
        mov cx,4
    nnx:or byte ptr [bx],0     ;Акумуляцiя диз'юнкцiї
        jne stp
        inc bx
        loop nnx
        xor bx,bx                     ;Установка прапора ZF
   stp:endm
           
 cursor macro                     ;Перемiщення курсору
        mov ah,2                       ;Функцiя ДОС
        mov dl,0ah                   
        int 21h
        mov dl,0dh
        int 21h
        endm
curs_beg macro                     ;Перемiщення курсору в початок стрiчки
        mov ah,2
        mov dl,0dh
        int 21h
        endm


   sym macro                      ;Виведення ASCII символа байту
       push ax
       push dx
       mov ah,2                   ;Функцiя ДОС
       mov dl,al
       int 21h
       pop dx
       pop ax
         endm

        ;СЕГМЕНТ ДАНИХ
        .data
        mes1 db '                         Exeption Overflow',0ah,0dh,'$'
        mes2 db '                         Exeption Underflow',0ah,0dh,'$'
        mes3 db '                         Exeption Absents',0ah,0dh,'$'
        mes4 db '                      Dividend: ','$'
    mes5 db '                      Divisor : ','$'
    mes6 db '                      Quotient: ','$'
    mes7 db '              EMULATE DIVISION  SINGLE PROCESSOR CPU PENTIUM',0ah,0dh,'$'
   mes10 db '                STOP DIVISION  SINGLE PROCESSOR CPU PENTIUM',0ah,0dh,'$'
   mes11 db '                         Error division zero',0ah,0dh,'$'
opr_x  dd  ?            ;Набiр даних  дiленого 
opr_y  dd  ?            ;Дiльники, якi вводяться з клав?атури 
        ;СЕГМЕНТ ПРОГРАМИ
        .code
Man_Div proc near                        ;Процедура дiлення мантис
              mov cx, 24                          ;Кiлькiсть розрядiв
               and word ptr [di]+2,0ffh  ;Скид в ноль старшого байту дiльника
               mov ax,[si]                         ;Завантаження
              mov dx,[si]+2                      ; в (dl:ax):=Mx
              and dx,0ffh                          ;Скид в ноль старшого байту дiленого  
         lop:sub ax,[di]                        ;Вiднiмання трьох байтiв 
               sbb dx,[di]+2                    ;мантис, що є остачою 
               cmc                                    ;Формування бiту частки
               pushf 
               jc nng
               add ax,[di]                          ;Поновлення вiд'ємної остачi  
               adc dx,[di]+2
      nng: popf      
              rcl word ptr [si],1                  ;Зсув управо та 
              rcl byte ptr [si] +2,1               ;запис бiту частки
              shl ax,1                                    ;Зсув управо 
              rcl dx,1                                    ; остачi
              loop lop                                    ; Перехiд на новий цикл
              mov cl,[si]+2                              ;Тестування старшого 
              or cl,cl                                        ; бiту частки
              js nsh                                    ;Мантиса нормалiзована
              sub ax,[di]                            ;Формування
              sbb dx,[di]+2                        ;бiту
              cmc                                       ;частки
            rcl word ptr [si],1                  ;Зсув частки 
            rcl byte ptr [si]+2,1               ;управо
            dec bl                                      ;Зменшення характеристики частки
            cmp bl,255                              ;Тестування на антипереповнення
             je und                                     ;Є антипереповнення
      zer: cmp bl,0                                ;Тестування на антипереповнення
              jne ext                                  ;Немає антипереповнення
   und:out_str mes2                           ;Антипереповнення
   ext:  ret
     nsh:cmp bl,255                            ;Тестування на переповнення
             jne zer
            out_str mes1                            ;Переповнення
            jmp ext
             endp
  main:mov ax,@data
           mov ds,ax
           out_str mes7            ;Повiдомлення 7
           lea si,opr_x              ;Iнiцiалiзацiя адресiв
           lea di,opr_y              ;операндiв 
           mov bp, 4                 ;Кiлькiстть дiлень 
            cursor
   nxt:  out_str mes4
             inp_dat opr_x ;Введення дiлимого
             out_str mes4
             scr_ddw opr_x ;Значення дiлимого на екранi
             out_str mes5
             inp_dat opr_y ;Введення дiльника
             out_str mes5
             scr_ddw opr_y ;Значення дiльника на екранi
             zer_tst opr_y    ;Тестування  Y=0
            jnz exc              ;Перехiд на наступну дiю
            out_str mes11    ;Є помилка дiлення на ноль
            jmp xxx             ; Наступний набiр операндiв
       exc: zer_tst opr_x    ;Тестування   X=0
             jz yyy               ;Дiлене не ноль
           mov bh,[si]+3         ;Визначення знаку
           xor bh,[di]+3          ;частки вiд дiлення (BH[7])= Sz
           mov bl,[si]+2          ;Обчислення
           add bl,bl                 ;характеристики
           mov bl,[si]+3          ;дiленого
           rcl bl,1                    ;в (BL) = Ex
           mov al,[di]+2          ;Прихований бiт дiльника
           add al,al                 ; в прапорi CF   
          mov al,[di]+3         ;Характеристика дiльника
           rcl al,1                   ;в (AL)=Ey
          or byte ptr [si]+2,80h ;Поновлення в памятi прихованих
          or byte ptr [di]+2,80h ;бiтiв операндiв
          sub bl,al                         ;Обчислення Ez:=Ex-Ey
           jnc min                           ;Рiзниця додатня
           sub bl,129                     ;Обчислення (256 - 129 )=127 
           jnc man                           ;Виключення вiдсутнє
   xan:  out_str mes2              ;Виключення антипереповнення
           jmp  xxx                      ;Вихiд з програми дiлення
   min: add bl,127                  ;Змiщення частки
           jnc man                                   ;Виключення вiдсутнє
           out_str mes1           ;Виключення переповнення
           jmp  xxx                  ;Вихiд з програми дiлення
   man:call Man_Div          
            shl byte ptr [si]+2,1 ;Зсув улiво старшого байту мантиси частки
            shr bl,1                     ;Зсув управо байту характеристики частки
            rcr byte ptr [si]+2,1;Зсув управо старшого байту мантиси частки
            and bh,80h               ;Формування 
            or bl,bh                    ;знаку частки
            mov [si]+3,bl            ;та запис в память 
  yyy:   out_str mes6       ;Повiдомлення 6
            scr_ddw opr_x    ;Виведення частки
             out_str mes3       ;Повiдомлення про безексцеснiст
  xxx:   dec bp
            je ntx                ;Цикл виконано чотири рази
            jmp nxt             ;Галуження на наступний цикл
    ntx: cursor
    out_str mes10              ;Повiдомлення про закiнчення дiлення
           inp_key
        mov ax,4c00h
            int 21h
        end main

