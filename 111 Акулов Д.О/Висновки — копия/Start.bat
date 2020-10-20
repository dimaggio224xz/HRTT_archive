@echo off
:Процесс компиляции
:next
tasm  test.asm
if exist test.obj goto lnk
echo Error file test.asm
goto end
:lnk
echo              Compilation termination
pause
:Процесс компоновки
tlink  test.obj
if exist test.exe goto pse
echo Error file test.obj
goto end
:pse
echo              Make termination
del test.obj
del test.map
echo All Ready
cls
test
del test.exe
pause
goto next
:end
pause
exit