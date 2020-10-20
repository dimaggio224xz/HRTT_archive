;Translate Single to SNG  x=47,1
 model  small
.stack 256
.data
SNG dw 8e14H, 43dfH    ;Адрес переменной SNG   
FPU dw 2 dup(?)        ;Адрес переменной Single
TST dd 447.11          ;Адрес тестовой переменной  
.code
main:
mov ax,@data           ;Инициализация 
mov ds,ax              ;сегмента данных    
mov ax,sng             ;Передача слова младшей
mov fpu,ax             ;части мантиссы в памяти
mov dx,sng+2           ;Старшая частлова переменой Single   
mov ah,dh              ;Вычисление в АН 
and ah,80h             ;знака переменой Single 
shl dh,1               ;Позиция характеристики SNG 
test dl,80h            ;Маскирование младшего бита характеристики Single     
jz l2                  ;Младший бит равен нулю
or dh,1                ;Установка старшего бита характеристики Single  
l2:
cmp dh,0               ;Сравнение с критическим значением         
je zero2               ;Произошло антипереполнение
add dh,2               ;Перерасчё порядка Single  
and dl,7fh             ;Сброс срытого бита мантиссы Single    
or dl,ah               ;Присоединение знака числа Single   
mov fpu+2,dx           ;Запись старшего слова переменой Single  
jmp done               ;Преобразование завершено
zero2:
mov word ptr fpu,0     ;Запись в память нуля +0.0
mov word ptr fpu+2,0   ;для переменной  Single  
done:
mov ax,4c00h           ;Возврат в операционную
int 21h                ;среду MS DOS
end main
