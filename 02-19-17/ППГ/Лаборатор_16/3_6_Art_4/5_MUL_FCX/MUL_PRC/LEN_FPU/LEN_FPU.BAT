@:add_fpu.bat                
@echo off
@tasm  /zi len_fpu.asm
@if exist len_fpu.obj goto lnk
@echo Помилка в файлi mul_fpu.asm
@goto end
@:lnk
@echo Компiляцiя закiнчена
@pause
@tlink   /v len_fpu.obj
@if exist len_fpu.exe goto pse
@echo Помилка в файлi len_fpu.obj
@goto end
@:pse
@echo Компоновка закiнчена
@del len_fpu.obj
@del len_fpu.map
@pause
@cls
@ td len_fpu
@:end
@pause
@exit