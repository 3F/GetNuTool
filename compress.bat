@echo off

set msbuild=netmsb

call %msbuild% minified/.compressor /p:core="../logic.targets" /p:output="gnt.core" /nologo /v:m /m:4 %* || goto err

exit /B 0

:err

echo. Build failed. 1>&2
exit /B 1