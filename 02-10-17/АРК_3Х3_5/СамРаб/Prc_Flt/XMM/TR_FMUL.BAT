:trn.bat                
@echo off
tasm /zi fmul.asm
if exist fmul.obj goto lnk
echo Ошибка в файле fmul.asm
goto end
:lnk
echo Компиляция успешно завершена
tlink /v fmul.obj
if exist fmul.exe goto pse
echo Ошибка в файле fmul.obj
goto end
:pse
echo Компоновка выполнена успешно
del fmul.obj
del fmul.map
:end
pause
exit