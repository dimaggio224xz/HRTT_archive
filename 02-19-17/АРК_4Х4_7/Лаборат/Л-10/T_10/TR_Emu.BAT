:trn.bat                
@echo off
tasm /zi emu.asm
if exist  emu.obj goto lnk
echo Ошибка в файле emu.asm
goto end
:lnk
echo Компиляция успешно завершена
pause
tlink /v emu.obj
if exist emu.exe goto pse
echo Ошибка в файле fmul.obj
goto end
:pse
echo Компоновка выполнена успешно
pause
del emu.obj
del emu.map
:end
