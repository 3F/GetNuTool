@echo off
:: GetNuTool - Executable version
:: Copyright (c) 2015-2024  Denis Kuzmin <x-3F@outlook.com> github/3F
:: https://github.com/3F/GetNuTool

set gntcore=gnt.core
set $tpl.corevar$="%temp%\%gntcore%$core.version$%random%%random%"

set /a ERROR_FILE_NOT_FOUND=2
set /a ERROR_CALL_NOT_IMPLEMENTED=120

:: Usage:
::  gnt Package
::  gnt "Paclage1;Package2"
::  gnt <core_arguments>
::  gnt <shell_arguments>

if "%~1"=="-unpack" goto unpack

set args=%*
setlocal enableDelayedExpansion

set "instance=%engine%"
if defined instance goto found

:: Find engine via engine.cmd stub or hMSBuild.bat script https://github.com/3F/hMSBuild

set script=hMSBuild
if exist engine.cmd set script=engine.cmd

for /F "tokens=*" %%i in ('%script% -only-path 2^>^&1 ^&call echo %%^^ERRORLEVEL%%') do 2>nul (
    if not defined instance ( set instance="%%i" ) else set /a EXIT_CODE=%%i
)

if "%EXIT_CODE%"=="0" if exist !instance! goto found

:: Find engine via system records

for %%v in (4.0, 14.0, 12.0, 3.5, 2.0) do (
    for /F "usebackq tokens=2* skip=2" %%a in (
        `reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\MSBuild\ToolsVersions\%%v" /v MSBuildToolsPath 2^> nul`
    ) do if exist %%b (

        set instance="%%~b\MSBuild.exe"
        if exist !instance! (

            if not "%%v"=="3.5" if not "%%v"=="2.0" goto found

            echo Override engine or contact for legacy support %%v
            exit /B %ERROR_CALL_NOT_IMPLEMENTED%
        )
    )
)

echo Engine is not found. Try with hMSBuild 1>&2
exit /B %ERROR_FILE_NOT_FOUND%

:found
set con=/noconlog
if "%debug%"=="true" set con=/v:q

setlocal disableDelayedExpansion
call :core
endlocal
call :unset "/help" "-help" "/h" "-h" "/?" "-?"

call !instance! %$tpl.corevar$% /nologo %con% /p:wpath="%cd%/" /m:7 %args%
set EXIT_CODE=%ERRORLEVEL%

del /Q/F %$tpl.corevar$%
exit /B %EXIT_CODE%

:unpack
set $tpl.corevar$="%cd%\%gntcore%"
echo Generating a minified at %cd%\...

:core
<nul set/P="">%$tpl.corevar$%&$gnt.core.logic$
exit /B 0

:unset
if defined args set args=!args:%~1=!
if not "%~2"=="" shift & goto unset
exit /B 0