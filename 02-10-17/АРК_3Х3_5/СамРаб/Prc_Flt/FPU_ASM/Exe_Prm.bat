:Coprocessor_Assembler.bat                
@echo off
:���� ����������
tasm repres.asm
if exist repres.obj goto lnk
echo Error file repres.asm
goto end
:lnk
echo Compilation termination
pause
:���� ����������
tlink  repres.obj
if exist repres.exe goto pse
echo Error file repres.obj
goto end
:pse
echo Make termination
pause
del  repres.obj
del  repres.map
echo All Ready
pause
:���� ������ ������������ �����
cls
repres
pause
del  repres.exe
:end
pause
