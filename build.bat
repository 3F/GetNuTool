@echo off

:: max 2047 or 8191 (XP+) characters
set /a packmaxline=1940

call .tools\hMSBuild -GetNuTool /p:ngconfig=".tools\packages.config" & (
    if [%~1]==[#] exit /B 0
)

set "reltype=%~1" & if not defined reltype set reltype=Release
call packages\vsSolutionBuildEvent\cim.cmd /v:m /m:7 /p:Configuration=%reltype% || goto err

setlocal enableDelayedExpansion
    cd tests
    call a initAppVersion Gnt
    call a execute ..\obj\gnt & call a msgOrFailAt 1 "GetNuTool %appversionGnt%" || goto err
    call a printMsgAt 1 3F "Completed as a "
endlocal
exit /B 0

:err
    echo Failed build>&2
exit /B 1