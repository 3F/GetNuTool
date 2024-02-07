@echo off
:: GetNuTool - Executable version
:: Copyright (c) 2015-2024  Denis Kuzmin <x-3F@outlook.com> github/3F
:: https://github.com/3F/GetNuTool

set gntcore=gnt.core
set $tpl.corevar$="%temp%\%random%%random%%gntcore%"

if "%~1"=="-unpack" goto unpack

set args=%*

:: Escaping '^' is not identical for all cases (gnt ... vs call gnt ...).
if defined __p_call if defined args set args=%args:^^=^%

:: When ~ %args%  (disableDelayedExpansion)
:: # call gnt  ^  - ^^
:: #      gnt  ^  - ^
:: # call gnt  ^^ - ^^^^
:: #      gnt  ^^ - ^^

:: When ~ !args! and "!args!"
:: # call gnt  ^  - ^
:: #      gnt  ^  - empty
:: # call gnt  ^^ - ^^
:: #      gnt  ^^ - ^

:: Do not use: ~ "%args%" or %args%  + (enableDelayedExpansion)

set msbuildexe=%__p_msb%
if defined msbuildexe goto found

if "%~1"=="-msbuild" goto ufound

for %%v in (4.0, 14.0, 12.0, 3.5, 2.0) do (
    for /F "usebackq tokens=2* skip=2" %%a in (
        `reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\MSBuild\ToolsVersions\%%v" /v MSBuildToolsPath 2^> nul`
    ) do if exist %%b (
        set msbuildexe="%%~b\MSBuild.exe"
        goto found
    )
)
echo MSBuild was not found. Try -msbuild "fullpath" args 1>&2
exit /B 2

:ufound
shift
set msbuildexe=%1
shift

set esc=%args:!= #__b_ECL## %
setlocal enableDelayedExpansion

set esc=!esc:%%=%%%%!

:_eqp
for /F "tokens=1* delims==" %%a in ("!esc!") do (
    if "%%~b"=="" (
        call :nqa !esc!
        exit /B %ERRORLEVEL%
    )
    set esc=%%a #__b_EQ## %%b
)
goto _eqp
:nqa
shift & shift

set "args="
:_ra
set args=!args! %1
shift & if not "%~2"=="" goto _ra

set args=!args: #__b_EQ## ==!

setlocal disableDelayedExpansion
set args=%args: #__b_ECL## =!%

:found
call :core
call %msbuildexe% %$tpl.corevar$% /nologo /p:wpath="%cd%/" /v:m /m:7 %args%

set "msbuildexe="
set ret=%ERRORLEVEL%

del /Q/F %$tpl.corevar$%
exit /B %ret%

:unpack
set $tpl.corevar$="%cd%\%gntcore%"
echo Generating minified version in %$tpl.corevar$% ...

:core
<nul set /P ="">%$tpl.corevar$%
$gnt.core.logic$

exit /B 0