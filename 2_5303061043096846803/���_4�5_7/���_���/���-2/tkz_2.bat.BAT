:Assembler.bat                
@echo off       
:Этап компіляції
tasm  tkz_2.asm
if exist tkz_2.obj goto lnk_1
echo Error file tkz_2.asm
goto end_1
:lnk_1
pause
tlink tkz_2.obj
if exist tkz_2.exe goto pse_1
echo Error file tkz_2.obj
goto end_1
:pse_1
pause
del  tkz_2.map
del  tkz_2.obj
cls
 tkz_2
:end_1
pause
del  tkz_2.exe
exit
