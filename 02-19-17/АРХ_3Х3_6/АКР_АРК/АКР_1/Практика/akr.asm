.586
.model small  
.stack 100h
.data
disp equ 99
data equ -36
wer dw -45
qwe dd 30000
.code 
stt:mov ax,@data        
    mov ds,ax      
  lea ebx, wer
mov dx, wer
add word ptr [ebx],dx
    ;and dword ptr [bx]+disp, data
   ; test word ptr [ebx]+disp, data
   ; lock or  ss:word ptr [bx]+disp, data
    ;add dword ptr [eax]+[edi*4]+disp, data
    ;add word ptr [eax]+[edi*4]+disp, data
    ;add es:word ptr [eax]+[edi*4]+disp, data
    mov ax,4c00h    
    int 21h              
end stt 
