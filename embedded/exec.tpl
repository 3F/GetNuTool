@echo off
:: GetNuTool - Executable version
:: Copyright (c) 2015-2017  Denis Kuzmin [ entry.reg@gmail.com ]
:: https://github.com/3F/GetNuTool

set gntcore=gnt.core
set $tpl.corevar$="%temp%\%random%%random%%gntcore%"

set args=%* 
set a=%args:~0,30%
set a=%a:"=%

if "%a:~0,8%"=="-unpack " goto unpack
if "%a:~0,9%"=="-msbuild " goto ufound

for %%v in (4.0, 14.0, 12.0, 3.5, 2.0) do (
    for /F "usebackq tokens=2* skip=2" %%a in (
        `reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\MSBuild\ToolsVersions\%%v" /v MSBuildToolsPath 2^> nul`
    ) do if exist %%b (
        set msbuildexe="%%b\MSBuild.exe"
        goto found
    )
)
echo MSBuild was not found, try: gnt -msbuild "fullpath" args 1>&2
exit /B 2

:ufound
call :popa %1
shift
set msbuildexe=%1
call :popa %1

:found
call :core
%msbuildexe% %$tpl.corevar$% /nologo /p:wpath="%~dp0/" /v:m %args%
del /Q/F %$tpl.corevar$%
exit /B 0

:popa
call set args=%%args:%1 ^=%%
exit /B 0

:unpack
set $tpl.corevar$="%~dp0\%gntcore%"
echo Generate minified version in %$tpl.corevar$% ...

:core
<nul set /P ="">%$tpl.corevar$%
$gnt.core.logic$

exit /B 0