:trn.bat                
@echo off
tasm /zi SNG_FPU.asm
if exist SNG_FPU.obj goto lnk
echo �訡�� � 䠩�� SNG_FPU.asm
goto end
:lnk
echo ��������� �ᯥ譮 �����襭�
pause
tlink /v SNG_FPU.obj
if exist SNG_FPU.exe goto pse
echo �訡�� � 䠩�� SNG_FPU.obj
goto end
:pse
echo ���������� �믮����� �ᯥ譮
del SNG_FPU.obj
del SNG_FPU.map
:end
pause
