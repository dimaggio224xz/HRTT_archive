:trn.bat                
@echo off
tasm /zi FPU_SNG.asm
if exist FPU_SNG.obj goto lnk
echo Ошибка в файле FPU_SNG.asm
goto end
:lnk
echo Компиляция успешно завершена
pause
tlink /v FPU_SNG.obj
if exist FPU_SNG.exe goto pse
echo Ошибка в файле FPU_SIN.obj
goto end
:pse
echo Компоновка выполнена успешно
del FPU_SNG.obj
del FPU_SNG.map
:end
pause
