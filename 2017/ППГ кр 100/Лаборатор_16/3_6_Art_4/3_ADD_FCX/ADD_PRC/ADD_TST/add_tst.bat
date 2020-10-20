:Presentation add_tst.bat		      
@echo off
:Етап компіиляції
tasm  /zi add_tst.asm
if exist  add_tst.obj goto lnk
echo Error file   add_tst.asm
goto end
:lnk
echo Compilation termination
pause
:Этап компоновки
tlink /v  add_tst.obj
if exist  add_tst.exe goto pse
echo Error file  add_tst.obj
goto end
:pse
echo Make termination
pause
del  add_tst.obj
del  add_tst.map
echo All Ready
pause
:Этап вызова загружаемого файла
cls
 add_tst
 pause
cls
:td add_tst
del   add_tst.exe
:end
pause
exit
