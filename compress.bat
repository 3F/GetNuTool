@echo off

set msbuild=msbuild.bat

call %msbuild% minified/.compressor /p:core="../logic.targets" /p:output="gnt.core" /nologo /v:m /m:4 %* || goto err

goto exit

:err

echo. Build failed. 1>&2

:exit