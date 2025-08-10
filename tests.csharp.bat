@echo off

:: run tests for C# edition

if exist "core\gnt.core" (
    set "bdir=..\shell\batch\"

) else if exist "bin\Release\" (
    set "bdir=..\bin\Release\"

) else goto buildError


set usrLogger=%1
:: e.g. --logger:AppVeyor etc.
if defined usrLogger set usrLogger=--logger:%usrLogger%

set msb=%~dp0\.tools\hMSBuild

setlocal
    cd tests\cs\

    call %msb% ~x ~c Release /t:restore /t:Build
    dotnet test -c Release --no-build --no-restore --test-adapter-path:. %usrLogger% CsEditionTest
endlocal

exit /B 0

:buildError
    echo. Tests cannot be started: Check your build first. >&2
exit /B 1