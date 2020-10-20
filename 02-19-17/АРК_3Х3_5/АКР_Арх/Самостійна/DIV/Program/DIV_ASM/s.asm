masm
.model small                           ;Тип моделі пам’яті
.stack 100h                              ;Сегмент стеку
.data                                         ;Сегмент даних
X dw  6799                      ;Визначення в пам'яті 
Y db  121                          ;операндів 
Q db ?                              ;та результату
R db ?                               ;ділення
C equ 8                              ;Лічильник циклів
M  equ 80h                        ; Маска для байту                                 
m0 db '                  Division unsigned bytes',0dh,0ah, 0ah,'$'  
m1 db '                  < Error divisor zero >',0dh,0ah, 0ah,'$'  
m2 db '                  < Error divisor invalid >',0dh,0ah, 0ah,'$'     
m3 db '                  < Error dividend invalid >',0dh,0ah, 0ah,'$' 
m4 db '                  < Error present result >',0dh,0ah, 0ah,'$'   
m5 db '                  < Error division absence >',0dh,0ah, 0ah,'$'       
m6 db '                  End of division',0dh,0ah, 0ah,'$'                                                
.code                                           ;Сегмент програми
out_scr macro mes	                ;Макрос видачі на екран повідомлення
                mov dx,offset mes   ;Адреса повідомлення
                mov ah,09h                ;Функція DOS
                int 21h
                endm
inp_key macro         ;Макрос очікування натиску клавіші
                mov ah,07h
        lpp: int 21h
                cmp al, 'x'
                jne lpp
                endm
  exe:mov ax,@data                     ;Сегменти DS, ES в фізичній       
 mov ds,ax                               ;пам’яті  накладені 
out_scr  m0                            ;Повідомлення на екран
cmp Y,0                                 ;Тестування на 
jnz noz                                   ;ноль дільника
out_scr  m1                           ;Повідомлення на екран
jmp ext                                    ;Вихід від ділення
 noz: cmp Y,M                         ;Тестування на перевищення
jc nom                                     ;экстремуму дільника
out_scr  m2                             ;Повідомлення на екран
jmp ext                                   ;Вихід від ділення
nom: cmp X,0                       ;Тестування на 
jz trn                                       ;ноль діленого
cmp X,M*256                        ;Тестування на 
jc anl                                        ;переповнення частки
out_scr  m3                              ;Повідомлення на екран
jmp ext                                     ;Вихід від ділення
  anl:mov cx,c                            ;Ініціалізація лічильника
mov al,Y                                 ;Пересилка дільника
mov dx, X                              ;Тимчасове збереження діленого
shl word ptr X,1                   ;Тестування  ймовірності                 
sub byte ptr X+1 ,al             ;переповнення 
jc ncf                                     ;частки
out_scr  m4                           ;Повідомлення на екран
jmp ext                                 ;Вихід від ділення
   shd:shl word ptr X,1                 ; Зсув уліво поточної остачі
jnc mns                                ;Остача додатна
add byte ptr X+1 , al           ;Обчислення від’ємної остачі
jmp all                                   ;Перехід на завершення циклу
 mns:sub byte ptr X+1 ,al              ;Обчислення додатної остачі
   ncf:cmc                                          ;Формування біту частки
   all: pushf                                     ;Програмні маніпуляції 
shr word ptr X,1                  ; по формуванню зсуву від
popf                                       ;права на ліво
rcl word ptr X,1                   ; біту частки
loop shd                                 ; Зміна стану програмного циклу
test byte ptr X+1, M           ;Тестування на знак остачі  
jns trn                                  ; Остача додатна
add byte ptr X+1 ,al            ;Поновлення від’ємної остачі
   trn:mov ax,X                               ;Трансляція результату ділення
mov R,ah                                ;Завантаження остачі
mov Q,al                               ;Завантаження частки
mov ax,dx                                ;Завантаження діленого
mov X,ax                                ;Поновлення діленого
div Y                                       ;тестове ділення
out_scr  m5                             ;Повідомлення на екран
   ext:out_scr  m6                              ;Повідомлення на екран
inp_key                                   ;Очікуваня натиску клавіші 
mov ax,4c00h                        ; Програмне
 int 21h                                   ; повернення в MS DOS
end exe                                  ; Закінчення 
