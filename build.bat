@echo off

call .tools\hMSBuild -GetNuTool /p:wpath="%cd%" /p:ngconfig=".tools\packages.config" /nologo /v:m /m:7 & (
    if [%~1]==[#] exit /B 0
)

set "reltype=%~1" & if not defined reltype set reltype=Release
call packages\vsSolutionBuildEvent\cim.cmd /v:m /m:7 /p:Configuration=%reltype% || (
    echo. Failed 1>&2
    exit /B 1
)
exit /B 0