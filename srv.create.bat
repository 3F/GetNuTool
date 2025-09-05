::! Copyright (c) 2015  Denis Kuzmin <x-3F@outlook.com> github/3F
::! Copyright (c) GetNuTool contributors https://github.com/3F/GetNuTool/graphs/contributors
::! Licensed under the MIT License (MIT).
::! See accompanying License.txt file or visit https://github.com/3F/GetNuTool
@echo off

if not exist GetNuTool.nuspec exit /B1
set /p _version=<"%~dp0.version"
if not defined _version exit /B1

set "tpldir=%temp%\gnt.%~nx0.%random%%random%"
set "tplnupkg=%tpldir%\GetNuTool.%_version%.nupkg"

set "dstdir=%~dp0GetNuTool"
set srv="%dstdir%\%_version%"

if exist %srv% (
    del /F/Q %srv% >nul
    rmdir /S/Q "%dstdir%" 2>nul>nul
)

call "%~dp0\shell\batch\gnt" /t:pack /p:ngin="%~dp0/";ngout="%tpldir%/" >nul
if not exist "%tplnupkg%" exit /B2

mkdir "%dstdir%" 2>nul>nul
copy /Y/B/V "%tplnupkg%" %srv% >nul

del /F/Q "%tplnupkg%" >nul
rmdir /Q "%tpldir%" >nul

echo.
echo ready... use it like:
echo    gnt ~... /p:ngserver=.\
echo.
echo Example:
echo    gnt ~/p:use=documentation /p:ngserver="%~dp0\"
