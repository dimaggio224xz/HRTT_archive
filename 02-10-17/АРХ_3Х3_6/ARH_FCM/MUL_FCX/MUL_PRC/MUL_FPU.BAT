@:mul_fpu.bat                
@echo off
@tasm  mul_fpu.asm
@if exist mul_fpu.obj goto lnk
@echo Помилка в файлi mul_fpu.asm
@goto end
@:lnk
@echo Компiляцiя закiнчена
@pause
@tlink  mul_fpu.obj
@if exist mul_fpu.exe goto pse
@echo Помилка в файлi mul_fpu.obj
@goto end
@:pse
@echo Компоновка закiнчена
@del mul_fpu.obj
@del mul_fpu.map
@pause
@cls
@mul_fpu
@:end
@pause
@exit