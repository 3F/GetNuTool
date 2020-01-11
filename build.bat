@echo off

set reltype=%1
set msbuild=.\netmsb
set cim=packages\vsSolutionBuildEvent\cim.cmd

if "%reltype%"=="" (
    set reltype=Release
)

call %msbuild% logic.targets /p:ngconfig="packages.config" /nologo /v:m /m:4 || goto err
call %cim% "gnt.sln" /v:m /m:4 /p:Configuration="%reltype%" /p:Platform="Any CPU" || goto err

exit /B 0

:err

echo. Build failed. 1>&2
exit /B 1