:trn.bat                
@echo off
tasm /zi FPU_SNG.asm
if exist FPU_SNG.obj goto lnk
echo �訡�� � 䠩�� FPU_SNG.asm
goto end
:lnk
echo ��������� �ᯥ譮 �����襭�
pause
tlink /v FPU_SNG.obj
if exist FPU_SNG.exe goto pse
echo �訡�� � 䠩�� FPU_SIN.obj
goto end
:pse
echo ���������� �믮����� �ᯥ譮
del FPU_SNG.obj
del FPU_SNG.map
:end
pause
