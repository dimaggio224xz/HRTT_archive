:Tran_s.bat              
@echo off
:���� ����������
tasm /zi mlu.asm
if exist mlu.obj goto lnk
echo Error file mlu.asm
goto end
:lnk
echo Compilation termination
pause
:���� ����������
tlink /v mlu.obj
if exist mlu.exe goto pse
echo Error file mlu.obj
goto end
:pse
echo Make termination
pause
del  mlu.obj
del  mlu.map
echo All Ready
pause
:���������� ������������ �����
mlu
pause 
td mlu
:end
pause 