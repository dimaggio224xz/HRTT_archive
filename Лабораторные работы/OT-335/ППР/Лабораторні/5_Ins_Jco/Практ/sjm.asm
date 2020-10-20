;Дослідження команд умовного галудження
masm
.model small                                     ;Тип моделі пам’яті
.stack 100h                                      ;Сегмент стеку
.data                                            ;Сегмент даних
X db -67, -78, 127, -128, 0, 99, -71, 13;Перший операнд 
Y db 88, 0h, -45h, -127, 0, -105, 0, -59;Другий операнд   
len equ $-Y                             ;Кількість байтів 
Z db len dup (?)                        ;Критерій порівняння                                                
mes_E db 'E',20h,20h,'$'; 45h - ASCII 'E';Повідомлення про рівність
mes_L db 'L',20h,20h,'$'; 47h - ASCII 'L';Повідомлення про менше
mes_G db 'G',20h,20h,'$'; 4Ch - ASCII 'G';Повідомлення про більше
msk_OF equ dword ptr 800h  ;Маска позиції прапора OF 
msk_SF equ dword ptr 80h   ;Маска позиції прапора SF
msk_ZF equ dword ptr 40h   ;Маска позиції прапора ZF
E equ byte ptr 'E';Трансформат 
L equ byte ptr 'L';абревіатури в
G equ byte ptr 'G';символ ASCII
.code  ;Сегмент програми                                          
mes macro elg,P                        ;Макрос програмного
    push ax                            ;завантаження символу
    mov [bx],elg                       ;в пам’яті та 
    mov ah,09h                         ;виведення 
    mov dx,offset P                    ;повідомлення
    int 21h                            ;за перериванням   
    pop ax                              
    endm
exe:mov ax,@data                       ;Ініціалізація        
       mov ds,ax                       ;сегмента DS                      
       lea si,X                  ;Ініціалізація адрес
       lea di,Y                  ;ланцюга байтів операндів 
       lea bx,Z                  ;та критерію порівнянь
        mov cx,len               ;Довжина ланцюга
   ckl:mov al,[si]               ;Читання елемента першого операнда 
       cmp al,[di]      ;Порівняння та формування усіх прапорів стану
       pushf                     ;Пересилка (FX)
       pop bp                    ;через стек в BP
       test bp,msk_ZF   ;Програмне кон’юнктивне маскування
       jz nxt                   ;(ZF)=0 Less or Greate
       mes e,mes_E              ;(ZF)=1 Equate
       jmp ext         ;Обчислення текучої пари закінчено
   nxt:test bp,msk_SF  ;Програмне кон’юнктивне маскування
       jz res                   ;(SF)=0           
       mov ah,1                 ;(SF)=1        
       jmp xet                   
   res:mov ah,0       
   xet:test bp,msk_OF  ;Програмне кон’юнктивне маскування
       jz rse          ;(OF)=0               
       mov al,1        ;(OF)=1 
       jmp mdd              
   rse:mov al,0       
   mdd:xor al,ah     ;(SF)mod(OF)           
       Jz zer        ;(SF)mod(OF)=0 Greate
       mes l,mes_L   ;(SF)mod(OF)=1 Less
       jmp ext       ;Обчислення текучої пари закінчено
   zer:mes g,mes_G   ;Обчислення текучої пари закінчено
   ext:inc si        ;Корекція покажчиків   
       inc di        ;адрес уперед
       inc bx        ;та лічильника назад
       loop ckl      ;і галудження
       mov ax,4c00h  ;Програмне
       int 21h       ;повернення в MS DOS
       end exe       ;Закінчення програми

