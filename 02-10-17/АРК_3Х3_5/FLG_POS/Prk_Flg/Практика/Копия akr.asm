.586
masm                                     
model small  
.stack 100h
.data
disp equ 99
data equ -36
.code 
stt:mov ax,@data        
    mov ds,ax               
    and dword ptr [bx]+disp, data
    xor word ptr [ebx]+disp, data
    lock or  ss:word ptr [bx]+disp, data
    add dword ptr [eax]+[edi*4]+disp, data
    add byte ptr [eax]+[edi*4]+disp, data
    add es:word ptr [eax]+[edi*4]+disp, data
    mov ax,4c00h    
    int 21h              
end stt 
