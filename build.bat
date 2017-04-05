@echo off

set msbuild=msbuild.bat


call %msbuild% logic.targets /p:ngconfig="packages.config" /nologo /v:m /m:4 || goto err
call %msbuild% -notamd64 "gnt.sln" /l:"packages\vsSBE.CI.MSBuild\bin\CI.MSBuild.dll" /v:m /m:4

goto exit

:err

echo. Build failed. 1>&2

:exit