:trn.bat                
@echo off
tasm /zi fmul.asm
if exist fmul.obj goto lnk
echo �訡�� � 䠩�� fmul.asm
goto end
:lnk
echo ��������� �ᯥ譮 �����襭�
pause
tlink /v fmul.obj
if exist fmul.exe goto pse
echo �訡�� � 䠩�� fmul.obj
goto end
:pse
echo ���������� �믮����� �ᯥ譮
fmul
pause
del fmul.obj
del fmul.map
:end
