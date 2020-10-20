:Tran_s.bat              
@echo off
:Этап компиляции
tasm /zi sjm.asm
if exist sjm.obj goto lnk
echo Error file sjm.asm
goto end
:lnk
echo Compilation termination
pause
:Этап компоновки
tlink /v sjm.obj
if exist sjm.exe goto pse
echo Error file sjm.obj
goto end
:pse
echo Make termination
pause
del  sjm.obj
del  sjm.map
echo All Ready
pause
:Этапвызова загружаемого файла
sjm
pause 
td sjm
:end
pause 