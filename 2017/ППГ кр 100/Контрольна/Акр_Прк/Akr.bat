:Tran_s.bat              
@echo off
:���� ����������
tasm /zi akr.asm
if exist akr.obj goto lnk
echo Error file akr.asm
goto end
:lnk
echo Compilation termination
pause
:���� ����������
tlink /v akr.obj
if exist akr.exe goto pse
echo Error file akr.obj
goto end
:pse
echo Make termination
pause
del akr.obj
del  akr.map
echo All Ready
pause
:���������� ������������ �����
akr
pause 
td akr
:end
pause 