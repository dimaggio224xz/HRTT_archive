@:cpu_idn.bat                
@echo off
@tasm  cpu_idn.asm
@if exist  cpu_idn.obj goto lnk
@echo Помилка в файлi cpu_idn.asm
@goto end
@:lnk
@echo Компiляцiя закiнчена
@pause
@tlink cpu_idn.obj
@if exist  cpu_idn.exe goto pse
@echo Помилка в файлi  cpu_idn.obj
@goto end
@:pse
@echo Компоновка закiнчена
@del  cpu_idn.obj
@del  cpu_idn.map
@pause
@cls
@cpuid
@cpuid
@echo  (To define microprocessor)        
@ cpu_idn
@:end
@pause
@cls
@exit