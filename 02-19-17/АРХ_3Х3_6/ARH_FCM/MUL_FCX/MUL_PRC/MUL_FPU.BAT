@:mul_fpu.bat                
@echo off
@tasm  mul_fpu.asm
@if exist mul_fpu.obj goto lnk
@echo ������� � 䠩�i mul_fpu.asm
@goto end
@:lnk
@echo ����i���i� ���i�祭�
@pause
@tlink  mul_fpu.obj
@if exist mul_fpu.exe goto pse
@echo ������� � 䠩�i mul_fpu.obj
@goto end
@:pse
@echo ���������� ���i�祭�
@del mul_fpu.obj
@del mul_fpu.map
@pause
@cls
@mul_fpu
@:end
@pause
@exit