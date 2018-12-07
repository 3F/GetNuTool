@echo off
:: GetNuTool via batch
:: Copyright (c) 2015-2018  Denis Kuzmin [ entry.reg@gmail.com ]
:: https://github.com/3F/GetNuTool

set gntcore=gnt.core

for %%v in (4.0, 14.0, 12.0, 3.5, 2.0) do (
    for /F "usebackq tokens=2* skip=2" %%a in (
        `reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\MSBuild\ToolsVersions\%%v" /v MSBuildToolsPath 2^> nul`
    ) do if exist %%b (
        set msbuildexe="%%b\MSBuild.exe"
        goto found
    )
)

echo MSBuild was not found. Try: "full_path_to_msbuild.exe" %gntcore% arguments` 1>&2
exit /B 2

:found

:: echo MSBuild Tools: %msbuildexe%

%msbuildexe% %gntcore% /nologo /v:m /m:4 %*
REM /noconlog

exit /B %ERRORLEVEL%