::! Copyright (c) 2015  Denis Kuzmin <x-3F@outlook.com> github/3F
::! Copyright (c) GetNuTool contributors https://github.com/3F/GetNuTool/graphs/contributors
::! Licensed under the MIT License (MIT).
::! See accompanying License.txt file or visit https://github.com/3F/GetNuTool
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