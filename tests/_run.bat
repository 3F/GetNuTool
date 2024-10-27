@echo off
:: Copyright (c) 2015  Denis Kuzmin <x-3F@outlook.com> github/3F

:: Tests. Part of https://github.com/3F/GetNuTool
:: Based on https://github.com/3F/hMSBuild

setlocal enableDelayedExpansion

:: path to executable version
set exec=%1

:: path to the directory where the release is located
set rdir=%2

call a isNotEmptyOrWhitespaceOrFail exec || exit /B1
call a isNotEmptyOrWhitespaceOrFail rdir || exit /B1

call a initAppVersion Gnt

echo.
call a cprint 0E   ----------------
call a cprint F0  "GetNuTool .bat ~"
call a cprint 0E   ----------------
echo.

if "!gcount!" LSS "1" set /a gcount=0
if "!failedTotal!" LSS "1" set /a failedTotal=0

:::::::::::::::::: :::::::::::::: :::::::::::::::::::::::::
:: Tests


    echo. & call a print "Tests - 'keys'"
    call .\keysAndLogicTests gcount failedTotal %exec% %rdir%

    @REM echo. & call a print "Tests - 'diffversions'"
    @REM call .\diffversions gcount failedTotal %exec% %rdir% %cfull%


::::::::::::::::::
::
echo.
call a cprint 0E ----------------
echo  [Failed] = !failedTotal!
set /a "gcount-=failedTotal"
echo  [Passed] = !gcount!
call a cprint 0E ----------------
echo.

if !failedTotal! GTR 0 goto failed
echo.
call a cprint 0A "All Passed."
exit /B 0

:failed
    echo.
    call a cprint 0C "Tests failed." >&2
exit /B 1
