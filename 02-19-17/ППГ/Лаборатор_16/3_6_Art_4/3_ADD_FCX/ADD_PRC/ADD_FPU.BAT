@:add_fpu.bat                
@echo off
@tasm  /zi add_fpu.asm
@if exist add_fpu.obj goto lnk
@echo ������� � 䠩�i fmul.asm
@goto end
@:lnk
@echo ����i���i� ���i�祭�
@pause
@tlink /v add_fpu.obj
@if exist add_fpu.exe goto pse
@echo ������� � 䠩�i add_fpu.obj
@goto end
@:pse
@echo ���������� ���i�祭�
@del add_fpu.obj
@del add_fpu.map
@pause
@cls
@add_fpu
@:end
@pause
@cls
@ td add_fpu
@exit