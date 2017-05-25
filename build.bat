@echo off

set msbuild=netmsb


call %msbuild% logic.targets /p:ngconfig="packages.config" /nologo /v:m /m:4 || goto err
call %msbuild% "gnt.sln" /l:"packages\vsSBE.CI.MSBuild\bin\CI.MSBuild.dll" /v:m /m:4 || goto err

exit /B 0

:err

echo. Build failed. 1>&2
exit /B 1