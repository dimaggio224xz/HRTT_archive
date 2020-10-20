;Змуляция умножения в PENTIUM со средой обработки ММХ-ХММ (SSE,3DNow!)
.model small
.586p
.stack 256
out_str macro str         ;Вывод строки
        mov dx,offset str
        mov ah,9
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
zer_tst macro opr             ;Тестирование на ноль
        local nnx,stp
        lea si,opr
        mov cx,4
    nnx:or byte ptr [si],0
        jne stp
        inc si
        loop nnx
        xor si,si
    stp:endm
zer_loa macro                   ;Загрузка нуля
        local mnx
        lea bx,opr_x
        mov cx,4
    mnx:mov byte ptr [bx],0
        inc bx
        loop mnx
        endm
inp_dat macro ope                ;Ввод данных
        local lpp,rpt,s30,cor,sto
        mov ah,7
        lea bx,ope
        mov dh,4
    lpp:mov dl,2
    rpt:int 21h
        cmp al,30h
        jb rpt
        cmp al,40h
        jb s30
        cmp al,60h
        jb rpt
        cmp al,67h
        jnb rpt
        sym
        sub al,57h
        jmp cor
    s30:sym
        sub al,30h
    cor:dec dl
        je sto
        mov cl,4
        shl al,cl
        mov [bx]+3,al
        jmp rpt
    sto:add [bx]+3,al
        push ax
        push dx
        mov ah,2
        mov dl,' '
        int 21h
        pop dx
        pop ax
        dec bx
        dec dh
        jne lpp
        cursor
        endm
 cursor macro   ;Перемещение курсора
        mov ah,2
        mov dl,0ah
        int 21h
        mov dl,0dh
        int 21h
        endm
   sym macro     ;Вывод символа
       push ax
       push dx
       mov ah,2
       mov dl,al
       int 21h
       pop dx
       pop ax
       endm
        ;СЕГМЕНТ ДАННЫХ
        .data
        mes1 db 'Overflow',0ah,0dh,'$'
        mes2 db 'Underflow',0ah,0dh,'$'
        mes3 db 'Exeption',0ah,0dh,'$'
        mes4 db 'Multiplicand:','$'
        mes5 db 'Multiplier:  ','$'
        mes6 db 'Product:     ','$'
        mes7 db 'EMULATE MULTIPLICATION TECHNOLOGI XMM  PENTIUM',0ah,0dh,'$'
        mes8 db 'Input multiplicand:','$'
        mes9 db 'Input multiplier:  ','$' 
        opr_x db 4 dup (?)  ;Резервирование памяти под операнды
        opr_y db 4 dup (?)
        ;СЕГМЕНТ КОДА
        .code
        main:mov ax,@data
             mov ds,ax
             out_str mes7  ;Сообщение 7
            ; cursor
             out_str mes8
             inp_dat opr_x ;Ввод X
             out_str mes9
             inp_dat opr_y ;Ввод Y
             out_str mes4  ;Сообщение 4
             scr_ddw opr_x ;Значение
             out_str mes5  ;Сообщение 5
             scr_ddw opr_y ;Значение
             out_str mes6  ;Сообщение 6
             zer_tst opr_x ;Проверка X=0
             jz xex        ;Произведение Z=0
             zer_tst opr_y ;Проверка Y=0
             jnz exc       ;Произведение Z=0
             zer_loa       ;Действие Y:=0
       xex:jmp eex         ;Произведение Z=0
       exc:lea si,opr_x
           lea di,opr_y
           mov bh,[si]+3
           xor bh,[di]+3   ;Sing Sz
           mov bl,[si]+2
           add bl,bl
           mov bl,[si]+3
           rcl bl,1        ;(bl)=Ex
           mov al,[di]+2
           add al,al
           pushf           ;Hidden bit
           mov al,[di]+3
           rcl al,1        ;[al)=Ey
           add bl,al       ;Ez:=Ex+Ey
           jnc min
           add bl,129
           jnc sig
           out_str mes1
           jmp xxx
       min:sub bl,127
           jnc sig
           out_str mes2
           jmp xxx
               sig:or byte ptr [si]+2,80h
                   or byte ptr [di]+2,80h
                   mov ax,[si]
                   mov dl,[si]+2        ;(dl:ax)=Fx
                   xor [si],ax
                   xor [si]+2,dl        ;Fz:=0
            mov cx,24
        lop:mov dh,[di]
            rcr dh,1
            rcr byte ptr [di]+2,1
            rcr byte ptr [di]+1,1
            rcr byte ptr [di],1
            jnc nos
            add [si],ax
            adc [si]+2,dl
        nos:rcr byte ptr [si]+2,1
            rcr byte ptr [si]+1,1
            rcr byte ptr [si],1
            loop lop
            mov al,[si]+2
            or al,al
            js nsh
            shl word ptr [si],1
            rcl byte ptr [si]+2,1
            jmp anl
        nsh:inc bl
        anl:or bl,bl
            jnz ppp
        rrr:out_str mes3
            jmp xxx
        ppp:cmp bl,0ffh
            jz rrr
            shl byte ptr [si]+2,1
            shr bl,1
            rcr byte ptr [si]+2,1
            and bh,80h
            or bl,bh
            mov [si]+3,bl
            shl byte ptr [di]+2,1
            popf
            rcr byte ptr [di]+2,1
        eex:scr_ddw opr_x
        xxx:mov ax,4c00h
            int 21h
        end main

