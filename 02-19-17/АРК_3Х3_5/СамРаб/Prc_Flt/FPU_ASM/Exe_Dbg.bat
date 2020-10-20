:Coprocessor_Debug.bat                
@echo off
:Процесс компиляции
tasm /zi present.asm
if exist present.obj goto lnk
echo Error file present.asm
goto end
:lnk
echo Compilation termination
pause
:Процесс компоновки
tlink /v present.obj
if exist present.exe goto pse
echo Error file present.obj
goto end
:pse
echo Make termination
pause
del present.obj
del present.map
echo All Ready
pause
:Процесс отладки
td present
del present.exe
:end
