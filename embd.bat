::!(c) Denis Kuzmin <x-3F@outlook.com> github.com/3F

@echo off & echo Incomplete script. Compile it first using build.bat: github.com/3F/GetNuTool >&2 & exit /B 1
:: Copyright (c) 2015  Denis Kuzmin <x-3F@outlook.com> github/3F
:: Copyright (c) GetNuTool contributors https://github.com/3F/GetNuTool/graphs/contributors
:: Licensed under the MIT License (MIT).
:: See accompanying License.txt file or visit https://github.com/3F/GetNuTool

set gntcore=gnt.core
set $tpl.corevar$="%temp%\%gntcore%$core.version$%random%%random%"

set /a ERROR_FILE_NOT_FOUND=2

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
set GNT=GetNuTool/$core.version$ /p:info=no;use=
if "!checkH!" NEQ "!args!" set args=~!GNT!?

:: NOTE !args:~0,1! should return literally "~0,1" as value when empty
set carg="!args:~0,1!"
if !carg!=="+" call :trimArgsAsMode install
if !carg!=="*" call :trimArgsAsMode run
if !carg!=="~" call :trimArgsAsMode touch
if defined args if !carg! NEQ "/" if !carg! NEQ "-" set args=/p:ngpackages=!args!

set "instance="
:: Find the engine via hMSBuild.cmd stub or hMSBuild.bat script https://github.com/3F/hMSBuild

for /F "tokens=*" %%i in ('hMSBuild -only-path 2^>^&1') do 2>nul set instance="%%i"
if exist !instance! goto found

:: Find the engine via system records (except 3.5 and 2.0 /F-40, 141)

for %%v in (4.0, 14.0, 12.0) do (
    for /F "usebackq tokens=2* skip=2" %%a in (
        `reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\MSBuild\ToolsVersions\%%v" /v MSBuildToolsPath 2^>nul`
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
echo +%gntcore% %cd%\

:core
setlocal disableDelayedExpansion
<nul set/P=>%$tpl.corevar$%&$gnt.core.logic$
endlocal
exit /B 0

:trimArgs
    set args=%*
exit /B 0

:trimArgsAsMode
    call :trimArgs !args:~1!

    :: `gnt ~` (+, *, ~) aliases to itself /F-133

    :: `~DllExport`; `+"Conari;regXwild"`; ...
    if "!args:~0,1!" NEQ "/" if "!args:~0,1!" NEQ "-" if "!args!" NEQ "" set args=!args! /t:%1 & exit /B 0

    :: `~`; `~/p:use=doc`; ...
    set args=!GNT!;logo=no !args! /t:%1
exit /B 0

:unset
    if defined args set args=!args:%~1=!
    if "%~2" NEQ "" shift & goto unset
exit /B 0