:Tran_t.bat              
@echo off
:���� ����������
tasm  /zi t.asm
if exist  t.obj goto lnk
echo Error file  t.asm
goto end
:lnk
echo Compilation termination
pause
:���� ����������
tlink /v t.obj
if exist  t.exe goto pse
echo Error file  obj
goto end
:pse
echo Make termination
pause
del    t.obj
del  t.map
echo All Ready
pause
:���������� ������������ �����
 td  t
:end
del    t.exe
pause
