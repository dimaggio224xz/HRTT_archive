:Tran_tf.bat              
@echo off
:Этап компиляции
tasm  /zi tf.asm
if exist  tf.obj goto lnk
echo Error file  tf.asm
goto end
:lnk
echo Compilation termination
pause
:Этап компоновки
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
:Этапвызова загружаемого файла
rem  tf
pause 
 td tf
:end
