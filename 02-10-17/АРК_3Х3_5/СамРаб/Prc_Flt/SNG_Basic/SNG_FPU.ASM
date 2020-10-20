;Translate SNG to Single x=47,1
 model  small
.stack 256
.data
SNG dw 8e14H, 895fH     ;Адрес переменной SNG   
FPU dw 2 dup(?)        ;Адрес переменной Single
TST dd 447.11 
.code
main:
mov ax,@data           ;Инициализация 
mov ds,ax              ;сегмента данных    
mov ax,sng             ;Передача слова младшей
mov fpu,ax             ;части мантиссы в памяти
mov dx,sng+2           ;Старшая частлова переменой SNG    
mov ah,dl              ;Вычисление в АН 
and ah,80h             ;знака переменой SNG  
sub dh,2               ;Переход от смещения 128 к 127
jbe zero1              ;Произошло антипереполнение
shr dh,1               ;Позиционирование характеристики 
jc set1                ;Младший бит равен единице
and dl,7fh             ;Сброс младшего бита характеристики
jmp l1                 ;Характеристика сформирована 
set1:
or dl,80h              ;Установка младшего бита характеристики
l1:
or dh,ah               ;Присоединение знака числа Single
mov fpu+2,dx           ;Запись старшего слова переменой Single
jmp done               ;Преобразование завершено
zero1:
mov word ptr fpu,0     ;Запись в память нуля +0.0
mov word ptr fpu+2,0   ;для переменной  Single
done:
mov ax,4c00h           ;Возврат в операционную
int 21h                ;среду MS DOS
end main
