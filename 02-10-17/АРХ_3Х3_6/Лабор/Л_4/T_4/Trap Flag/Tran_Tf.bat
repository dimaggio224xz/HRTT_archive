:Tran_tf.bat              
@echo off
:���� ����������
tasm  /zi tf.asm
if exist  tf.obj goto lnk
echo Error file  tf.asm
goto end
:lnk
echo Compilation termination
pause
:���� ����������
tlink /v  tf.obj
if exist  tf.exe goto pse
echo Error file  tf.obj
goto end
:pse
echo Make termination
pause
del    tf.obj
del   tf.map
echo All Ready
pause
:���������� ������������ �����
rem  tf
pause 
 td tf
:end
