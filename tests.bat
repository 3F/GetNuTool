@echo off

:: run tests by default

setlocal
    for /F "tokens=*" %%i in (.version) do set appversion=%%i

    if exist "core\gnt.core\" (

        set "bdir=..\shell\batch\"

    ) else if exist "bin\Release\" (

        set "bdir=..\bin\Release\"

    ) else goto buildError

    cd tests
    call _run gnt %bdir%
endlocal

exit /B 0

:buildError
    echo. Tests cannot be started: Check your build first. >&2
exit /B 1