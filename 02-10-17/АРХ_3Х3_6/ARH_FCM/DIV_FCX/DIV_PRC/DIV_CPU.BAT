@:div_cpu.bat                
@echo off
@tasm  div_cpu.asm
@if exist  div_cpu.obj goto lnk
@echo ������� � 䠩�i div_cpu.asm
@goto end
@:lnk
@echo ����i���i� ���i�祭�
@pause
@tlink  div_cpu.obj
@if exist div_cpu.exe goto pse
@echo ������� � 䠩�i div_cpu.obj
@goto end
@:pse
@echo ���������� ���i�祭�
@del div_cpu.obj
@del div_cpu.map
@pause
@cls
@div_cpu
@:end
@pause
@exit