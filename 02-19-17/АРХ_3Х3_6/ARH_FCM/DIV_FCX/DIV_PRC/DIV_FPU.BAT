@:div_fpu.bat                
@echo off
@tasm  div_fpu.asm
@if exist div_fpu.obj goto lnk
@echo ������� � 䠩�i fmul.asm
@goto end
@:lnk
@echo ����i���i� ���i�祭�
@pause
@tlink div_fpu.obj
@if exist div_fpu.exe goto pse
@echo ������� � 䠩�i div_fpu.obj
@goto end
@:pse
@echo ���������� ���i�祭�
@del div_fpu.obj
@del div_fpu.map
@pause
@div_fpu
@:end
@pause
@exit