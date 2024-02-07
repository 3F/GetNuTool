@echo off
:: Copyright (c) 2015  Denis Kuzmin <x-3F@outlook.com> github/3F

:: Tests. Part of https://github.com/3F/GetNuTool
:: Based on https://github.com/3F/hMSBuild

call a initAppVersion
setlocal enableDelayedExpansion

:: path to executable version
set exec=%1

:: path to the directory where the release is located
set rdir=%2

call a isNotEmptyOrWhitespace exec || goto errargs
call a isNotEmptyOrWhitespace rdir || goto errargs

echo.
echo ------------
echo Testing
echo -------
echo.

set /a gcount=0 & set /a failedTotal=0

:::::::::::::::::: :::::::::::::: :::::::::::::::::::::::::
:: Tests

echo. & call a print "Tests - 'keys'"
call .\keysAndLogicTests gcount failedTotal %exec% %rdir%

@REM echo. & call a print "Tests - 'diffversions'"
@REM call .\diffversions gcount failedTotal %exec% %rdir% %cfull%

::::::::::::::::::
::
echo.
echo ################
echo  [Failed] = !failedTotal!
set /a "gcount-=failedTotal"
echo  [Passed] = !gcount!
echo ################
echo.

if !failedTotal! GTR 0 goto failed
echo.
call a print "All Passed."
exit /B 0

:failed
    echo.
    echo. Tests failed. >&2
exit /B 1

:errargs
    echo.
    echo. Incorrect arguments to start tests. >&2
exit /B 1
