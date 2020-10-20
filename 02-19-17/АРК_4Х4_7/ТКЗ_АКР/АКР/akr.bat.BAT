:Assembler.bat                
@echo off       
:Этап компіляції
tasm /zi  akr.asm
if exist akr.obj goto lnk_1
echo Error file akr.asm
goto end_1
:lnk_1
pause
tlink /v akr.obj
if exist akr.exe goto pse_1
echo Error file akr.obj
goto end_1
:pse_1
pause
del  akr.map
del  akr.obj
cls
td akr
:end_1
pause
exit
