@:add_cpu.bat                
@echo off
@tasm  mul_cpu.asm
@if exist mul_cpu.obj goto lnk
@echo ������� � 䠩�i mul_cpu.asm
@goto end
@:lnk
@echo ����i���i� ���i�祭�
@pause
@tlink  mul_cpu.obj
@if exist mul_cpu.exe goto pse
@echo ������� � 䠩�i mul_cpu.obj
@goto end
@:pse
@echo ���������� ���i�祭�
@del mul_cpu.obj
@del mul_cpu.map
@pause
@cls
@mul_cpu
@:end
@pause
@exit