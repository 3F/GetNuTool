@echo off
setlocal enableDelayedExpansion

:: Part of GetNuTool - https://github.com/3F/GetNuTool
:: :: If you need a common MSBuild-helper, look here - https://github.com/3F/hMSBuild

:: -

for %%v in (4.0, 3.5, 2.0) do (
    for /F "usebackq tokens=2* skip=2" %%a in (
        `reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\MSBuild\ToolsVersions\%%v" /v MSBuildToolsPath 2^> nul`
    ) do if exist %%b (
    
        set msbuildexe=%%b\MSBuild.exe
        goto found

    )
)
echo MSBuild was not found. 1>&2
exit /B 2

:found

"!msbuildexe!" %*

exit /B 0
