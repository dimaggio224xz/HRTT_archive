@:add_fpu.bat                
@echo off
@tasm  /zi sub_fpu.asm
@if exist  sub_fpu.obj goto lnk
@echo ������� � 䠩�i sub_fsub.asm
@goto end
@:lnk
@echo ����i���i� ���i�祭�
@pause
@tlink /v  sub_fpu.obj
@if exist  sub_fpu.exe goto pse
@echo ������� � 䠩�i  sub_fpu.obj
@goto end
@:pse
@echo ���������� ���i�祭�
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