@:cpu_idn.bat                
@echo off
@tasm  cpu_idn.asm
@if exist  cpu_idn.obj goto lnk
@echo ������� � 䠩�i cpu_idn.asm
@goto end
@:lnk
@echo ����i���i� ���i�祭�
@pause
@tlink cpu_idn.obj
@if exist  cpu_idn.exe goto pse
@echo ������� � 䠩�i  cpu_idn.obj
@goto end
@:pse
@echo ���������� ���i�祭�
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