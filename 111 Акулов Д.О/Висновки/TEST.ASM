;Дипломник Ходорковський О. Ю.
;test.asm
model small
.stack 100h
;Макрос обработки тестируемого кода в памяти
write macro cod
      mov ah,cod
      call filcmp  ;Заполнение и сравнение тестового кода
      endm
;Макрос выдачи сообщений
scren macro msi
      mov ah,09h
      mov dx,offset msi
      int 21h
      endm
;Макрос эмуляции ошибки
eml_err macro
        local exm
        cmp si,cx
        jne exm
        dec byte ptr [bx] ;Умышленный ввод ошибки
   exm: endm
.data
ms1 db '                            Тестуєма память вiдсутня',0ah,0dh,0ah,'$'
ms2 db '                  Знайдена помилка за адресою DS:BX з кодом в AL',0ah,0dh,0ah,'$'
ms3 db '                       Тестування проведено безпомилково',0ah,0dh,0ah,'$'
ms4 db '      Дiагностика iнтерфейсу оперативної памятi з головним мiкропроцесором ',0ah,0dh,0ah,'$'
ms5 db '                              Дипломник ХРТK',0ah,0dh,0ah,'$'
mem_tst db 32768 dup(?) ;Область памяти тестирования
spc_tst equ 400h       ;Ёмкость памяти тестирования
.code
strt:jmp exe
;Процедура заполнения и сравнения тестового кода
filcmp proc
       push bx
       push cx
 fillp:mov [bx],ah ;Запись в ячейку тестового кода
       ;eml_err     ;Эмуляция ошибки
       inc bx      ;Коррекция адреса памяти
       loop fillp  ;Переход на обработку следующей ячейки
       pop cx
       pop bx
       push bx
       push cx
 cmplp:cmp [bx],ah  ;Сравнение в ячейке с тестовым кодом
       jnz stop     ;Обнаружена ошибка
       inc bx       ;Коррекция адреса памяти
       loop cmplp   ;Переход на обработку следующей ячейки
       pop cx
       pop bx
       jmp yyy
  stop:mov al,ah     ;Тестовый код в AL
       stc           ;Установка ошибки
       pop cx
       pop si
   yyy:ret
filcmp endp
exe:mov ax,@data          ;Инициализация сегмента данных
    mov ds,ax
    scren ms4             ;Сообщение о программе
    scren ms5             ;Сообщение о программе  
    mov bx,offset mem_tst ;Начальный адрес памяти тестирования
    mov cx,spc_tst        ;Ёмкость памяти тестирования
    mov si,spc_tst/2      ;Адрес середины объёма тестируемой памяти
    mov al,cl             ;Проверка на факт
    or al,ch              ;наличия памяти тестирования
    jnz next              ;Есть память тестирования
    scren ms1             ;Сообщение об отсутствии памяти тестирования
    jmp xxx
next:write 0              ;Обработка тестового кода 00h
     jc errr              ;Обнаружена ошибка
     write 0ffh           ;Обработка тестового кода 0ffh
     jc errr              ;Обнаружена ошибка
     write 0aah           ;Обработка тестового кода 0aah
     jc errr              ;Обнаружена ошибка
     write 55h            ;Обработка тестового кода 55h
     jc errr              ;Обнаружена ошибка
wkl:mov al,80h            ;Поразрядно 
wrl:mov [bx],al           ;в ячейку памяти
    cmp [bx],al           ;с последующим сравнением
    stc                   ;Установка вероятной ошибки 
    jne errr              ;Обнаружена ошибка
    ror al,1              ;Модификация тестового изменяющегося кода
    cmp al,80h            ;Цикл обработки ячейки 
    jne wrl               ;не завершён
    mov byte ptr [bx],0   ;Обнуление текущей ячейки
    inc bx                ;Переход на обработку
    loop wkl              ;очередной ячейки
    scren ms3             ;Сообщение об окончании тестирования
    jmp xxx
errr:scren ms2            ;Сообщение о ошибки в работе памяти 
xxx:mov ax,4c00h          ;Возврат в
    int 21h               ;MS DOS 
    end strt
