::! github.com/3F/GetNuTool
::! (c) Denis Kuzmin <x-3F@outlook.com>

@echo off & echo Incomplete script. Compile it first using build.bat: github.com/3F/GetNuTool >&2 & exit /B 1

set gntcore=gnt.core
set $tpl.corevar$="%temp%\%gntcore%$core.version$%random%%random%"

set /a ERROR_FILE_NOT_FOUND=2
set /a ERROR_CALL_NOT_IMPLEMENTED=120

:: Syntax:
::  gnt Package
::  gnt "Paclage1;Package2"
::  gnt +Package
::  gnt +"Paclage1;Package2"
::  gnt <core_arguments>
::  gnt <shell_arguments>

setlocal enableDelayedExpansion
set args=%*

:: NOTE `"` can be compared safely when only delayed variables
set first=%~1

if "!first!"=="-unpack" goto unpack

:: make sure this is not a single " (double quote)
if "!first!"=="" call :trimArgs

set "checkH=!args!"
call :unset "/help" "-help" "/h" "-h" "/?" "-?"
if "!checkH!" NEQ "!args!" set args=~GetNuTool/$core.version$ /p:use=?;info=no

:: NOTE !args:~0,1! should return literally "~0,1" as value when empty
set carg="!args:~0,1!"
if !carg!=="+" call :trimArgs !args:~1! /t:install
if !carg!=="*" call :trimArgs !args:~1! /t:run
if !carg!=="~" call :trimArgs !args:~1! /t:touch
if !carg!=="-" exit /B %ERROR_CALL_NOT_IMPLEMENTED%
if !carg! NEQ "/" set args=/p:ngpackages=!args!

set "instance="
:: Find the engine via hMSBuild.cmd stub or hMSBuild.bat script https://github.com/3F/hMSBuild

for /F "tokens=*" %%i in ('hMSBuild -only-path 2^>^&1') do 2>nul set instance="%%i"
if exist !instance! goto found

:: Find the engine via system records (except 3.5 and 2.0 /F-40, 141)

for %%v in (4.0, 14.0, 12.0) do (
    for /F "usebackq tokens=2* skip=2" %%a in (
        `reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\MSBuild\ToolsVersions\%%v" /v MSBuildToolsPath 2^> nul`
    ) do (
        set instance="%%~b\MSBuild.exe"
        if exist !instance! goto found
    )
) ::&:

echo [x]Engine>&2
exit /B %ERROR_FILE_NOT_FOUND%

:found
    set con=/noconlog
    if "%debug%"=="true" set con=/v:q

    call :core

    call !instance! %$tpl.corevar$% /nologo /noautorsp !con! /p:wpath="%cd%/" !args!
    set EXIT_CODE=!ERRORLEVEL!

    del /Q/F %$tpl.corevar$%
exit /B !EXIT_CODE!

:unpack
set $tpl.corevar$="%cd%\%gntcore%"
echo Generating a %gntcore% at %cd%\...

:core
setlocal disableDelayedExpansion
<nul set/P="">%$tpl.corevar$%&$gnt.core.logic$
endlocal
exit /B 0

:trimArgs
    set args=%*
exit /B 0

:unset
    if defined args set args=!args:%~1=!
    if "%~2" NEQ "" shift & goto unset
exit /B 0