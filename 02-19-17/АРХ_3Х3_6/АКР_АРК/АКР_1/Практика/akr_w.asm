format mz			    ;Програмна емуляція множення змінних EXTENDED
     push cs
     pop ds			    ;Ініціалізація сегменту даних
     jmp stt
stt:
  mov ebx, wer
mov dx, wer
add word [ebx],dx
    ;and dword ptr [bx]+disp, data
   ; test word ptr [ebx]+disp, data
   ; lock or  ss:word ptr [bx]+disp, data
    ;add dword ptr [eax]+[edi*4]+disp, data
    ;add word ptr [eax]+[edi*4]+disp, data
    ;add es:word ptr [eax]+[edi*4]+disp, data

disp equ 99
data equ -36
wer dw -45
qwe dd 30000