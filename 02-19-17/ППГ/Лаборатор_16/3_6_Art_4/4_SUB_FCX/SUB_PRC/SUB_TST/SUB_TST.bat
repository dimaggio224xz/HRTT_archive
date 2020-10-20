:Presentation sub_tst.bat		      
@echo off
:Етап компіиляції
tasm  /zi sub_tst.asm
if exist  sub_tst.obj goto lnk
echo Error file  sub_tst.asm
goto end
:lnk
echo Compilation termination
:pause
:Этап компоновки
tlink /v sub_tst.obj
if exist sub_tst.exe goto pse
echo Error file  sub_tst.obj
goto end
:pse
echo Make termination
:pause
del  sub_tst.obj
del  sub_tst.map
echo All Ready
:pause
:Этап вызова загружаемого файла
cls
sub_tst
pause
cls
:td sub_tst
del  sub_tst.exe
:end
:pause
exit