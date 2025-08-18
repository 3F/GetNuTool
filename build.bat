::! Copyright (c) 2015  Denis Kuzmin <x-3F@outlook.com> github/3F
::! Copyright (c) GetNuTool contributors https://github.com/3F/GetNuTool/graphs/contributors
::! Licensed under the MIT License (MIT).
::! See accompanying License.txt file or visit https://github.com/3F/GetNuTool
@echo off

:: max 2047 or 8191 (XP+) characters
set /a packmaxline=1940

call .tools\hMSBuild -GetNuTool & if [%~1]==[#] exit /B 0

set "reltype=%~1" & if not defined reltype set reltype=Release
call packages\vsSolutionBuildEvent\cim.cmd ~x ~c %reltype% || goto err

setlocal enableDelayedExpansion
    cd tests
    call a initAppVersion Gnt
    call a execute ..\obj\gnt & call a msgOrFailAt 1 "GetNuTool %appversionGnt%" || goto err
    call a printMsgAt 1 3F "Completed as a "
endlocal
exit /B 0

:err
    echo Failed build>&2
exit /B 1