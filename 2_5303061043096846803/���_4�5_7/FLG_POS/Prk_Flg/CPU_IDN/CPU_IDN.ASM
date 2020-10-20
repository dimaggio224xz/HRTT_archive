;?¤Ґ­вЁд?Є ж?п Їа®жҐб®а 
.586p
model use16 small
.stack 100h
scro macro mes
    lea dx,mes
    mov ah,9
    int 21h
    endm
inp_key macro         ;Макрос очікування натиснення клавіші Х
             local lpp 
             mov ah,07h
      lpp: int 21h
             cmp al, 's'
             jne lpp
             endm
.data
mes00 db ' IDENTIFICATION THE PROCESSOR START',10,10,'$'
mes1 db '      Support coprocessor FPU',10,10,'$'
mes2 db '      Not support coprocessor FPU',10,10,'$'
mes3 db '      Support extension ЊЊ•',10,10,'$'
mes4 db '      Not support extension  ЊЊ•',10,10,'$'
mes5 db '      Support extension SSE',10,10,'$'
mes6 db '      Not support extension SSE',10,10,'$'
mes7 db '      Support extension SSE2',10,10,'$'
mes8 db '      Not support extension SSE2',10,10,'$'
mes9 db '      Support extension 3DNow!',10,10,'$'
mes10 db '      Not support extension 3DNow!',10,10,'$'
mes01 db ' IDENTIFICATION THE PROCESSOR STOP',10,10,'$'
.code
main:
     mov ax,@data
     mov ds,ax
     scro mes00
     mov eax,1
     cpuid
     bt edx,1
     jnc no_fpu
     scro mes1
     jmp exi1
no_fpu:scro mes2
exi1:bt edx,23
     jnc no_mmx
     scro mes3
     jmp exi2
no_mmx:scro mes4
exi2:bt edx,25
     jnc no_sse
     scro mes5
     jmp exi3
no_sse:scro mes6
exi3:bt edx,26
     jnc no_sse2
     scro mes7
     jmp exi4
no_sse2:scro mes8
exi4: bt edx,31
     jnc no_3DNow
     scro mes9
     jmp exi5
no_3DNow:scro mes10
exi5: scro mes01
        inp_key
        mov ax,4c00h
        int 21h
        end main