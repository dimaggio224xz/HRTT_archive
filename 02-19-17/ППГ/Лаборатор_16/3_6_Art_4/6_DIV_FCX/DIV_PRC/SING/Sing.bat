:Presentation Sing.bat		      
@echo off
:���� ����������
tasm  Sing.asm
if exist  Sing.obj goto lnk
echo Error file  Sing.asm
goto end
:lnk
echo Compilation termination
pause
:���� ����������
tlink Sing.obj
if exist Sing.exe goto pse
echo Error file  Sing.obj
goto end
:pse
echo Make termination
pause
del   Sing.obj
del   Sing.map
echo All Ready
pause
:���� ������ ������������ �����
cls
 Sing
 pause
del   Sing.exe
:end
pause
exit
