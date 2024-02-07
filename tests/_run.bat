@echo off
:: Copyright (c) 2015  Denis Kuzmin <x-3F@outlook.com> github/3F

:: Tests. Part of https://github.com/3F/GetNuTool
:: Based on https://github.com/3F/hMSBuild

call a InitAppVersion
setlocal enableDelayedExpansion

:: path to core
set exec=%1

:: path to directory where release
set rdir=%2

call :isEmptyOrWhitespace exec _is & if [!_is!]==[1] goto errargs
call :isEmptyOrWhitespace rdir _is & if [!_is!]==[1] goto errargs

echo.
echo ------------
echo Testing
echo -------
echo.

set /a gcount=0
set /a failedTotal=0

echo. & call :print "Tests - 'keys'"
call .\keysAndLogicTests gcount failedTotal %exec% %rdir%

@REM echo. & call :print "Tests - 'diffversions'"
@REM call .\diffversions gcount failedTotal %exec% %rdir% %cfull%

echo.
echo ################
echo  [Failed] = !failedTotal!
set /a "gcount-=failedTotal"
echo  [Passed] = !gcount!
echo ################
echo.

if !failedTotal! GTR 0 goto failed
echo.
call :print "All Passed."
exit /B 0

:failed
    echo.
    echo. Tests failed. >&2
exit /B 1

:errargs
    echo.
    echo. Incorrect arguments to start tests. >&2
exit /B 1

:print
    set msgfmt=%1
    set msgfmt=!msgfmt:~0,-1!
    set msgfmt=!msgfmt:~1!
    echo.[%TIME% ] !msgfmt!
exit /B 0

:isEmptyOrWhitespace
    :: Usage: call :isEmptyOrWhitespace &input &output(1/0)
    set "_v=!%1!"

    if not defined _v endlocal & set /a %2=1 & exit /B 0

    set _v=%_v: =%
    set "_v= %_v%"
    if [^%_v:~1,1%]==[] endlocal & set /a %2=1 & exit /B 0

    endlocal & set /a %2=0
exit /B 0