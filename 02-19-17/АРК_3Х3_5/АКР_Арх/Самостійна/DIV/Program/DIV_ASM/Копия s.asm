masm
.model small                           ;��� ����� �����
.stack 100h                              ;������� �����
.data                                         ;������� �����
X dw  15367                    ;���������� � ���'�� 
Y db  123                      ;�������� 
Q db ?                                    ;�� 
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
.code                                           ;������� ��������
out_scr macro mes	                ;������ ������ �� ����� �����������
                mov dx,offset mes   ;������ �����������
                mov ah,09h                ;������� DOS
                int 21h
                endm
inp_key macro         
                mov ah,07h
        lpp: int 21h
                cmp al, 'x'
                jne lpp
                endm
exe:mov ax,@data                  ;�������� DS, ES � �������       
 mov ds,ax                               ;�����  �������� 
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
mov ax,4c00h                        ; ���������
 int 21h                                   ; ���������� � MS DOS
end exe                                  ; ��������� ��������


