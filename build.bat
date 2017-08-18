@echo off

set reltype=%1
set msbuild=netmsb
set cimdll=packages\vsSBE.CI.MSBuild\bin\CI.MSBuild.dll

if "%reltype%"=="" (
    set reltype=Release
)

call %msbuild% logic.targets /p:ngconfig="packages.config" /nologo /v:m /m:4 || goto err
call %msbuild% "gnt.sln" /l:"%cimdll%" /v:m /m:4 || goto err

exit /B 0

:err

echo. Build failed. 1>&2
exit /B 1