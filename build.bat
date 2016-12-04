@echo off

set msbuild=msbuild.bat


call %msbuild% gnt.core /p:ngconfig="packages.config" /nologo /v:m /m:4
call "packages\vsSBE.CI.MSBuild\bin\CI.MSBuild" "gnt.sln" /v:m /m:4 

