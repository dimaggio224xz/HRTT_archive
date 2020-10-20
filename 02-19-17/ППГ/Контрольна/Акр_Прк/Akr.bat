:Tran_s.bat              
@echo off
:Этап компиляции
tasm /zi akr.asm
if exist akr.obj goto lnk
echo Error file akr.asm
goto end
:lnk
echo Compilation termination
pause
:Этап компоновки
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
:Этапвызова загружаемого файла
akr
pause 
td akr
:end
pause 