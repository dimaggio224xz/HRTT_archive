@:add_fpu.bat                
@echo off
@tasm  /zi add_fpu.asm
@if exist add_fpu.obj goto lnk
@echo Помилка в файлi fmul.asm
@goto end
@:lnk
@echo Компiляцiя закiнчена
@pause
@tlink /v add_fpu.obj
@if exist add_fpu.exe goto pse
@echo Помилка в файлi add_fpu.obj
@goto end
@:pse
@echo Компоновка закiнчена
@del add_fpu.obj
@del add_fpu.map
@pause
@cls
@add_fpu
@:end
@pause
@cls
@ td add_fpu
@exit