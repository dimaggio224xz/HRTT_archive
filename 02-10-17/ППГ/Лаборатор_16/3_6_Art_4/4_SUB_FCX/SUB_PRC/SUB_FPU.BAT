@:add_fpu.bat                
@echo off
@tasm  /zi sub_fpu.asm
@if exist  sub_fpu.obj goto lnk
@echo Помилка в файлi sub_fsub.asm
@goto end
@:lnk
@echo Компiляцiя закiнчена
@pause
@tlink /v  sub_fpu.obj
@if exist  sub_fpu.exe goto pse
@echo Помилка в файлi  sub_fpu.obj
@goto end
@:pse
@echo Компоновка закiнчена
@del  sub_fpu.obj
@del  sub_fpu.map
@pause
@cls
@ sub_fpu
@:end
@pause
@cls
@ td  sub_fpu
@exit