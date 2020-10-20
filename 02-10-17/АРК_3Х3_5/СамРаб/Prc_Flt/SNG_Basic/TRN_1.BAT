:trn.bat                
@echo off
tasm /zi SNG_FPU.asm
if exist SNG_FPU.obj goto lnk
echo Ошибка в файле SNG_FPU.asm
goto end
:lnk
echo Компиляция успешно завершена
pause
tlink /v SNG_FPU.obj
if exist SNG_FPU.exe goto pse
echo Ошибка в файле SNG_FPU.obj
goto end
:pse
echo Компоновка выполнена успешно
del SNG_FPU.obj
del SNG_FPU.map
:end
pause
