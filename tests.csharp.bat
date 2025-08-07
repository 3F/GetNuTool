@echo off

set usrLogger=%1
:: e.g. --logger:AppVeyor etc.
if defined usrLogger set usrLogger=--logger:%usrLogger%

set msb=%~dp0\.tools\hMSBuild

setlocal
    cd tests\cs\

    call %msb% ~x ~c Release
    dotnet test -c Release --no-build --no-restore --test-adapter-path:. %usrLogger% GntCSharpTest
endlocal
