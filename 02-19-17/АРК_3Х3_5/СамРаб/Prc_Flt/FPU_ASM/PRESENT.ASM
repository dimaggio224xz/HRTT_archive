;Present data coprocessor 
.586p
masm             
model use16  small
.stack 256
.data
x dd  36509.98166701                 ;Single
y dq  -1.0948396824175042E-97   ;Double
z dt  193.00731         ;Extended
 .code
main:
mov ax,@data
mov ds,ax
finit
fld x
fst x
mov eax,x                      ;(eax) = Single 
lea bx,y
mov ecx,[bx]
mov edx,[bx]+4               ;(edx):(ecx) = Double
mov bx,offset z
mov esi,[bx]
mov edi,[bx]+4
mov bx,[bx]+8                ;(bx):(edi):(esi)= Extended
mov ax,4c00h
int 21h
end main
