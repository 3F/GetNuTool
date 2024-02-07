@echo off
:: Copyright (c) 2015  Denis Kuzmin <x-3F@outlook.com> github/3F
:: Part of https://github.com/3F/GetNuTool

if "%~1"=="" echo Empty function name & exit /B 1
call :%~1 %2 %3 %4 %5 %6 %7 %8 %9 & exit /B !ERRORLEVEL!

:InitAppVersion
    for /F "tokens=*" %%i in (..\.version) do set appversion=%%i
exit /B 0

:Invoke
    ::  (1) - Command.
    ::  (2) - Input arguments inside "..." via variable.
    :: &[3] - Return code.

    set "cmd=%~1 !%2!"

    :: NOTE: Use delayed !cmd! instead of %cmd% inside `for /F` due to
    :: `=` (equal sign, which cannot be escaped as `^=` when runtime evaluation %cmd%)

    set "cmd=!cmd! 2^>^&1 ^&call echo %%^^ERRORLEVEL%%"
    set /a msgIdx=0

    for /F "tokens=*" %%i in ('!cmd!') do 2>nul (
        set /a msgIdx+=1
        set msg[!msgIdx!]=%%i
    )

    if not "%3"=="" set %3=!msg[%msgIdx%]!
exit /B !msg[%msgIdx%]!

:Execute
    ::  (1) - Command.
    call :Invoke "%~1" nul retcode
exit /B !retcode!

:StartTest
    :: (1) - Input arguments to core inside "...". Use ` sign to apply " double quotes inside "...".
    :: [2] - Expected return code. Default, 0.

    set "cmd=%~1"
    if "%~2"=="" ( set /a exCode=0 ) else set /a exCode=%~2

    if "!cmd!" NEQ "" set cmd=!cmd:`="!

    set /a gcount+=1
    echo.
    echo - - - - - - - - - - - -
    echo Test #%gcount% @ %TIME%
    echo - - - - - - - - - - - -
    echo keys: !cmd!
    echo.

    call :Invoke "%wdir%%exec%" cmd retcode

    if "!retcode!" NEQ "%exCode%" call :FailTest & exit /B 1
exit /B 0

:CompleteTest
    echo [Passed]
exit /B 0

:FailTest
    set /a "failedTotal+=1"
    call :printStream failed
exit /B 0

:printStream
    for /L %%i in (0,1,!msgIdx!) do echo (%%i) *%~1: !msg[%%i]!
exit /B 0

:contains
    :: (1)  - input string via variable
    :: (2)  - substring to check
    :: &(3) - result, 1 if found.

    set "input=!%~1!"

    if "%~2"=="" if "!input!"=="" set /a %3=1 & exit /B 0
    if "!input!"=="" if not "%~2"=="" set /a %3=0 & exit /B 0

    set "cmp=!input:%~2=!"

    if .!cmp! NEQ .!input! ( set /a %3=1 ) else set /a %3=0
exit /B 0

:msgAt
    :: (1)  - index at msg
    :: (2)  - substring to check
    :: &(3) - result, 1 if found.

    set /a %3=0

    if "%~1"=="" exit /B 0
    if %msgIdx% LSS %~1 exit /B 0
    if %~1 LSS 0 exit /B 0

    call :contains msg[%~1] "%~2" n & set /a %3=!n!
exit /B 0

:msgOrFailAt
    :: (1)  - index at msg
    :: (2)  - substring to check

    call :msgAt %~1 "%~2" n & if .!n! NEQ .1 call :FailTest & exit /B 1
exit /B 0

:checkFs
    :: (1) - Path to directory that must be available.
    :: (2) - Path to the file that must exist.

    if not exist "%~1" call :FailTest & exit /B 1
    if not exist "%~1\%~2" call :FailTest & exit /B 1
exit /B 0

:checkFsBase
    :: (1) - Path to directory that must be available.
    :: (2) - Path to the file that must exist.

    call :checkFs "%basePkgDir%%~1" "%~2" || exit /B 1
exit /B 0

:unsetDir
    :: (1) - Path to directory.
    rmdir /S/Q "%~1" 2>nul
exit /B 0

:unsetPackage
    :: (1) - Package directory.
    call :unsetDir "%basePkgDir%%~1"
exit /B 0

:unsetFile
    :: (1) - File name.
    del /Q "%~1" 2>nul
exit /B 0

:unsetNupkg
    :: (1) - Nupkg file name.
    call :unsetFile "%~1"
exit /B 0

:checkFsNupkg
    :: (1) - Nupkg file name.
    if not exist "%~1" call :FailTest & exit /B 1
exit /B 0
