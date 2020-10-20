@:sub_cpu.bat                
@echo off
@tasm  sub_cpu.asm
@if exist  sub_cpu.obj goto lnk
@echo Помилка в файлi sub_cpu.asm
@goto end
@:lnk
@echo Компiляцiя закiнчена
@pause
@tlink  sub_cpu.obj
@if exist sub_cpu.exe goto pse
@echo Помилка в файлi sub_cpu.obj
@goto end
@:pse
@echo Компоновка закiнчена
@del sub_cpu.obj
@del sub_cpu.map
@pause
@cls
@sub_cpu
@:end
@pause
@exit