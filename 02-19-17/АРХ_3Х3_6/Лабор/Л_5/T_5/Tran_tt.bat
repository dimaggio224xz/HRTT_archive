:Tran_t.bat              
@echo off
:���� ����������
tasm  /? tt.asm
if exist  tt.obj goto lnk
echo Error file  tt.asm
goto end
:lnk
echo Compilation termination
pause
:���� ����������
tlink /v tt.obj
if exist  tt.exe goto pse
echo Error file  obj
goto end
:pse
echo Make termination
pause
del   tt.obj
del  tt.map
echo All Ready
pause
:���������� ������������ �����
 td  tt
:end
del    tt.exe
pause
