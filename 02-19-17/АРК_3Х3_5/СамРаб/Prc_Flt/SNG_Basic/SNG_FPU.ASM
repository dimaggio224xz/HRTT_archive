;Translate SNG to Single x=47,1
 model  small
.stack 256
.data
SNG dw 8e14H, 895fH     ;����� ���������� SNG   
FPU dw 2 dup(?)        ;����� ���������� Single
TST dd 447.11 
.code
main:
mov ax,@data           ;������������� 
mov ds,ax              ;�������� ������    
mov ax,sng             ;�������� ����� �������
mov fpu,ax             ;����� �������� � ������
mov dx,sng+2           ;������� �������� ��������� SNG    
mov ah,dl              ;���������� � �� 
and ah,80h             ;����� ��������� SNG  
sub dh,2               ;������� �� �������� 128 � 127
jbe zero1              ;��������� ����������������
shr dh,1               ;���������������� �������������� 
jc set1                ;������� ��� ����� �������
and dl,7fh             ;����� �������� ���� ��������������
jmp l1                 ;�������������� ������������ 
set1:
or dl,80h              ;��������� �������� ���� ��������������
l1:
or dh,ah               ;������������� ����� ����� Single
mov fpu+2,dx           ;������ �������� ����� ��������� Single
jmp done               ;�������������� ���������
zero1:
mov word ptr fpu,0     ;������ � ������ ���� +0.0
mov word ptr fpu+2,0   ;��� ����������  Single
done:
mov ax,4c00h           ;������� � ������������
int 21h                ;����� MS DOS
end main
