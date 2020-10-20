.model small  ;Емуляц?я множення в CPU PENTIUM 
.stack 256
out_str macro str         ;Виведення стр?чки
        mov dx,offset str
        mov ah,9
        int 21h
        endm
zer_tst macro opr             ;Тестування на ноль
        local nnx,stp
        lea si,opr
        mov cx,4
    nnx:or byte ptr [si],0
        jne stp
        inc si
        loop nnx
        xor si,si
    stp:endm
zer_loa macro                   ;Завантаження нуля
        local mnx
        lea bx,opr_x
        mov cx,4
    mnx:mov byte ptr [bx],0
        inc bx
        loop mnx
        endm
cursor macro                     ;Перем?щення  курсору 
        mov ah,2                    ; на другу
        mov dl,0ah                  ;та в початок
        int 21h                         ;стр?чки
        mov dl,0dh
        int 21h
        endm
curs_beg macro                     ;Перемiщення курсору в початок 
        mov ah,2                        ;поточної стрiчки
        mov dl,0dh
        int 21h
        endm
inp_dat macro ope                 ;Введення  данних з клавiатури
        local lpp,rpt,s30,cor,sto
        mov ah,7                         ;Функцiя ДОС
        lea bx,ope                        ;Адреса змiнної в памятi
        mov dh,4                       ; Кiлькiсть байтiв змiнної
  lpp:mov dl,2                       ;Кiлькiсть тетрад в байтiв
  rpt:int 21h                           ;Введення символу з клавiатури
        cmp al,30h
        jb rpt                             ;Символ не є робочим
        cmp al,40h                 
        jb s30                             ;ASCII символ є цифрою
        cmp al,60h
        jbe rpt                            ;ASCII символ не є цифрою
        cmp al,67h
        jnb rpt                            ;ASCII символ не є цифрою
        sym                                ;Виводиться символ
        sub al,57h                      ;Перетворення ASCII в код
        jmp cor
    s30:cmp al,3ah 
       jae rpt                                 ;Символ не є робочим
        sym                                    ;Виводиться цифра
        sub al,30h                          ;Перетворення ASCII в цифру 
    cor:dec dl
        je sto                                  ;Перехiд на збереження
        mov cl,4
        shl al,cl
        mov [bx]+3,al                   ;Збереження старшої тетради
        jmp rpt
    sto:add [bx]+3,al                   ;Збереження молошої тетради
         push ax 		                     ;Тимчасове збереження
         push dx 
         mov ah,2
         mov dl,' '
         int 21h                                ;Виводиться пропуск
         pop dx
         pop ax
        dec bx                                ;Зменшення адреси
        dec dh                                ;Корекцiя лiчильника циклу
        jne lpp
        mov ah,2
       mov dl, 'h'                 
       int 21h	                               ;Виводиться символ
      curs_beg 
       endm
    sym macro                              ;Вывод символа
       push ax
       push dx
       mov ah,2
       mov dl,al
       int 21h
       pop dx
       pop ax
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
                   scr_byt macro 	    ;Виведення одного байту
	       local comp,symb,scrn,exit
		mov ah,2		     ;Функцiя системного переривання
		mov dh,1		     ;Установка прапора користувача
		mov dl,[bx]		     ;Передача текчого байту
		shr dl,4	                ;Передача старшої тетради в молодшу
	           comp:cmp dl,10	      ;Порiвняння з десяткою
		jnc symb		       ;Симвiл бiльше або рiвен десять
		add dl,30h	                 ;Формування ASCII символу чисел 0,1,..,9
		jmp scrn		       ;Перехiд на вивiд символу
	           symb:add dl,37h	       ;Формування ASCII символу чисел 10,11,..,15
	             scrn:int 21h	      ;Вивiд символу
		or dh,dh		      ;Аналiз
		jz exit 		      ;прапора користувача
		mov dh,0		     ;Скид  прапора користувача
		mov dl,[bx]		     ;Передача текучого байту
		and dl,0fh		      ;Формування молодшої тетради
		jmp comp	                 ;Перехiд на обробку молодшої  тетради  символу
             exit:mov dl,' '	                 ;Виведення символу
		int 21h 
                     endm
