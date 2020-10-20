@:div_fpu.bat                
@echo off
@tasm  div_fpu.asm
@if exist div_fpu.obj goto lnk
@echo Помилка в файлi fmul.asm
@goto end
@:lnk
@echo Компiляцiя закiнчена
@pause
@tlink div_fpu.obj
@if exist div_fpu.exe goto pse
@echo Помилка в файлi div_fpu.obj
@goto end
@:pse
@echo Компоновка закiнчена
@del div_fpu.obj
@del div_fpu.map
@pause
@div_fpu
@:end
@pause
@exit