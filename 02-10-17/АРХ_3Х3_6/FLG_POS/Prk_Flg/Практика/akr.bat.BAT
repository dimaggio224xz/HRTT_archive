:Assembler.bat                
@echo off       
:Этап компіляції
tasm /l  akr.asm
if exist tkz_2.obj goto lnk_1
echo Error file akr.asm
goto end_1
:lnk_1
echo Not error file akr.asm
:end_1
del akr.obj
pause
del akr.lst
exit
