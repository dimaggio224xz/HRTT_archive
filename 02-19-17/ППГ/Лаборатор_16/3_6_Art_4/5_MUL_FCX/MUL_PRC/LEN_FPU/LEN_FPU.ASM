.model small               ;Обчислення довжини кола
.stack 256
out_str macro str         ;Виведення стрiчки
        mov dx,offset str
        mov ah,9
        int 21h
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
                              scr_byt macro 		    ;Виведення одного байту
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
		mov dl,[bx]   	         ;Передача текучого байту
		and dl,0fh		      ;Формування молодшої тетради
		jmp comp	     ;Перехiд на обробку молодшої  тетради  символу
	               exit:mov dl,' '		      ;Виведення символу
		int 21h 
                                             endm
.data
R DD 1.5;
L dd  ?
mes db '           Calculation of length of circuit',10, 13,10,'$'
mes0 db '                 Radius R=','$'
mes1 db '                 Length L=','$'
 .code
main: mov ax,@data
        mov ds,ax
out_str mes       ;Назва програми
FLD1                ; Завантаження одиницi  
FADD ST, ST   ;Формквання двiйки
FLDPI               ;Завантаження pi
FMUL               ;Обчислення 2*рi
FMUL R           ;Обчислення довжини 2*рi*R
FST L                ;Збереження довжини 
LEA DI,R           ;Покажчики
LEA SI,L            ;адреси
out_str mes0              ;Виведення радiусу
scr_ddw di    
out_str mes1               ;Виведення довжини
scr_ddw si  
cursor   
       mov ax,4c00h           ;Повернення
       int 21h                      ;в ДОС
       end main
