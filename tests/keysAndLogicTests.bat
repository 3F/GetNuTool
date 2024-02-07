@echo off
:: Copyright (c) 2015  Denis Kuzmin <x-3F@outlook.com> github/3F

:: Tests. Part of https://github.com/3F/GetNuTool

setlocal enableDelayedExpansion

set /a gcount=!%~1! & set /a failedTotal=!%~2!
set exec=%~3 & set wdir=%~4

:::::::::::::::::: :::::::::::::: :::::::::::::::::::::::::
:: Tests

    set "basePkgDir=packages\"
    set "artefactsDirName=_artefacts"
    set "ngpackages="
    set "logo="
    set "gntcore=gnt.core"
    set "config=%basePkgDir%packages.config"
    call a unsetFile %config%

    :: NOTE: :StartTest will use ` as "
    :: It helps to use double quotes inside double quotes " ... `args` ... "

    ::_______ ------ ______________________________________

        call a StartTest "" 1 || goto x
            call a msgOrFailAt 0 "" || goto x
            call a msgOrFailAt 1 "GetNuTool %appversion%" || goto x
            call a msgOrFailAt 2 "github/3F" || goto x
            call a msgOrFailAt 3 ".config is not found" || goto x
            call a msgOrFailAt 4 "Empty .config + ngpackages" || goto x
        call a CompleteTest
    ::_____________________________________________________


    set "logo=no"

    ::_______ ------ ______________________________________

        call a unsetPackage Fnv1a128

        call a StartTest "Fnv1a128" || goto x
            call a msgOrFailAt 1 "Fnv1a128 ... " || goto x
        call a CompleteTest
    ::_____________________________________________________


    ::_______ ------ ______________________________________

        call a StartTest "Fnv1a128" || goto x
            call a msgOrFailAt 1 "Fnv1a128 use " || goto x
            call a checkFsBase "Fnv1a128" "Fnv1a128.nuspec" || goto x
        call a CompleteTest
    ::_____________________________________________________


    ::_______ ------ ______________________________________

        call a StartTest "`Fnv1a128`" || goto x
            call a msgOrFailAt 1 "Fnv1a128 use " || goto x
            call a checkFsBase "Fnv1a128" "Fnv1a128.nuspec" || goto x
        call a CompleteTest
    ::_____________________________________________________


    ::_______ ------ ______________________________________

        set ngpackages=Fnv1a128
        call a StartTest || goto x
            call a msgOrFailAt 1 "Fnv1a128 use " || goto x
            call a checkFsBase "Fnv1a128" "Fnv1a128.nuspec" || goto x
        call a CompleteTest
        set "ngpackages="
    ::_____________________________________________________


    ::_______ ------ ______________________________________

        call a unsetPackage Conari

        call a StartTest "Conari" || goto x
            call a msgOrFailAt 1 "Conari ... " || goto x
            call a checkFsBase "Conari" "Conari.nuspec" || goto x
        call a CompleteTest
    ::_____________________________________________________


    ::_______ ------ ______________________________________

        call a StartTest "`Fnv1a128;Conari`" || goto x
            call a msgOrFailAt 1 "Fnv1a128 use " || goto x
            call a msgOrFailAt 2 "Conari use " || goto x
            call a checkFsBase "Fnv1a128" "Fnv1a128.nuspec" || goto x
            call a checkFsBase "Conari" "Conari.nuspec" || goto x
        call a CompleteTest
    ::_____________________________________________________


    ::_______ ------ ______________________________________

        call a unsetPackage regXwild.1.4.0

        call a StartTest "regXwild/1.4.0" || goto x
            call a msgOrFailAt 1 "regXwild/1.4.0 ... " || goto x
            call a checkFsBase "regXwild.1.4.0" "regXwild.nuspec" || goto x
        call a CompleteTest
    ::_____________________________________________________


    ::_______ ------ ______________________________________

        set "expNupkg=regXwild.1.4.0.nupkg"
        call a unsetNupkg %expNupkg%

        call a StartTest "/t:pack /p:ngin=%basePkgDir%regXwild.1.4.0" || goto x
            call a msgOrFailAt 1 ".nuspec use " || goto x
            call a msgOrFailAt 2 "Creating package " || goto x
            call a checkFsNupkg %expNupkg% || goto x
        call a CompleteTest

        call a unsetNupkg %expNupkg%
    ::_____________________________________________________


    ::_______ ------ ______________________________________

        call a unsetNupkg "%basePkgDir%Huid.nupkg"

        call a StartTest "Huid/1.0.0:Huid.nupkg /t:grab" || goto x
            call a msgOrFailAt 1 "Huid/1.0.0 ... " || goto x
            call a msgOrFailAt 1 "\Huid.nupkg" || goto x
            call a checkFsNupkg "%basePkgDir%Huid.nupkg" || goto x
        call a CompleteTest
    ::_____________________________________________________


    ::_______ ------ ______________________________________

        call a StartTest "/p:ngpackages=Huid/1.0.0:Huid.nupkg /t:grab" || goto x
            call a msgOrFailAt 1 "Huid.1.0.0 use " || goto x
            call a msgOrFailAt 1 "\Huid.nupkg" || goto x
            call a checkFsNupkg "%basePkgDir%Huid.nupkg" || goto x
        call a CompleteTest
    ::_____________________________________________________


    ::_______ ------ ______________________________________

        call a unsetPackage Huid.local

        call a StartTest "/p:ngpackages=:Huid.local /p:ngserver=file:///%cd%\%basePkgDir%Huid.nupkg" || goto x
            call a msgOrFailAt 1 "... %cd%\%basePkgDir%Huid.local" || goto x
            call a checkFsBase "Huid.local" "Huid.nuspec" || goto x
        call a CompleteTest
    ::_____________________________________________________


    ::_______ ------ ______________________________________

        call a unsetPackage Huid.local

        call a StartTest ":Huid.local /p:ngserver=%cd%\%basePkgDir%Huid.nupkg /p:debug=true" || goto x
            call a msgOrFailAt 1 "... " || goto x
            call a msgOrFailAt 2 "/.version" || goto x
            call a msgOrFailAt 3 "/3rd-party-notices.txt" || goto x
            call a msgOrFailAt 11 "/lib/net5.0/Huid.dll" || goto x
            call a msgOrFailAt 19 "/tools/gnt.bat" || goto x
            call a msgOrFailAt 20 "0" || goto x
            call a checkFsBase "Huid.local" "Huid.nuspec" || goto x
        call a CompleteTest
    ::_____________________________________________________


    ::_______ ------ ______________________________________

        call a unsetPackage ..\T00LS

        call a StartTest "/p:ngserver=%cd%\%basePkgDir%Huid.nupkg /p:ngpackages=: /p:ngpath=T00LS" || goto x
            call a msgOrFailAt 1 "... %cd%\T00LS" || goto x
            call a checkFs "T00LS" "Huid.nuspec" || goto x
        call a CompleteTest

        call a unsetPackage ..\T00LS
    ::_____________________________________________________


    ::_______ ------ ______________________________________

        call a unsetPackage putty.portable.0.69

        call a StartTest "/p:ngpackages=putty.portable/0.69 /p:ngserver=https://chocolatey.org/api/v2/package/" || goto x
            call a msgOrFailAt 1 "putty.portable/0.69 ... " || goto x
            call a checkFsBase "putty.portable.0.69" "putty.portable.nuspec" || goto x
        call a CompleteTest
    ::_____________________________________________________


    ::_______ ------ ______________________________________

        call a StartTest "/p:ngpackages=`Conari;Fnv1a12;LX4Cnh` /p:break=no" || goto x
            call a msgOrFailAt 1 "Conari " || goto x
            call a msgOrFailAt 2 "Fnv1a12 ... " || goto x
            call a msgOrFailAt 2 "404" || goto x
            call a msgOrFailAt 3 "LX4Cnh " || goto x
        call a CompleteTest
    ::_____________________________________________________


    ::_______ ------ ______________________________________

        call a StartTest "`Conari;Fnv1a12;LX4Cnh` /p:break=no" || goto x
            call a msgOrFailAt 1 "Conari " || goto x
            call a msgOrFailAt 2 "Fnv1a12 ... " || goto x
            call a msgOrFailAt 2 "404" || goto x
            call a msgOrFailAt 3 "LX4Cnh " || goto x
        call a CompleteTest
    ::_____________________________________________________


    ::_______ ------ ______________________________________

        call a StartTest "`Conari;Fnv1a12;LX4Cnh` /p:break=yes" 1 || goto x
            call a msgOrFailAt 1 "Conari " || goto x
            call a msgOrFailAt 2 "Fnv1a12 ... " || goto x
            call a msgOrFailAt 2 "404" || goto x
        call a CompleteTest
    ::_____________________________________________________


    ::_______ ------ ______________________________________

        echo ^<?xml version="1.0" encoding="utf-8"?^>>>%config%

        call a StartTest "/p:ngconfig=`%config%`" 1 || goto x
            call a msgOrFailAt 1 "Root element is missing" || goto x
        call a CompleteTest
    ::_____________________________________________________


    ::_______ ------ ______________________________________

        echo ^<?xml version="1.0" encoding="utf-8"?^>>%config%
        echo ^<packages^>>>%config%
        echo   ^<package id="Conari"/^>>>%config%
        echo   ^<package id="Fnv1a128" version="1.0.0"/^>>>%config%
        echo   ^<package id="LX4Cnh" version="1.1.0" output="__algorithms"/^>>>%config%
        echo ^</packages^>>>%config%

        call a StartTest "/p:ngconfig=`%config%`" || goto x
            call a msgOrFailAt 1 "Conari " || goto x
            call a msgOrFailAt 2 "Fnv1a128" || goto x
            call a msgOrFailAt 3 "LX4Cnh" || goto x
            call a msgOrFailAt 4 "0" || goto x
            call a checkFsBase "Conari" "Conari.nuspec" || goto x
            call a checkFsBase "Fnv1a128.1.0.0" "Fnv1a128.nuspec" || goto x
            call a checkFsBase "__algorithms" "LX4Cnh.nuspec" || goto x
        call a CompleteTest
    ::_____________________________________________________


    ::_______ ------ ______________________________________

        call a unsetNupkg %basePkgDir%%artefactsDirName%\Fnv1a128.1.0.0.nupkg

        call a StartTest "/t:pack /p:ngin=%basePkgDir%Fnv1a128.1.0.0 /p:ngout=%artefactsDirName% /p:debug=true" || goto x
            call a msgOrFailAt 2 "Creating package " || goto x
            call a msgOrFailAt 2 "Fnv1a128.1.0.0.nupkg" || goto x
            call a msgOrFailAt 6 "Fnv1a128.nuspec" || goto x
            call a msgOrFailAt 11 "Fnv1a128.dll" || goto x
            call a checkFs %artefactsDirName% "Fnv1a128.1.0.0.nupkg" || goto x
        call a CompleteTest
    ::_____________________________________________________


    ::_______ ------ ______________________________________

        call a unsetNupkg %basePkgDir%%artefactsDirName%\Fnv1a128.1.0.0.nupkg

        call a StartTest "/t:pack /p:ngin=Fnv1a128.1.0.0 /p:wpath=%cd%\%basePkgDir% /p:ngout=%artefactsDirName%" || goto x
            call a msgOrFailAt 1 ".nuspec " || goto x
            call a msgOrFailAt 2 "Creating package " || goto x
            call a msgOrFailAt 2 "Fnv1a128.1.0.0.nupkg" || goto x
            call a checkFsBase %artefactsDirName% "Fnv1a128.1.0.0.nupkg" || goto x
        call a CompleteTest
    ::_____________________________________________________


    ::_______ ------ ______________________________________

        :: NOTE: In original engine, the trailing backslash \ inside "..." must be escaped at least before the last double quote (i.e. \" in "...\path\"),
        :: for example, by adding a new one "...\path\\" or "...\path\/" or removed at all "...\path" or escape every backslash "dir1\\dir2\\path\\" or use the common slash "dir1/dir2/path/" instead
        call a StartTest "/t:pack /p:ngin=Fnv1a128.1.0.0 /p:wpath=`%cd%\%basePkgDir%\`" || goto x
            call a msgOrFailAt 1 ".nuspec " || goto x
            call a msgOrFailAt 2 "Creating package " || goto x
            call a msgOrFailAt 2 "Fnv1a128.1.0.0.nupkg" || goto x
            call a checkFsBase %artefactsDirName% "Fnv1a128.1.0.0.nupkg" || goto x
        call a CompleteTest
    ::_____________________________________________________


    ::_______ ------ ______________________________________

        call a StartTest "/p:wpath=%cd%\%basePkgDir%" || goto x
            call a msgOrFailAt 1 "Conari " || goto x
            call a msgOrFailAt 2 "Fnv1a128" || goto x
            call a msgOrFailAt 3 "LX4Cnh" || goto x
        call a CompleteTest
    ::_____________________________________________________


    ::_______ ------ ______________________________________

        call a unsetFile %gntcore%

        :: NOTE: sha1_comparer compares both cores when running build.bat

        call a StartTest "-unpack  " || goto x
            call a msgOrFailAt 1 "Generating a %gntcore% at " || goto x
            call a checkFs %gntcore%
        call a CompleteTest

        call a unsetFile %gntcore%
    ::_____________________________________________________


:::::::::::::::::: :::::::::::::: :::::::::::::::::::::::::
:: cleanup

    call a unsetPackage
    call a unsetFile %config%
    call a unsetDir %artefactsDirName%

::::::::::::::::::
::
:x
endlocal & set /a %1=%gcount% & set /a %2=%failedTotal%
if "!failedTotal!"=="0" exit /B 0
exit /B 1
