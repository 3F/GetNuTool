::! Copyright (c) 2015  Denis Kuzmin <x-3F@outlook.com> github/3F
::! Copyright (c) GetNuTool contributors https://github.com/3F/GetNuTool/graphs/contributors
::! Licensed under the MIT License (MIT).
::! See accompanying License.txt file or visit https://github.com/3F/GetNuTool
@echo off

:: Arguments: https://github.com/3F/GetNuTool?tab=readme-ov-file#touch--install--run
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
    call :doc %~2

) else if "%use%"=="documentation" (
    call :doc %~2

) else if "%use%"=="-" (
    exit /B 0

) else (
    echo "%use%" is not supported 2>&1 & exit /B1
)

exit /B 0

:doc
    :: (1) tMode
    if "%~1"=="install" (
        call :xcopy "%~dp0\doc\GetNuTool.%_version%.html"

    ) else if "%~1"=="run" (
        "%~dp0\doc\GetNuTool.%_version%.html"

    ) else if "%~1"=="touch" (
        call :xcopy "%~dp0\doc\GetNuTool.%_version%.html"
        "%cd%\GetNuTool.%_version%.html"
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