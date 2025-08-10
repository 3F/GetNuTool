@echo off
:: Arguments: https://github.com/3F/GetNuTool?tab=readme-ov-file#install
:: 1 tmode "path to the working directory" "path to the package"
if "%~1" LSS "1" echo Version "%~1" is not supported. 2>&1 & exit /B1

set svc.gnt="%~dp0\shell\batch\svc.gnt.bat"
set gntbat="%~dp0\shell\batch\gnt.bat"
if not exist %svc.gnt% exit /B1

set /p _version=<"%~dp0\.version"

if not defined use (
    call :copy %svc.gnt%

    :: /F-145, forced update if the readonly attr is NOT set
    call :copy %gntbat%

) else if "%use%"=="?" (
    %svc.gnt% -core syntax

) else if "%use%"=="version" (
    %svc.gnt% -version

) else if "%use%"=="version-short" (
    %svc.gnt% -version-short

) else if "%use%"=="doc" (

    if "%~2"=="install" (
        call :xcopy "%~dp0\doc\GetNuTool.%_version%.html"

    ) else if "%~2"=="run" (
        "%~dp0\doc\GetNuTool.%_version%.html"

    ) else if "%~2"=="touch" (
        call :xcopy "%~dp0\doc\GetNuTool.%_version%.html"
        "%cd%\GetNuTool.%_version%.html"
    )

) else if "%use%"=="-" (
    exit /B 0

) else (
    echo "%use%" is not supported 2>&1 & exit /B1
)

exit /B 0

:xcopy
    :: xcopy: including the readonly (/R) attr
    :: (1) input file
    xcopy %1 "%cd%\" /Y/R/V/I/Q 2>nul>nul || call :copy %1
exit /B 0

:copy
    :: copy: fail on the readonly attr
    :: (1) input file
    copy /Y/V %1 "%cd%\" 2>nul>nul || goto :error
exit /B 0

:error
exit /B 1