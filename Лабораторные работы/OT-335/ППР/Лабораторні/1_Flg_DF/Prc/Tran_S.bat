:Tran_s.bat              
@echo off
:Этап компиляции
tasm /zi s.asm
if exist s.obj goto lnk
echo Error file sum.asm
goto end
:lnk
echo Compilation termination
pause
:Этап компоновки
tlink /v s.obj
if exist s.exe goto pse
echo Error file sum.obj
goto end
:pse
echo Make termination
pause
del  s.obj
del  s.map
echo All Ready
pause
:Этапвызова загружаемого файла
s
:pause 
td s
:end
pause 