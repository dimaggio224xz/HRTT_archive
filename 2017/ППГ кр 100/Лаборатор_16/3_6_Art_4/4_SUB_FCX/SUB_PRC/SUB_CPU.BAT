@:sub_cpu.bat                
@echo off
@tasm  sub_cpu.asm
@if exist  sub_cpu.obj goto lnk
@echo ������� � 䠩�i sub_cpu.asm
@goto end
@:lnk
@echo ����i���i� ���i�祭�
@pause
@tlink  sub_cpu.obj
@if exist sub_cpu.exe goto pse
@echo ������� � 䠩�i sub_cpu.obj
@goto end
@:pse
@echo ���������� ���i�祭�
@del sub_cpu.obj
@del sub_cpu.map
@pause
@cls
@sub_cpu
@:end
@pause
@exit