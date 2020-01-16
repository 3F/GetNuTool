@echo off

if not exist "%~dp0\gnt.bat" goto err
echo SHA-1 test has been started.

set msbuild="%~dp0\..\netmsb.bat"

setlocal
    cd "%~dp0"
    call ".\gnt" -unpack || goto err
endlocal
call %msbuild% "%~dp0\sha1_comparer.targets" /p:core1="%~dp0\gnt.min.core" /p:core2="%~dp0\gnt.core" /nologo /v:m /m:4 || goto err

exit /B 0

:err

echo Failed SHA-1. 1>&2
exit /B 1