@:add_cpu.bat                
@echo off
@tasm  mul_cpu.asm
@if exist mul_cpu.obj goto lnk
@echo Помилка в файлi mul_cpu.asm
@goto end
@:lnk
@echo Компiляцiя закiнчена
@pause
@tlink  mul_cpu.obj
@if exist mul_cpu.exe goto pse
@echo Помилка в файлi mul_cpu.obj
@goto end
@:pse
@echo Компоновка закiнчена
@del mul_cpu.obj
@del mul_cpu.map
@pause
@cls
@mul_cpu
@:end
@pause
@exit