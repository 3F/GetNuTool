@echo off

set msbuild="%~dp0\..\netmsb.bat"

echo SHA-1 test has been started.

call "%~dp0\gnt" -unpack || goto err
call %msbuild% "%~dp0\sha1_comparer.targets" /p:core1="%~dp0\../minified/gnt.core" /p:core2="%~dp0\gnt.core" /nologo /v:m /m:4 || goto err

exit /B 0

:err

echo. Build failed. 1>&2
exit /B 1