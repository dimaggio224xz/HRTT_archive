:Control_Test_Assembler.bat                
@echo off
cls
echo ____________________________________________________________________________
echo                   Control_Assembler_Proect_OT-419_06_Jemets                            
echo ____________________________________________________________________________
:Этап компіляції
tasm ctx.asm
if exist ctx.obj goto lnk_1
echo Error file ctx.asm
goto end_1
:lnk_1
echo Compilation termination
echo ____________________________________________________________________________
:Этап компоновки
tlink  ctx.obj
if exist ctx.exe goto pse_1
echo Error file ctx.obj
goto end_1
:pse_1
echo Make termination
del  ctx.map
del  ctx.obj
echo ____________________________________________________________________________
echo                  All Ready
echo ____________________________________________________________________________
:end_1
ctx
pause
echo ____________________________________________________________________________
echo                 Test_Assembler_Proect_OT-419_06_Jemets                          
echo ____________________________________________________________________________
:Этап компіляції
tasm tst.asm
if exist tst.obj goto lnk_2
echo Error file tst.asm
goto end_2
:lnk_2
echo Compilation termination
echo ____________________________________________________________________________
:Этап компоновки
tlink tst.obj
if exist tst.exe goto pse_2
echo Error file tst.obj
goto end_2
:pse_2
echo Make termination
del  tst.map
del  tst.obj
echo ____________________________________________________________________________
echo                All Ready
echo ____________________________________________________________________________
:end_2
tst
pause
del  ctx.exe
del  tst.exe

