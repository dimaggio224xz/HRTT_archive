@:add_fpu.bat                
@echo off
@tasm  /zi len_fpu.asm
@if exist len_fpu.obj goto lnk
@echo ������� � 䠩�i mul_fpu.asm
@goto end
@:lnk
@echo ����i���i� ���i�祭�
@pause
@tlink   /v len_fpu.obj
@if exist len_fpu.exe goto pse
@echo ������� � 䠩�i len_fpu.obj
@goto end
@:pse
@echo ���������� ���i�祭�
@del len_fpu.obj
@del len_fpu.map
@pause
@cls
@ td len_fpu
@:end
@pause
@exit