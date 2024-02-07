@echo off
:: Copyright (c) 2015  Denis Kuzmin <x-3F@outlook.com> github/3F
:: Part of https://github.com/3F/GetNuTool

if "%~1"=="" echo Empty function name & exit /B 1
call :%~1 %2 %3 %4 %5 %6 %7 %8 %9 & exit /B !ERRORLEVEL!

:initAppVersion
    for /F "tokens=*" %%i in (..\.version) do set appversion=%%i
exit /B 0

:invoke
    ::  (1) - Command.
    ::  (2) - Input arguments inside "..." via variable.
    :: &[3] - Return code.
    :: !!0+ - Error code from (1)

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

:execute
    ::  (1) - Command.
    :: !!0+ - Error code from (1)

    call :invoke "%~1" nul retcode
exit /B !retcode!

:startTest
    ::  (1) - Input arguments to core inside "...". Use ` sign to apply " double quotes inside "...".
    ::  [2] - Expected return code. Default, 0.
    :: !!1  - Error code 1 if app's error code is not equal [2] as expected.

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

    call :invoke "%wdir%%exec%" cmd retcode

    if "!retcode!" NEQ "%exCode%" call :failTest & exit /B 1
exit /B 0

:completeTest
    echo [Passed]
exit /B 0

:failTest
    set /a "failedTotal+=1"
    call :printStream failed
exit /B 0

:printStream
    for /L %%i in (0,1,!msgIdx!) do echo (%%i) *%~1: !msg[%%i]!
exit /B 0

:contains
    ::  (1) - input string via variable
    ::  (2) - substring to check
    :: &(3) - result, 1 if found.

    set "input=!%~1!"

    if "%~2"=="" if "!input!"=="" set /a %3=1 & exit /B 0
    if "!input!"=="" if not "%~2"=="" set /a %3=0 & exit /B 0

    set "cmp=!input:%~2=!"

    if .!cmp! NEQ .!input! ( set /a %3=1 ) else set /a %3=0
exit /B 0

:msgAt
    ::  (1) - index at msg
    ::  (2) - substring to check
    :: &(3) - result, 1 if found.

    set /a %3=0

    if "%~1"=="" exit /B 0
    if %msgIdx% LSS %~1 exit /B 0
    if %~1 LSS 0 exit /B 0

    call :contains msg[%~1] "%~2" n & set /a %3=!n!
exit /B 0

:msgOrFailAt
    ::  (1) - index at msg
    ::  (2) - substring to check
    :: !!1  - Error code 1 if the message is not found at the specified index.

    call :msgAt %~1 "%~2" n & if .!n! NEQ .1 call :failTest & exit /B 1
exit /B 0

:checkFs
    ::  (1) - Path to directory that must be available.
    ::  (2) - Path to the file that must exist.
    :: !!1  - Error code 1 if the directory or file does not exist.

    if not exist "%~1" call :failTest & exit /B 1
    if not exist "%~1\%~2" call :failTest & exit /B 1
exit /B 0

:checkFsBase
    ::  (1) - Path to directory that must be available.
    ::  (2) - Path to the file that must exist.
    :: !!1  - Error code 1 if the directory or file does not exist.

    call :checkFs "%basePkgDir%%~1" "%~2" || exit /B 1
exit /B 0

:checkFsNo
    ::  (1) - Path to the file or directory that must NOT exist.
    :: !!1  - Error code 1 if the specified path exists.

    if exist "%~1" call :failTest & exit /B 1
exit /B 0

:checkFsBaseNo
    ::  (1) - Path to the file or directory that must NOT exist.
    :: !!1  - Error code 1 if the specified path exists.

    call :checkFsNo "%basePkgDir%%~1" || exit /B 1
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
    ::  (1) - Nupkg file name.
    :: !!1  - Error code 1 if the input (1) does not exist.

    if not exist "%~1" call :failTest & exit /B 1
exit /B 0

:findInStream
    ::  (1) - substring to check
    :: &(2) - result, 1 if found.

    for /L %%i in (0,1,!msgIdx!) do (
        call :msgAt %%i "%~1" n & if .!n! EQU .1 (
            set /a %2=1
            exit /B 0
        )
    )
    set /a %2=0
exit /B 0

:failIfInStream
    ::  (1) - substring to check
    :: !!1  - Error code 1 if the input (1) was not found.

    call :findInStream "%~1" n & if .!n! EQU .1 call :failTest & exit /B 1
exit /B 0

:print
    :: (1) - Input string.

    echo.[ %TIME% ] %~1
exit /B 0

:isNotEmptyOrWhitespace
    :: &(1) - Input variable.
    :: !!1  - Error code 1 if &(1) is empty or contains only whitespace characters.

    set "_v=!%~1!"
    if not defined _v exit /B 1

    set _v=%_v: =%
    if not defined _v exit /B 1

    :: e.g. set a="" not set "a="
exit /B 0