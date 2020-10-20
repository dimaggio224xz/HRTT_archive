;Лістинг 1 – Програма керування роботою зовнішнього лічильника
masm                                     
model small 
scr macro x              ;Макрос видачі на екран текстового повідомлення 
mov dx, offset x
mov ah, 09h
int 21h
 endm
init macro           ;Макрос програмування адаптера
     mov al, ms     ;Слово програмування адаптера 
     out ppi+4, al  ;Вибір напрямку портів
     xor al,al          ;Формування нуля
      out ppi+2, al   ;Скид ліній порту С
      endm
.stack 100h
.data
ms equ 6Bh                 ;Слово MS вибору режиму адаптера
PC1_1 equ 03h           ;Слово BSR для установки PC1
PC1_0 equ 02h           ;Слово BSR для скиду PC1
ppi equ 0a3h               ;Адреса адаптера
pb equ ppi                  ;Початковий порт адаптера
pc equ pb+2                ;Визначення адрес
cr equ pb+4                ; портів
pa equ pb+6                ; адаптера 
mes_1 db '                                        TKZ-1',10,13,10,'$'
mes_2 db '  PB - 6B H; PC - 6D H; CR - 6F H; PA - 71 H ', 10,13, 10,'$'
.code 
        stt:mov ax,@data    ;Початок основної програми   
    mov ds,ax             ;Визначення сегменту даних
    init                        ;Ініціалізація адаптера
    mov al, pc1_1      ;Установка в одиницю
     out pc,al              ; лінії порту РС1
     mov al, pc1_0     ;Скид в нуль
     out pc,al              ;лінії порту РС1
    scr mes_1            ;Виведення повідомлення
     scr mes_2            ;Виведення повідомлення       
     mov ax,4c00h     ;Вихід в
      int 21h                ;операційну систему      
      end stt 
