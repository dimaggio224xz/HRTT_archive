:Assembler.bat                
@echo off       
:Этап компіляції
tasm  tkz_1.asm
if exist tkz_1.obj goto lnk_1
echo Error file tkz_1.asm
goto end_1
:lnk_1
pause
tlink tkz_1.obj
if exist tkz_1.exe goto pse_1
echo Error file tkz_1.obj
goto end_1
:pse_1
pause
del  tkz_1.map
del  tkz_1.obj
cls
 tkz_1
:end_1
pause
del  tkz_1.exe
exit
