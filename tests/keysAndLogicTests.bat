@echo off
:: Copyright (c) 2015  Denis Kuzmin <x-3F@outlook.com> github/3F

:: Tests. Part of https://github.com/3F/GetNuTool

setlocal enableDelayedExpansion

set /a gcount=!%~1! & set /a failedTotal=!%~2!
set core=%~3 & set wdir=%~4

:::::::::::::::::: :::::::::::::: :::::::::::::::::::::::::
:: Tests

    set "basePkgDir=packages\"
    set "artefactsDirName=_artefacts"
    set "ngpackages="
    set "logo="
    set "gntcore=gnt.core"
    set "config=%basePkgDir%packages.config"
    call :unsetFile %config%

    :: NOTE: :StartTest will use ` as "
    :: It helps to use double quotes inside double quotes " ... `args` ... "

    ::_______ ------ ______________________________________

        call :StartTest || goto x
            call :msgOrFailAt 0 "" || goto x
            call :msgOrFailAt 1 "GetNuTool %appversion%" || goto x
            call :msgOrFailAt 2 "github/3F" || goto x
            call :msgOrFailAt 3 ".config is not found" || goto x
            call :msgOrFailAt 4 "Empty .config or ngpackages" || goto x
        call :CompleteTest
    ::_____________________________________________________


    set "logo=no"

    ::_______ ------ ______________________________________

        call :unsetPackage Fnv1a128

        call :StartTest "Fnv1a128" || goto x
            call :msgOrFailAt 1 "Fnv1a128 ... " || goto x
        call :CompleteTest
    ::_____________________________________________________


    ::_______ ------ ______________________________________

        call :StartTest "Fnv1a128" || goto x
            call :msgOrFailAt 1 "Fnv1a128 use " || goto x
            call :checkFsBase "Fnv1a128" "Fnv1a128.nuspec" || goto x
        call :CompleteTest
    ::_____________________________________________________


    ::_______ ------ ______________________________________

        call :StartTest "`Fnv1a128`" || goto x
            call :msgOrFailAt 1 "Fnv1a128 use " || goto x
            call :checkFsBase "Fnv1a128" "Fnv1a128.nuspec" || goto x
        call :CompleteTest
    ::_____________________________________________________


    ::_______ ------ ______________________________________

        set ngpackages=Fnv1a128
        call :StartTest || goto x
            call :msgOrFailAt 1 "Fnv1a128 use " || goto x
            call :checkFsBase "Fnv1a128" "Fnv1a128.nuspec" || goto x
        call :CompleteTest
        set "ngpackages="
    ::_____________________________________________________


    ::_______ ------ ______________________________________

        call :unsetPackage Conari

        call :StartTest "Conari" || goto x
            call :msgOrFailAt 1 "Conari ... " || goto x
            call :checkFsBase "Conari" "Conari.nuspec" || goto x
        call :CompleteTest
    ::_____________________________________________________


    ::_______ ------ ______________________________________

        call :StartTest "`Fnv1a128;Conari`" || goto x
            call :msgOrFailAt 1 "Fnv1a128 use " || goto x
            call :msgOrFailAt 2 "Conari use " || goto x
            call :checkFsBase "Fnv1a128" "Fnv1a128.nuspec" || goto x
            call :checkFsBase "Conari" "Conari.nuspec" || goto x
        call :CompleteTest
    ::_____________________________________________________


    ::_______ ------ ______________________________________

        call :unsetPackage regXwild.1.4.0

        call :StartTest "regXwild/1.4.0" || goto x
            call :msgOrFailAt 1 "regXwild/1.4.0 ... " || goto x
            call :checkFsBase "regXwild.1.4.0" "regXwild.nuspec" || goto x
        call :CompleteTest
    ::_____________________________________________________


    ::_______ ------ ______________________________________

        set "expNupkg=regXwild.1.4.0.nupkg"
        call :unsetNupkg %expNupkg%

        call :StartTest "/t:pack /p:ngin=%basePkgDir%regXwild.1.4.0" || goto x
            call :msgOrFailAt 1 ".nuspec use " || goto x
            call :msgOrFailAt 2 "Creating package " || goto x
            call :checkFsNupkg %expNupkg% || goto x
        call :CompleteTest

        call :unsetNupkg %expNupkg%
    ::_____________________________________________________


    ::_______ ------ ______________________________________

        call :unsetNupkg "%basePkgDir%Huid.nupkg"

        call :StartTest "Huid/1.0.0:Huid.nupkg /t:grab" || goto x
            call :msgOrFailAt 1 "Huid/1.0.0 ... " || goto x
            call :msgOrFailAt 1 "\Huid.nupkg" || goto x
            call :checkFsNupkg "%basePkgDir%Huid.nupkg" || goto x
        call :CompleteTest
    ::_____________________________________________________


    ::_______ ------ ______________________________________

        call :StartTest "/p:ngpackages=Huid/1.0.0:Huid.nupkg /t:grab" || goto x
            call :msgOrFailAt 1 "Huid.1.0.0 use " || goto x
            call :msgOrFailAt 1 "\Huid.nupkg" || goto x
            call :checkFsNupkg "%basePkgDir%Huid.nupkg" || goto x
        call :CompleteTest
    ::_____________________________________________________


    ::_______ ------ ______________________________________

        call :unsetPackage Huid.local

        call :StartTest "/p:ngpackages=:Huid.local /p:ngserver=file:///%cd%\%basePkgDir%Huid.nupkg" || goto x
            call :msgOrFailAt 1 "... %cd%\%basePkgDir%Huid.local" || goto x
            call :checkFsBase "Huid.local" "Huid.nuspec" || goto x
        call :CompleteTest
    ::_____________________________________________________


    ::_______ ------ ______________________________________

        call :unsetPackage Huid.local

        call :StartTest ":Huid.local /p:ngserver=%cd%\%basePkgDir%Huid.nupkg /p:debug=true" || goto x
            call :msgOrFailAt 1 "... " || goto x
            call :msgOrFailAt 2 "/.version" || goto x
            call :msgOrFailAt 3 "/3rd-party-notices.txt" || goto x
            call :msgOrFailAt 11 "/lib/net5.0/Huid.dll" || goto x
            call :msgOrFailAt 19 "/tools/gnt.bat" || goto x
            call :msgOrFailAt 20 "0" || goto x
            call :checkFsBase "Huid.local" "Huid.nuspec" || goto x
        call :CompleteTest
    ::_____________________________________________________


    ::_______ ------ ______________________________________

        call :unsetPackage ..\T00LS

        call :StartTest "/p:ngserver=%cd%\%basePkgDir%Huid.nupkg /p:ngpackages=: /p:ngpath=T00LS" || goto x
            call :msgOrFailAt 1 "... %cd%\T00LS" || goto x
            call :checkFs "T00LS" "Huid.nuspec" || goto x
        call :CompleteTest

        call :unsetPackage ..\T00LS
    ::_____________________________________________________


    ::_______ ------ ______________________________________

        call :unsetPackage putty.portable.0.69

        call :StartTest "/p:ngpackages=putty.portable/0.69 /p:ngserver=https://chocolatey.org/api/v2/package/" || goto x
            call :msgOrFailAt 1 "putty.portable/0.69 ... " || goto x
            call :checkFsBase "putty.portable.0.69" "putty.portable.nuspec" || goto x
        call :CompleteTest
    ::_____________________________________________________


    ::_______ ------ ______________________________________

        call :StartTest "/p:ngpackages=`Conari;Fnv1a12;LX4Cnh` /p:break=no" || goto x
            call :msgOrFailAt 1 "Conari " || goto x
            call :msgOrFailAt 2 "Fnv1a12 ... " || goto x
            call :msgOrFailAt 2 "404" || goto x
            call :msgOrFailAt 3 "LX4Cnh " || goto x
        call :CompleteTest
    ::_____________________________________________________


    ::_______ ------ ______________________________________

        call :StartTest "`Conari;Fnv1a12;LX4Cnh` /p:break=no" || goto x
            call :msgOrFailAt 1 "Conari " || goto x
            call :msgOrFailAt 2 "Fnv1a12 ... " || goto x
            call :msgOrFailAt 2 "404" || goto x
            call :msgOrFailAt 3 "LX4Cnh " || goto x
        call :CompleteTest
    ::_____________________________________________________


    ::_______ ------ ______________________________________

        call :StartTest "`Conari;Fnv1a12;LX4Cnh` /p:break=yes" || goto x
            call :msgOrFailAt 1 "Conari " || goto x
            call :msgOrFailAt 2 "Fnv1a12 ... " || goto x
            call :msgOrFailAt 2 "404" || goto x
            call :msgOrFailAt 3 "0" || goto x
        call :CompleteTest
    ::_____________________________________________________


    ::_______ ------ ______________________________________

        echo ^<?xml version="1.0" encoding="utf-8"?^>>%config%
        echo ^<packages^>>>%config%
        echo   ^<package id="Conari"/^>>>%config%
        echo   ^<package id="Fnv1a128" version="1.0.0"/^>>>%config%
        echo   ^<package id="LX4Cnh" version="1.1.0" output="__algorithms"/^>>>%config%
        echo ^</packages^>>>%config%

        call :StartTest "/p:ngconfig=`%config%`" || goto x
            call :msgOrFailAt 1 "Conari " || goto x
            call :msgOrFailAt 2 "Fnv1a128" || goto x
            call :msgOrFailAt 3 "LX4Cnh" || goto x
            call :msgOrFailAt 4 "0" || goto x
            call :checkFsBase "Conari" "Conari.nuspec" || goto x
            call :checkFsBase "Fnv1a128.1.0.0" "Fnv1a128.nuspec" || goto x
            call :checkFsBase "__algorithms" "LX4Cnh.nuspec" || goto x
        call :CompleteTest
    ::_____________________________________________________


    ::_______ ------ ______________________________________

        call :unsetNupkg %basePkgDir%%artefactsDirName%\Fnv1a128.1.0.0.nupkg

        call :StartTest "/t:pack /p:ngin=%basePkgDir%Fnv1a128.1.0.0 /p:ngout=%artefactsDirName% /p:debug=true" || goto x
            call :msgOrFailAt 2 "Creating package " || goto x
            call :msgOrFailAt 2 "Fnv1a128.1.0.0.nupkg" || goto x
            call :msgOrFailAt 6 "Fnv1a128.nuspec" || goto x
            call :msgOrFailAt 11 "Fnv1a128.dll" || goto x
            call :msgOrFailAt 21 "0" || goto x
            call :checkFs %artefactsDirName% "Fnv1a128.1.0.0.nupkg" || goto x
        call :CompleteTest
    ::_____________________________________________________


    ::_______ ------ ______________________________________

        call :unsetNupkg %basePkgDir%%artefactsDirName%\Fnv1a128.1.0.0.nupkg

        call :StartTest "/t:pack /p:ngin=Fnv1a128.1.0.0 /p:wpath=%cd%\%basePkgDir% /p:ngout=%artefactsDirName%" || goto x
            call :msgOrFailAt 1 ".nuspec " || goto x
            call :msgOrFailAt 2 "Creating package " || goto x
            call :msgOrFailAt 2 "Fnv1a128.1.0.0.nupkg" || goto x
            call :msgOrFailAt 3 "0" || goto x
            call :checkFsBase %artefactsDirName% "Fnv1a128.1.0.0.nupkg" || goto x
        call :CompleteTest
    ::_____________________________________________________


    ::_______ ------ ______________________________________

        :: NOTE: In original engine, the trailing backslash \ inside "..." must be escaped at least before the last double quote (i.e. \" in "...\path\"),
        :: for example, by adding a new one "...\path\\" or "...\path\/" or removed at all "...\path" or escape every backslash "dir1\\dir2\\path\\" or use the common slash "dir1/dir2/path/" instead
        call :StartTest "/t:pack /p:ngin=Fnv1a128.1.0.0 /p:wpath=`%cd%\%basePkgDir%\`" || goto x
            call :msgOrFailAt 1 ".nuspec " || goto x
            call :msgOrFailAt 2 "Creating package " || goto x
            call :msgOrFailAt 2 "Fnv1a128.1.0.0.nupkg" || goto x
            call :msgOrFailAt 3 "0" || goto x
            call :checkFsBase %artefactsDirName% "Fnv1a128.1.0.0.nupkg" || goto x
        call :CompleteTest
    ::_____________________________________________________


    ::_______ ------ ______________________________________

        call :StartTest "/p:wpath=%cd%\%basePkgDir%" || goto x
            call :msgOrFailAt 1 "Conari " || goto x
            call :msgOrFailAt 2 "Fnv1a128" || goto x
            call :msgOrFailAt 3 "LX4Cnh" || goto x
            call :msgOrFailAt 4 "0" || goto x
        call :CompleteTest
    ::_____________________________________________________


    ::_______ ------ ______________________________________

        call :unsetFile %gntcore%

        :: NOTE: sha1_comparer compares both cores when running build.bat

        call :StartTest "-unpack  " || goto x
            call :msgOrFailAt 1 "Generating a %gntcore% at " || goto x
            call :msgOrFailAt 2 "0" || goto x
            call :checkFs %gntcore%
        call :CompleteTest

        call :unsetFile %gntcore%
    ::_____________________________________________________


:::::::::::::::::: :::::::::::::: :::::::::::::::::::::::::
:: cleanup

    call :unsetPackage
    call :unsetFile %config%
    call :unsetDir %artefactsDirName%

::::::::::::::::::
::
:x
endlocal & set /a %1=%gcount% & set /a %2=%failedTotal%
if "!failedTotal!"=="0" exit /B 0
exit /B 1

:StartTest
:: (1) - Input arguments to core inside "...". Use ` sign to apply " double quotes inside "...".
:: [2] - Expected return code. Default, 0.

    set "cmd=%~1"
    if "%~2"=="" ( set /a exCode=0 ) else set /a exCode=%~2

    if "!cmd!" NEQ "" set cmd=!cmd:`="!

    set /a gcount+=1
    echo.
    echo - - - - - - - - - - - -
    echo Test #%gcount% @ %TIME%
    echo - - - - - - - - - - - -
    echo keys: !cmd!
    echo.

    :: NOTE: Use delayed !cmd! instead of %cmd% inside `for /F` due to
    :: `=` (equal sign, which cannot be escaped as `^=` when runtime evaluation %cmd%)

    set /a msgIdx=0
    for /F "tokens=*" %%i in ('%wdir%%core% !cmd! 2^>^&1 ^&call echo %%^^ERRORLEVEL%%') do 2>nul (
        set /a msgIdx+=1
        set msg[!msgIdx!]=%%i
    )

    if "!msg[%msgIdx%]!" NEQ "%exCode%" call :FailTest & exit /B 1
exit /B 0

:CompleteTest
    echo [Passed]
exit /B 0

:FailTest
    set /a "failedTotal+=1"
    call :printStream failed
exit /B 0

:printStream
    for /L %%i in (0,1,!msgIdx!) do echo (%%i) *%~1: !msg[%%i]!
exit /B 0

:contains
    :: (1)  - input string via variable
    :: (2)  - substring to check
    :: &(3) - result, 1 if found.

    set input=!%~1!

    if "%~2"=="" if "!input!"=="" set /a %3=1 & exit /B 0
    if "!input!"=="" if not "%~2"=="" set /a %3=0 & exit /B 0

    set substr=%~2
    set cmp=!input:%~2=!

    if .!cmp! NEQ .!input! ( set /a %3=1 ) else set /a %3=0
exit /B 0

:msgAt
    :: (1)  - index at msg
    :: (2)  - substring to check
    :: &(3) - result, 1 if found.

    set /a %3=0

    if "%~1"=="" exit /B 0
    if %msgIdx% LSS %~1 exit /B 0
    if %~1 LSS 0 exit /B 0

    call :contains msg[%~1] "%~2" n & set /a %3=!n!
exit /B 0

:msgOrFailAt
    :: (1)  - index at msg
    :: (2)  - substring to check

    call :msgAt %~1 "%~2" n & if .!n! NEQ .1 call :FailTest & exit /B 1
exit /B 0

:checkFs
    :: (1) - Path to directory that must be available.
    :: (2) - Path to the file that must exist.

    if not exist "%~1" call :FailTest & exit /B 1
    if not exist "%~1\%~2" call :FailTest & exit /B 1
exit /B 0

:checkFsBase
    :: (1) - Path to directory that must be available.
    :: (2) - Path to the file that must exist.

    call :checkFs "%basePkgDir%%~1" "%~2" || exit /B 1
exit /B 0

:unsetDir
    :: (1) - Path to directory.
    rmdir /S/Q "%~1" 2>nul
exit /B 0

:unsetPackage
    :: (1) - Package directory.
    call :unsetDir "%basePkgDir%%~1"
exit /B 0

:unsetFile
    :: (1) - File name.
    del /Q "%~1" 2>nul
exit /B 0

:unsetNupkg
    :: (1) - Nupkg file name.
    call :unsetFile "%~1"
exit /B 0

:checkFsNupkg
    :: (1) - Nupkg file name.
    if not exist "%~1" call :FailTest & exit /B 1
exit /B 0
