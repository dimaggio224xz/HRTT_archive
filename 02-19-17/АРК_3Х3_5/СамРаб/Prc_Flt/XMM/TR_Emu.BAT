:trn.bat                
@echo off
tasm  emu.asm
if exist emu.obj goto lnk
echo �訡�� � 䠩�� emu.asm
goto end
:lnk
echo ��������� �ᯥ譮 �����襭�
tlink emu.obj
if exist emu.exe goto pse
echo �訡�� � 䠩�� fmul.obj
goto end
:pse
echo ���������� �믮����� �ᯥ譮
del emu.obj
del emu.map
:end
pause
exit