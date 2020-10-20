:Assembler.bat                
@echo off       
:Этап компіляції
tasm /l /zi akr.asm
if exist akr.obj goto lnk
echo Error file akr.asm
goto end
:lnk
echo Not error file akr.asm
echo ____________________________________________________________________________
:Этап компоновки
tlink  /3 /v akr.obj
if exist akr.exe goto pse
echo Error file test.obj
goto end
:pse
echo Make termination
echo ____________________________________________________________________________
echo                All Ready
echo ____________________________________________________________________________
pause
:end
:td akr
pause
del  akr.lst
del akr.obj
cls
start akr
pause
exit


