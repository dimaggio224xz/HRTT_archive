masm
.model small                           ;Тип моделі пам’яті
.stack 100h                              ;Сегмент стеку
.data                                         ;Сегмент даних
X dw  15367                    ;Визначення в пам'яті 
Y db  123                      ;операндів 
Q db ?                                    ;та 
R db ?
C equ 8
M  equ 80h                                 
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
inp_key macro         
                mov ah,07h
        lpp: int 21h
                cmp al, 'x'
                jne lpp
                endm
exe:mov ax,@data                  ;Сегменти DS, ES в фізичній       
 mov ds,ax                               ;пам’яті  накладені 
out_scr  m0
cmp Y,0
jnz noz
out_scr  m1
jmp ext
noz: cmp Y,M
jc nom
out_scr  m2
jmp ext
nom: cmp X,0
jz trn
cmp X,M*256
jc anl
out_scr  m3
jmp ext 
anl:mov cx,c
mov al,Y
push X
shl word ptr X,1
sub byte ptr X+1 ,al
jc ncf
out_scr  m4
jmp ext 
shd:shl word ptr X,1
jnc mns
add byte ptr X+1 ,al
jmp all
mns:sub byte ptr X+1 ,al
ncf:cmc
all: pushf
shr word ptr X,1
popf
rcl word ptr X,1
loop shd
test byte ptr X+1, M
jns trn
add byte ptr X+1 ,al
trn:mov ax,X
mov R,ah
mov Q,al
pop ax
mov X,ax
div Y
out_scr  m5
ext:out_scr  m6
inp_key 
mov ax,4c00h                        ; Програмне
 int 21h                                   ; повернення в MS DOS
end exe                                  ; Закінчення програми


