:Presentation Sing.bat		      
@echo off
:���� ����������
tasm   Sin_Fpu.asm
if exist  Sin_Fpu.obj goto lnk
echo Error file  Sin_Fpu.asm
goto end
:lnk
echo Compilation termination
pause
:���� ����������
tlink Sin_Fpu.obj
if exist Sin_Fpu.exe goto pse
echo Error file  Sin_Fpu.obj
goto end
:pse
echo Make termination
pause
del   Sin_Fpu.obj
del   Sin_Fpu.map
echo All Ready
pause
:���� ������ ������������ �����
cls
 Sin_Fpu pause
pause
:end
exit