exe_mts macro                    ;Множення мантис
        local   lop,nos
             mov cx,24                 ;Розрядн?сть
      lop: mov dh,[di]               ;Молодший байт множника
             rcr dh,1                      ;Для прапора перенесення CF
             rcr word ptr [di]+1,1 ;К?льцевий зсув      
             rcr byte ptr [di],1       ;множника управо
            jnc nos                       ;Прапор CF=0
            add [si],ax                 ;Сума приватних
            adc [si]+2,dl              ;добуткiв
    nos: rcr word ptr [si]+1,1  ;Зсув управо суми       
            rcr byte ptr [si],1       ;приватних добутк?в
            loop lop                     ;корекц?я л?чильника та перех?д
            pushf                         ;Для точност?
           endm
      .data                                                                  ;Сегмент даних
        mes1 db 'Exception Overflow',0ah,0dh,'$'
        mes2 db 'Exception Underflow',0ah,0dh,'$'
        mes3 db '                           Exception Absents',0ah,0dh,'$'
        mes4 db '                       Multiplicand:','$'
        mes5 db '                       Multiplier  :','$'
        mes6 db '                       Product     :','$'
        mes7 db '                 EMULATE MULTIPLICATION CPU  PENTIUM START',0ah,0dh,'$'
        mes8 db '                 Input multiplicand:','$'
        mes9 db '                 Input multiplier:  ','$' 
        mes10 db '                EMULATE MULTIPLICATION CPU  PENTIUM STOP',0ah,0dh,'$'
        opr_x db 4 dup (?)          ;Резервування пам'ят? 
        opr_y db 4 dup (?)          ;п?д операнди
           .code                            ;Сегмент коду
   main:mov ax,@data
             mov ds,ax
             mov bp,4                          ;К?льк?сть вар?ант?в
             out_str mes7                     ;Пов?домлення 7
     nex: cursor
             out_str mes8
             inp_dat opr_x                     ;Введення X
             out_str mes4                        ;Сообщение 4
             scr_ddw opr_x                     ;Виведення коду X
             out_str mes9
             inp_dat opr_y                      ;ВведенняY
             out_str mes5                        ;Пов?домлення 4
             scr_ddw opr_y                      
            out_str mes6                         ;Пов?домлення 6
             zer_tst opr_x                         ;Тестування X=0
             jz xex                                     ;Добуток Z:=0
             zer_tst opr_y                          ;Тестування  Y=0
             jnz exc                                    ;Добуток Z:=0
             zer_loa                                    ;Д?я X:=0
       xex:jmp eex                                  ;Добуток Z:=0
     exc:lea si,opr_x                               ;?н?ц?ал?зац?я 
           lea di,opr_y                               ;адреси
           mov bh,[si]+3                           ;Формування 
           xor bh,[di]+3                             ;знаку добутку Sz
           mov bl,[si]+2                           ;Обчислення
           add bl,bl                                   ;та завантаження
           mov bl,[si]+3                           ; характеристики
           rcl bl,1                                      ;(bl)=Ex
           mov al,[di]+2                             ;Обчислення
           add al,al                                      ;та завантаження
           mov al,[di]+3                              ;характеристики
           rcl al,1                                         ;(al)=Ey
           add bl,al                                ; Додовання Ez:=Ex+Ey
           jnc min                                 ; Є лишок  зм?щення 127
           add bl,129                             ;Ez:=Ez+256 -127 = Ez +129
           jnc sig                                   ;Перех?д на обчислення мантис
     ovr:out_str mes1                          ; Пов?домлення Overflow
           jmp xxx                                 ; В к?нець циклу
     min:sub bl,127                          ;Вилучення лишку
           jnc sig                                    ;Перех?д на обчислення мантис
    und:out_str mes2                             ; Пов?домлення Overflow
           jmp xxx                                       ; В к?нець циклу
             sig:or byte ptr [si]+2,80h     ;Поновлення 
                   or byte ptr [di]+2,80h     ; прихованих б?т?в
                   mov ax,[si]
                   mov dl,[si]+2            ;Завантаження (dl:ax)=Fx
                   xor [si],ax
                   xor [si]+2,dl              ;Скид мантиси Fz:=0
                   exe_mts                    ; Множення мантис
                   cmp bl,255
                  jz  ovr                         ;Є переповнення
            mov al,[si]+2                   ;Тестування на ноль
            or al,al                              ; Fz(0) =1
            js nsh                                ;Fz(0) дор?внює одиниц? 
            popf                                  ;Досягається точн?сть добутку
            rcl word ptr [si],1              ;Нормал?зац?я ул?во
            rcl byte ptr [si]+2,1           ;мантиси добутку
             cmp bl,0
             jz  und                                ;Характеристика в зон? антипереповнення
            jmp eee
      nsh:popf                                    ;Для в?рної роботи стеку
             inc bl                                   ;Нормал?зац?я ул?во
           cmp bl,255
           jz ovr                                     ;Є переповнення
eee:     and bh,80h                         ; Селекц?я знаку Sz
            mov [si]+3,bl                      ; Запаковка  характеристики Ez,
            shl byte ptr [si]+2,1   ;знаку
            add bh,bh                   ;у внутр?шн?й 
            rcr word ptr [si]+2,1  ;формат
      eex:scr_ddw opr_x            ;Виведення  добутоку  Z      
       out_str mes3                    ;Пов?домлення 3
     xxx:dec bp                          ;Корекц?я л?чильника
            je nxx                           ;Вар?анти зак?нчилися
            jmp nex                        ;На наступний вар?ант
    nxx: cursor            
            out_str mes10               ;Пов?домлення10
             mov ax,4c00h
            int 21h
        end main
