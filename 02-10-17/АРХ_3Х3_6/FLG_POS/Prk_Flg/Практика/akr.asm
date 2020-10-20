.586
masm                                     
model small  
.code 
stt:mov ax,@data   
mov ds,ax               
 and  [bx]+66, esi           ;1
  xor dh, [eax]-9              ;2
  or  [ebx]-22, ecx               ;3
  add [eax]+[edi*4], ah   ;4
  adc dx, [eax]+[eax*2]  ;5
  sbb [edi]+[edi*8],edi   ;6
   mov ax,4c00h    
   int 21h              
end stt 
