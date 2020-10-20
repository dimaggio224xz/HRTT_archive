:trn.bat                
@echo off
tasm  emu.asm
if exist emu.obj goto lnk
echo Ошибка в файле emu.asm
goto end
:lnk
echo Компиляция успешно завершена
tlink emu.obj
if exist emu.exe goto pse
echo Ошибка в файле fmul.obj
goto end
:pse
echo Компоновка выполнена успешно
del emu.obj
del emu.map
:end
pause
exit