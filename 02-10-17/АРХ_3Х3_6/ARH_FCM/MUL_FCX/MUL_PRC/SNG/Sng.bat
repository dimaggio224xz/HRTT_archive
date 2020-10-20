:Presentation Sing.bat		      
@echo off
:Етап компіиляції
tasm  Sng.asm
if exist  Sng.obj goto lnk
echo Error file  Sng.asm
goto end
:lnk
echo Compilation termination
pause
:Этап компоновки
tlink Sng.obj
if exist Sng.exe goto pse
echo Error file  Sng.obj
goto end
:pse
echo Make termination
pause
del   Sng.obj
del   Sng.map
echo All Ready
pause
:Этап вызова загружаемого файла
cls
 Sng
 pause
del   Sng.exe
:end
exit
