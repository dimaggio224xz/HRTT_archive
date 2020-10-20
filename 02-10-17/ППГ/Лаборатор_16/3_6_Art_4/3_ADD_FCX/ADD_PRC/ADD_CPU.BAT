@:add_cpu.bat                
@echo off
@tasm  add_cpu.asm
@if exist  add_cpu.obj goto lnk
@echo Помилка в файлi add_cpu.asm
@goto end
@:lnk
@echo Компiляцiя закiнчена
@pause
@tlink  add_cpu.obj
@if exist add_cpu.exe goto pse
@echo Помилка в файлi add_cpu.obj
@goto end
@:pse
@echo Компоновка закiнчена
@del add_cpu.obj
@del add_cpu.map
@pause
@cls
@add_cpu
@:end
@pause
@exit