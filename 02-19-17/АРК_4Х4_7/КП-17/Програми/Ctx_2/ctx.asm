Masm        ;ctx.asm – така назва прикладної програми  управління об'єктом 
model small
.stack 100h
.data
MS equ 90h	;Команда програмування адаптера
;Команди модифікації ліній порту С адаптера
CNB_0 equ 00h	;Скидання у нуль CNB 
CNB_1 equ 01h	;Установка у одиницю CNB
WAY_0 equ 04h	;Скидання у нуль WAY 
WAY_1 equ 05h	;Установка у одиницю WAY
MOD_0 equ 08h	;Скидання у нуль MOD
MOD_1 equ 09h	;Установка у одиницю MOD
SEL_0 equ 0Ch	;Скидання у нуль SEL
SEL_1 equ 0Dh	;Установка у одиницю SEL
RED_0 equ 0Eh	;Скидання у нуль RED 
RED_1 equ 0Fh	;Установка у одиницю RED
time dw 3, 4, 6, 7, 8, 11, 12, 15, 16, 19, 20, 21, 24 ;Параметри  затримки
del dw 1000, 2000, 3000, 4000, 5000, 6000, 7000, 8000, 9000
Q db 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12  ;Щільність сигналів управління
;Визначення адресів адаптера
cr equ 46h	;Регістр управління
pa equ cr+2	;Порт А
pb equ cr+4	;Порт В
pc equ cr+6	;Порт С
pio equ cr+7	;Порт введення-виведення
mes_1 db ' CONTROL COUNTER  CTX_OT-429_06_Kozlovtsev ',0dh,0ah, '$'
mes_2 db ' ERROR STATE  CTX_OT-429_06_Kozlovtsev ', 0dh, '$'
mes_3 db ' CONTROL SUCCESS  CTX_OT-429_06_Kozlovtsev ',0dh,0ah, '$'
        .code
        stb proc near          ;Процедура формування STB
       stb_1 equ 03h    ;Команда BSR адаптеру 
       mov al, STB_1   ;Команда установки STB
all: call imp	         ;Формування імпульсу
	 ret                        ;Повернення із процедури
  endp
clr proc near              ;Процедура формування CLR
    clr_1 equ 0dh
	mov al, clr_1        ;Команда установки CLR
	jmp all	         ;Перехід на формування
	endp 
clk proc near
       clk_1 equ 09h    ;Процедура формування CLK
       mov al, clk_1
	  jmp all
	  ret                      ;Повернення із процедури
 endp
imp proc near          ;Процедура формування імпульсу
	 out cr,al	        ;Установка у одиницю
	 call delay	        ;Витримка тривалості імпульсу
	 dec al	        ;Формування команди скидання
	 out cr,al	        ;Скидання у нуль
      call paus             ;Витримка паузи
	 ret                      ;Повернення із процедури
endp
delay proc near        ;Процедура формування затримки
	   push cx	        ;Підготовка лічильників циклів
	   mov cx, time+1	;Параметр зовнішнього циклу
  ext:push cx	        ;Буферизація параметра
	   mov cx, del+1   ;Параметр внутрішнього циклу
  ier:loop ier	       ;Внутрішній цикл
	   pop cx	       ;Поновлення параметра
	   loop ext	        ;Зовнішній цикл
	 pop cx	       ; Поновлення значення
      ret                       ;Повернення із процедури
endp
      paus proc near              ;Процедура формування паузи
	lea bx, Q+9	       ;Адрес щільності
	mov al, [bx]	        ;Пересилка щільності
       next:call delay             ;Виклик затримки
	dec al	                  ;Корекція лічильника
	jnz next
	 ret                       ;Повернення із процедури
endp
   out_scr macro mes	   ;Макрос видачі на екран повідомлення
                mov dx,offset mes  ;Адреса повідомлення
                mov ah,09h	        ;Функція DOS
                int 21h
    endm
        start:   mov ax, @data          ;Основна програма управління
	               mov ds,ax                 ;Визначення сегменту даних
                   out_scr  mes_1         ;Повідомлення про начало управління
                   out_scr  mes_2          ;Повідомлення про помилку управління
jmp mmm
	              mov al, MS	         ;Програмування 
	              out cr, al	                    ;адаптера
	              xor al, al	                    ;Скид у нуль 
	              out pc, al	                    ;ліній порту С
	              in al, pio	                    ;Читання порту
             out pb, al	                    ;Запис у порт В
              mov al, CNB_1  	;Установка
	              out cr, al	                   ;в одиницю лінії CNB
                   call stb	                    ;Запис у лічильник CTH
                   mov al, WAY_1	;Установка у одиницю
	              out cr, al	                    ;лінії WAY
                   call stb	                    ;Запис у лічильник CTL
    in al, pa	                    ;Читання лічильника CTX
    and al,0fh            	;Формування CTL
    mov ah, al	          ;Збереження значення CTL
    mov al, RED_1	          ;Установка у одиницю
    out cr, al	                    ;лінії RED
                   mov al,MOD_1           ;Установка у одиницю
    out cr,al	                    ; лінії MOD
    mov al, 0fh	          ;Видача одиниць в молодшу
   out pb, al	                    ;тетраду  порту В
           whil:in al,pa                      ;Перед умовний цикл корекції  - Читання CTX
	              and al, 0fh	          ;Формування CTH
	              cmp al, ah	          ;Порівняння (CTH)-(CTL)
	              jb exec	                    ;(CTH)  <  (CTL)
	              call stb	                    ;Запис  CTL:=1111
	              call clk	                    ;Дія CTX:=CTX +1
	              jmp whil	                    ;Повторити
           exec:mov al,ah
                   out pb, al	                    ;Видача у порт В старого значення CTL
	              call stb	                    ;Запис у CTL
	              in al,pa	                    ;Читання СTX
	              and al, 0fh	          ;Формування CTH
	              mov ah,al	                    ;Збереження CTH
                   mov al,MOD_0          ;Установка у нуль
	              out cr,al	                    ;лінії MOD
	    mov al,RED_0	          ;Скид у нуль 
	    out cr,al	                    ;лінії RED
             rpit:call clk                      ;Пост умовний цикл  - Корекція CTL:=CTL - 1
	              in al,pa	                    ;Читання лічильника CTX
	              and al,0fh	                    ;Формування в al значення CTL
	              cmp al,ah	                   ;Порівняння (CTL)-(CTH)
                   jb rpit                           ;Умова (CTL) < (CTH)
	              mov al,CNB_0	          ;Скидання у нуль 
    out cr,al	                    ;лінії CNB
    mov al,WAY_0 	;Скидання у нуль
	    out cr,al	                    ;лінії  WAY
	    mov al,ah	                    ;Передача у порт В
         out pb,al             	;старого значення CTH
	    call stb	                    ;Поновлення CTH
	   mov al, CNB_1    	;Установка
	              out cr, al	                    ;в одиницю лінії CNB
   mov al, RED_1	          ;Установка у одиницю
   out cr, al	                    ;лінії RED
                  in al,pa	                    ;Читання лічильника CTX 
                  and al,ah                     ; Функція кон’юнкції
                  not al                          ;та інвертування
                  out pb,al                      ;Виконання функції
                   mov al, WAY_1	;Установка у одиницю
	              out cr, al	                    ;лінії WAY
          call stb	                   ;Запис в CTL
         in al,pa	                    ;Читання CTX
	    out pio, al	                   ;Запис у порт PIO
       mmm:            out_scr  mes_3           ;Повідомлення про завершення управління
                   mov ax,4c00h            ;Повернення у операційне
                   int 21h                       ; середовище MS DOS
            end start
