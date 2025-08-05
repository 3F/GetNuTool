@echo off
:: Arguments: https://github.com/3F/GetNuTool?tab=readme-ov-file#install
:: 1 tmode "path to the working directory" "path to the package"
if "%~1" LSS "1" echo Version "%~1" is not supported. 2>&1 & exit /B1

set svc.gnt="%~dp0\shell\batch\svc.gnt.bat"
if not exist %svc.gnt% exit /B1

if not defined use (
    call :copy %svc.gnt%

) else if "%use%"=="?" (
    %svc.gnt% -core syntax

) else if "%use%"=="version" (
    %svc.gnt% -version

) else if "%use%"=="version-short" (
    %svc.gnt% -version-short

) else if "%use%"=="doc" (
    call :copy "%~dp0\doc\GetNuTool.html"
    "%cd%\GetNuTool.html"

) else if "%use%"=="no" (
    exit /B 0

) else (
    echo "%use%" is not supported 2>&1 & exit /B1
)

exit /B 0


:copy
    copy /Y/V %1 "%cd%\">nul || goto :error
exit /B 0

:error
exit /B 1