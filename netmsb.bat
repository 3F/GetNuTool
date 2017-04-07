@echo off
setlocal enableDelayedExpansion

:: Part of GetNuTool - https://github.com/3F/GetNuTool
:: :: If you need a common MSBuild-helper, look here - https://github.com/3F/hMSBuild


:: cfg

:: 7z & amd64\msbuild - https://github.com/3F/vsSolutionBuildEvent/issues/38
set notamd64=1


:: -

for %%v in (4.0, 3.5, 2.0) do (
    for /F "usebackq tokens=2* skip=2" %%a in (
        `reg query "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\MSBuild\ToolsVersions\%%v" /v MSBuildToolsPath 2^> nul`
    ) do if exist %%b (
    
        set msbuildexe=%%b\MSBuild.exe
        
        if NOT "%notamd64%" == "1" (
            goto found
        )
        
        set _amd=!msbuildexe:Framework64=Framework!
        set _amd=!_amd:amd64=!
        
        if exist "!_amd!" (
            set msbuildexe=!_amd!
        )
        goto found

    )
)
echo MSBuild was not found. 1>&2
exit /B 2

:found

"!msbuildexe!" %*

exit /B 0
