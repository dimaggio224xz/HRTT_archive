:Presentation add_tst.bat		      
@echo off
:���� ����������
tasm  /zi add_tst.asm
if exist  add_tst.obj goto lnk
echo Error file   add_tst.asm
goto end
:lnk
echo Compilation termination
pause
:���� ����������
tlink /v  add_tst.obj
if exist  add_tst.exe goto pse
echo Error file  add_tst.obj
goto end
:pse
echo Make termination
pause
del  add_tst.obj
del  add_tst.map
echo All Ready
pause
:���� ������ ������������ �����
cls
 add_tst
 pause
cls
:td add_tst
del   add_tst.exe
:end
pause
exit
