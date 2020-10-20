@:div_cpu.bat                
@echo off
@tasm  div_cpu.asm
@if exist  div_cpu.obj goto lnk
@echo Помилка в файлi div_cpu.asm
@goto end
@:lnk
@echo Компiляцiя закiнчена
@pause
@tlink  div_cpu.obj
@if exist div_cpu.exe goto pse
@echo Помилка в файлi div_cpu.obj
@goto end
@:pse
@echo Компоновка закiнчена
@del div_cpu.obj
@del div_cpu.map
@pause
@cls
@div_cpu
@:end
@pause
@exit