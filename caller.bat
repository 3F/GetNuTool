@echo off
:: GetNuTool /wrapper/batch edition
:: Copyright (c) 2015-2024  Denis Kuzmin <x-3F@outlook.com> github/3F
:: https://github.com/3F/GetNuTool

set gntcore=gnt.core
if not exist %gntcore% goto error

set /a ERROR_FILE_NOT_FOUND=2
set /a ERROR_CALL_NOT_IMPLEMENTED=120

:: Syntax:
::  gnt Package
::  gnt "Paclage1;Package2"
::  gnt <core_arguments>
::  gnt <shell_arguments>

if "%~1"=="-unpack" goto off

set args=%*
setlocal enableDelayedExpansion

:: +1 space because %first:~0,1% will return literally "~0,1" as value if it's empty
set "first=%~1 "
set key=!first:~0,1!
if "!key!" NEQ " " if !key! NEQ / set args=/p:ngpackages=!args!

set "instance=%msb.gnt.cmd%"
if defined instance goto found

:: Find engine via msb.gnt.cmd stub or hMSBuild.bat script https://github.com/3F/hMSBuild

set script=hMSBuild
if exist msb.gnt.cmd set script=msb.gnt.cmd

for /F "tokens=*" %%i in ('%script% -only-path 2^>^&1 ^&call echo %%^^ERRORLEVEL%%') do 2>nul (
    if not defined instance ( set instance="%%i" ) else set EXIT_CODE=%%i
)

if .%EXIT_CODE%==.0 if exist !instance! goto found

:: Find engine via system records

for %%v in (4.0, 14.0, 12.0, 3.5, 2.0) do (
    for /F "usebackq tokens=2* skip=2" %%a in (
        `reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\MSBuild\ToolsVersions\%%v" /v MSBuildToolsPath 2^> nul`
    ) do if exist %%b (

        set instance="%%~b\MSBuild.exe"
        if exist !instance! (

            if %%v NEQ 3.5 if %%v NEQ 2.0 goto found

            echo Override engine or contact for legacy support %%v
            exit /B %ERROR_CALL_NOT_IMPLEMENTED%
        )
    )
)

:error
    echo Engine or %gntcore% is not found. >&2
    echo Try the full version or call it manually: msbuild %gntcore% ... >&2
exit /B %ERROR_FILE_NOT_FOUND%

:off
    echo This feature is disabled in current version >&2
exit /B %ERROR_CALL_NOT_IMPLEMENTED%

:found
    set con=/noconlog
    if "%debug%"=="true" set con=/v:q

    call :unset "/help" "-help" "/h" "-h" "/?" "-?"

    call !instance! %gntcore% /nologo /noautorsp !con! /p:wpath="%cd%/" !args!
exit /B !ERRORLEVEL!

:unset
    if defined args set args=!args:%~1=!
    if "%~2" NEQ "" shift & goto unset
exit /B 0