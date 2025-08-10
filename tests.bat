@echo off

:: run tests for .bat edition

setlocal
    if exist "core\gnt.core" (

        set "bdir=..\shell\batch\"
        set "gntLocalServer=..\..\"

    ) else if exist "bin\Release\" (

        set "bdir=..\bin\Release\"
        set "gntLocalServer=..\bin\Release\"

    ) else goto buildError

    cd tests
    call _run gnt %bdir%
endlocal

exit /B 0

:buildError
    echo. Tests cannot be started: Check your build first. >&2
exit /B 1