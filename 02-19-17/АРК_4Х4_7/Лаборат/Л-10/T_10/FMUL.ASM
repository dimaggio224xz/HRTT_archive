;Умножение с привлечением сопроцессора 
;    1.1755e-38<=|X|<=3.4028e+38             
.model small
.stack 256
out_str macro str         ;Вывод строки
        mov dx,offset str
        mov ah,9
        int 21h
        endm
 cursor macro   ;Перемещение курсора
        mov ah,2
        mov dl,0ah
        int 21h
        mov dl,0dh
        int 21h
        endm
scr_ddw macro adr          ;Вывод данных
        local nxt
        lea si,adr
        mov cx,4
    nxt:scr_byt
        dec si
        loop nxt
        cursor
        endm
scr_byt macro               ;Вывод байта
        local w_0,w_1,tst
        mov bl,128
        mov ah,2
    tst:test [si]+3,bl
        jz w_0
        mov dl,'1'
        jmp w_1
    w_0:mov dl,'0'
    w_1:int 21h
        shr bl,1
        jne tst
        mov dl,' '
        int 21h
        endm
.data
x dd -51.1e-10
y dd 309.8e+8
z dd ?
mes0 db 'EXECUTE MULTIPLICATION COPROCESSOR FPU PENTIUM',0ah,0dh,'$'
mes1 db 'Multiplicand:','$'
mes2 db 'Multiplier:  ','$'
mes3 db 'Product:     ','$'
 .code
main:
mov ax,@data
mov ds,ax
fld x
fmul y
fst z
out_str mes0
;cursor
out_str mes1
scr_ddw x
out_str mes2
scr_ddw y
out_str mes3
scr_ddw z
mov ax,4c00h
int 21h
end main
