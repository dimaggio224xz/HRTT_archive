;Translate Single to SNG  x=47,1
 model  small
.stack 256
.data
SNG dw 8e14H, 43dfH    ;����� ���������� SNG   
FPU dw 2 dup(?)        ;����� ���������� Single
TST dd 447.11          ;����� �������� ����������  
.code
main:
mov ax,@data           ;������������� 
mov ds,ax              ;�������� ������    
mov ax,sng             ;�������� ����� �������
mov fpu,ax             ;����� �������� � ������
mov dx,sng+2           ;������� �������� ��������� Single   
mov ah,dh              ;���������� � �� 
and ah,80h             ;����� ��������� Single 
shl dh,1               ;������� �������������� SNG 
test dl,80h            ;������������ �������� ���� �������������� Single     
jz l2                  ;������� ��� ����� ����
or dh,1                ;��������� �������� ���� �������������� Single  
l2:
cmp dh,0               ;��������� � ����������� ���������         
je zero2               ;��������� ����������������
add dh,2               ;��������� ������� Single  
and dl,7fh             ;����� ������� ���� �������� Single    
or dl,ah               ;������������� ����� ����� Single   
mov fpu+2,dx           ;������ �������� ����� ��������� Single  
jmp done               ;�������������� ���������
zero2:
mov word ptr fpu,0     ;������ � ������ ���� +0.0
mov word ptr fpu+2,0   ;��� ����������  Single  
done:
mov ax,4c00h           ;������� � ������������
int 21h                ;����� MS DOS
end main
