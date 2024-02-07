@echo off
:: Copyright (c) 2015  Denis Kuzmin <x-3F@outlook.com> github/3F

:: Tests. Part of https://github.com/3F/GetNuTool

setlocal enableDelayedExpansion
call a isNotEmptyOrWhitespaceOrFail %~1 || exit /B1

set /a gcount=!%~1! & set /a failedTotal=!%~2!
set "exec=%~3" & set "wdir=%~4"

:::::::::::::::::: :::::::::::::: :::::::::::::::::::::::::
:: Tests

    set "basePkgDir=packages\"
    set "artefactsDirName=_artefacts"
    set "ngpackages="
    set "logo="
    set "gntcore=gnt.core"
    set "config=%basePkgDir%packages.config"
    call a unsetFile %config%

    :: NOTE: :startTest will use ` as "
    :: It helps to use double quotes inside double quotes " ... `args` ... "

:::::::::::::::::
    call :cleanup

    ::_______ ------ ______________________________________

        call a startTest "" 1 || goto x
            call a msgOrFailAt 0 "" || goto x

            if not defined appversionGnt call a failTest "Empty *appversionGnt" & goto x
            if not "%appversionGnt%"=="off" (
                call a msgOrFailAt 1 "GetNuTool %appversionGnt%" || goto x
            )
            call a msgOrFailAt 2 "github/3F" || goto x
            call a msgOrFailAt 3 "Empty .config + ngpackages" || goto x
        call a completeTest
    ::_____________________________________________________


    ::_______ ------ ______________________________________

        call a startTest "/p:debug=true" 1 || goto x
            call a msgOrFailAt 0 "" || goto x

            if not defined appversionGnt call a failTest "Empty *appversionGnt" & goto x
            if not "%appversionGnt%"=="off" (
                call a msgOrFailAt 1 "GetNuTool %appversionGnt%" || goto x
            )
            call a msgOrFailAt 2 "github/3F" || goto x
            call a msgOrFailAt 3 "packages.config is not found" || goto x
            call a msgOrFailAt 4 ".tools\packages.config is not found" || goto x
            call a msgOrFailAt 5 "Empty .config + ngpackages" || goto x
        call a completeTest
    ::_____________________________________________________


    set "logo=no"

    ::_______ ------ ______________________________________

        call a unsetPackage Fnv1a128

        call a startTest "Fnv1a128" || goto x
            call a msgOrFailAt 1 "Fnv1a128 ... " || goto x
            call a checkFsBaseNo "Fnv1a128/_rels/" || goto x
            call a checkFsBaseNo "Fnv1a128/package/" || goto x
            call a checkFsBaseNo "Fnv1a128/[Content_Types].xml" || goto x
        call a completeTest
    ::_____________________________________________________


    ::_______ ------ ______________________________________

        call a startTest "Fnv1a128" || goto x
            call a msgOrFailAt 1 "Fnv1a128 use " || goto x
            call a checkFsBase "Fnv1a128" "Fnv1a128.nuspec" || goto x
        call a completeTest
    ::_____________________________________________________


    ::_______ ------ ______________________________________

        call a startTest "`Fnv1a128`" || goto x
            call a msgOrFailAt 1 "Fnv1a128 use " || goto x
            call a checkFsBase "Fnv1a128" "Fnv1a128.nuspec" || goto x
        call a completeTest
    ::_____________________________________________________


    ::_______ ------ ______________________________________

        set ngpackages=Fnv1a128
        call a startTest || goto x
            call a msgOrFailAt 1 "Fnv1a128 use " || goto x
            call a checkFsBase "Fnv1a128" "Fnv1a128.nuspec" || goto x
        call a completeTest
        set "ngpackages="
    ::_____________________________________________________


    ::_______ ------ ______________________________________

        call a unsetPackage Fnv1a128.1.0.0

        call a startTest "Fnv1a128/1.0.0?cccccccccccccccccccccccccccccccccccccccc" 1 || goto x
            call a msgOrFailAt 1 "Fnv1a128/1.0.0 ... " || goto x
            call a msgOrFailAt 2 "[x]" || goto x
            call a sha1At 2 sha1Fnv1a128
            call a checkFsBaseNo "Fnv1a128.1.0.0/Fnv1a128.nuspec" || goto x
        call a completeTest
    ::_____________________________________________________


    ::_______ ------ ______________________________________

        call a startTest "Fnv1a128/1.0.0?!sha1Fnv1a128!" || goto x
            call a msgOrFailAt 1 "Fnv1a128/1.0.0 ... " || goto x
            call a msgOrFailAt 2 "!sha1Fnv1a128! ... !sha1Fnv1a128!" || goto x
            call a checkFsBase "Fnv1a128.1.0.0" "Fnv1a128.nuspec" || goto x
        call a completeTest
    ::_____________________________________________________


    ::_______ ------ ______________________________________

        call a unsetPackage Conari

        call a startTest "Conari" || goto x
            call a msgOrFailAt 1 "Conari ... " || goto x
            call a checkFsBase "Conari" "Conari.nuspec" || goto x
        call a completeTest
    ::_____________________________________________________


    ::_______ ------ ______________________________________

        call a startTest "`Fnv1a128;Conari`" || goto x
            call a msgOrFailAt 1 "Fnv1a128 use " || goto x
            call a msgOrFailAt 2 "Conari use " || goto x
            call a checkFsBase "Fnv1a128" "Fnv1a128.nuspec" || goto x
            call a checkFsBase "Conari" "Conari.nuspec" || goto x
        call a completeTest
    ::_____________________________________________________


    ::_______ ------ ______________________________________

        call a unsetPackage regXwild.1.4.0

        call a startTest "regXwild/1.4.0" || goto x
            call a msgOrFailAt 1 "regXwild/1.4.0 ... " || goto x
            call a checkFsBase "regXwild.1.4.0" "regXwild.nuspec" || goto x
        call a completeTest
    ::_____________________________________________________


    ::_______ ------ ______________________________________

        set "expNupkg=regXwild.1.4.0.nupkg"
        call a unsetNupkg %expNupkg%

        call a startTest "/t:pack /p:ngin=%basePkgDir%regXwild.1.4.0" || goto x
            call a msgOrFailAt 1 ".nuspec use " || goto x
            call a msgOrFailAt 2 "Creating package " || goto x
            call a checkFsNupkg %expNupkg% || goto x
        call a completeTest

        call a unsetNupkg %expNupkg%
    ::_____________________________________________________


    ::_______ ------ ______________________________________

        call a unsetNupkg "%basePkgDir%Huid.nupkg"

        call a startTest "Huid/1.0.0:Huid.nupkg /t:grab" || goto x
            call a msgOrFailAt 1 "Huid/1.0.0 ... " || goto x
            call a msgOrFailAt 1 "\Huid.nupkg" || goto x
            call a checkFsNupkg "%basePkgDir%Huid.nupkg" || goto x
        call a completeTest
    ::_____________________________________________________


    ::_______ ------ ______________________________________

        call a startTest "/p:ngpackages=Huid/1.0.0:Huid.nupkg /t:grab" || goto x
            call a msgOrFailAt 1 "Huid.1.0.0 use " || goto x
            call a msgOrFailAt 1 "\Huid.nupkg" || goto x
            call a checkFsNupkg "%basePkgDir%Huid.nupkg" || goto x
        call a completeTest
    ::_____________________________________________________


    ::_______ ------ ______________________________________

        call a unsetPackage Huid.local

        call a startTest "/p:ngpackages=:Huid.local /p:ngserver=file:///%cd%\%basePkgDir%Huid.nupkg" || goto x
            call a msgOrFailAt 1 "... %cd%\%basePkgDir%Huid.local" || goto x
            call a checkFsBase "Huid.local" "Huid.nuspec" || goto x
        call a completeTest
    ::_____________________________________________________


    ::_______ ------ ______________________________________

        call a unsetPackage Huid.local

        call a startTest ":Huid.local /p:ngserver=%cd%\%basePkgDir%Huid.nupkg /p:debug=true" || goto x
            call a msgOrFailAt 1 "... " || goto x
            call a msgOrFailAt 2 "/.version" || goto x
            call a msgOrFailAt 3 "/3rd-party-notices.txt" || goto x
            call a msgOrFailAt 11 "/lib/net5.0/Huid.dll" || goto x
            call a msgOrFailAt 19 "/tools/gnt.bat" || goto x
            call a checkFsBase "Huid.local" "Huid.nuspec" || goto x
        call a completeTest
    ::_____________________________________________________


    ::_______ ------ ______________________________________

        call a unsetPackage ..\T00LS

        call a startTest "/p:ngserver=%cd%\%basePkgDir%Huid.nupkg /p:ngpackages=: /p:ngpath=T00LS" || goto x
            call a msgOrFailAt 1 "... %cd%\T00LS" || goto x
            call a checkFs "T00LS" "Huid.nuspec" || goto x
        call a completeTest

        call a unsetPackage ..\T00LS
    ::_____________________________________________________


    ::_______ ------ ______________________________________

        call a unsetPackage putty.portable.0.69

        call a startTest "/p:ngpackages=putty.portable/0.69 /p:ngserver=https://chocolatey.org/api/v2/package/" || goto x
            call a msgOrFailAt 1 "putty.portable/0.69 ... " || goto x
            call a checkFsBase "putty.portable.0.69" "putty.portable.nuspec" || goto x
        call a completeTest
    ::_____________________________________________________


    ::_______ ------ ______________________________________

        call a startTest "/p:ngpackages=`Conari;Fnv1a12;LX4Cnh` /p:break=no" || goto x
            call a msgOrFailAt 1 "Conari " || goto x
            call a msgOrFailAt 2 "Fnv1a12 ... " || goto x
            call a msgOrFailAt 2 "404" || goto x
            call a msgOrFailAt 3 "LX4Cnh " || goto x
        call a completeTest
    ::_____________________________________________________


    ::_______ ------ ______________________________________

        call a startTest "`Conari;Fnv1a12;LX4Cnh` /p:break=no" || goto x
            call a msgOrFailAt 1 "Conari " || goto x
            call a msgOrFailAt 2 "Fnv1a12 ... " || goto x
            call a msgOrFailAt 2 "404" || goto x
            call a msgOrFailAt 3 "LX4Cnh " || goto x
        call a completeTest
    ::_____________________________________________________


    ::_______ ------ ______________________________________

        call a startTest "`Conari;Fnv1a12;LX4Cnh` /p:break=yes" 1 || goto x
            call a msgOrFailAt 1 "Conari " || goto x
            call a msgOrFailAt 2 "Fnv1a12 ... " || goto x
            call a msgOrFailAt 2 "404" || goto x
        call a completeTest
    ::_____________________________________________________


    ::_______ ------ ______________________________________

        echo ^<?xml version="1.0" encoding="utf-8"?^>>>%config%

        call a startTest "/p:ngconfig=`%config%`" 1 || goto x
            call a msgOrFailAt 1 "Root element is missing" || goto x
        call a completeTest
    ::_____________________________________________________


    ::_______ ------ ______________________________________

        echo ^<?xml version="1.0" encoding="utf-8"?^>>%config%
        echo ^<packages^>>>%config%
        echo   ^<package id="Conari"/^>>>%config%
        echo   ^<package id="Fnv1a128" version="1.0.0" sha1="!sha1Fnv1a128!"/^>>>%config%
        echo   ^<package id="LX4Cnh" version="1.1.0" output="__algorithms"/^>>>%config%
        echo ^</packages^>>>%config%

        call a startTest "/p:ngconfig=`%config%`" || goto x
            call a msgOrFailAt 1 "Conari use " || goto x
            call a msgOrFailAt 2 "Fnv1a128.1.0.0 use " || goto x
            call a msgOrFailAt 3 "LX4Cnh/1.1.0 ... " || goto x
            call a checkFsBase "Conari" "Conari.nuspec" || goto x
            call a checkFsBase "Fnv1a128.1.0.0" "Fnv1a128.nuspec" || goto x
            call a checkFsBase "__algorithms" "LX4Cnh.nuspec" || goto x
        call a completeTest
    ::_____________________________________________________


    ::_______ ------ ______________________________________

        set "cfg1=%basePkgDir%p1.config"
            echo ^<?xml version="1.0" encoding="utf-8"?^>>%cfg1%
            echo ^<packages^>>>%cfg1%
            echo   ^<package id="LX4Cnh" version="1.1.0" output="__algorithms"/^>>>%cfg1%
            echo ^</packages^>>>%cfg1%

        set "cfg2=%basePkgDir%p2.config"
            echo ^<?xml version="1.0" encoding="utf-8"?^>>%cfg2%
            echo ^<packages^>>>%cfg2%
            echo   ^<package id="Conari"/^>>>%cfg2%
            echo ^</packages^>>>%cfg2%

        call a startTest "/p:ngconfig=`%cfg1%;%cfg2%`" || goto x
            call a msgOrFailAt 1 "LX4Cnh" || goto x
            call a msgOrFailAt 2 "Conari " || goto x
            call a checkFsBase "__algorithms" "LX4Cnh.nuspec" || goto x
            call a checkFsBase "Conari" "Conari.nuspec" || goto x
        call a completeTest

        call a unsetFile %cfg1%
        call a unsetFile %cfg2%
    ::_____________________________________________________


    ::_______ ------ ______________________________________

        call a unsetNupkg %basePkgDir%%artefactsDirName%\Fnv1a128.1.0.0.nupkg

        call a startTest "/t:pack /p:ngin=%basePkgDir%Fnv1a128.1.0.0 /p:ngout=%artefactsDirName% /p:debug=true" || goto x
            call a msgOrFailAt 2 "Creating package " || goto x
            call a msgOrFailAt 2 "Fnv1a128.1.0.0.nupkg" || goto x
            call a msgOrFailAt 6 "Fnv1a128.nuspec" || goto x
            call a msgOrFailAt 11 "Fnv1a128.dll" || goto x
            call a checkFs %artefactsDirName% "Fnv1a128.1.0.0.nupkg" || goto x

            :: it should fail due to 1 error code but let's check it to be sure
            call a failIfInStream "+ [Content_Types].xml" || goto x
            call a failIfInStream "+ package\" || goto x
            call a failIfInStream "+ _rels\.rels" || goto x
        call a completeTest
    ::_____________________________________________________


    ::_______ ------ ______________________________________

        call a unsetNupkg %basePkgDir%%artefactsDirName%\Fnv1a128.1.0.0.nupkg

        call a startTest "/t:pack /p:ngin=Fnv1a128.1.0.0 /p:wpath=%cd%\%basePkgDir% /p:ngout=%artefactsDirName%" || goto x
            call a msgOrFailAt 1 ".nuspec " || goto x
            call a msgOrFailAt 2 "Creating package " || goto x
            call a msgOrFailAt 2 "Fnv1a128.1.0.0.nupkg" || goto x
            call a checkFsBase %artefactsDirName% "Fnv1a128.1.0.0.nupkg" || goto x
        call a completeTest
    ::_____________________________________________________


    ::_______ ------ ______________________________________

        :: NOTE: In original engine, the trailing backslash \ inside "..." must be escaped at least before the last double quote (i.e. \" in "...\path\"),
        :: for example, by adding a new one "...\path\\" or "...\path\/" or removed at all "...\path" or escape every backslash "dir1\\dir2\\path\\" or use the common slash "dir1/dir2/path/" instead
        call a startTest "/t:pack /p:ngin=Fnv1a128.1.0.0 /p:wpath=`%cd%\%basePkgDir%\`" || goto x
            call a msgOrFailAt 1 ".nuspec " || goto x
            call a msgOrFailAt 2 "Creating package " || goto x
            call a msgOrFailAt 2 "Fnv1a128.1.0.0.nupkg" || goto x
            call a checkFsBase %artefactsDirName% "Fnv1a128.1.0.0.nupkg" || goto x
        call a completeTest
    ::_____________________________________________________


    ::_______ ------ ______________________________________

        call a startTest "/p:wpath=%cd%\%basePkgDir%" || goto x
            call a msgOrFailAt 1 "Conari " || goto x
            call a msgOrFailAt 2 "Fnv1a128" || goto x
            call a msgOrFailAt 3 "!sha1Fnv1a128! ... !sha1Fnv1a128!" || goto x
            call a msgOrFailAt 4 "LX4Cnh" || goto x
        call a completeTest
    ::_____________________________________________________


    ::_______ ------ ______________________________________

        call a unsetFile %gntcore%

        :: NOTE: sha1_comparer compares both cores when running build.bat

        call a startTest "-unpack  " || goto x
            call a msgOrFailAt 1 "Generating a %gntcore% at " || goto x
            call a checkFs %gntcore%
        call a completeTest

        call a unsetFile %gntcore%
    ::_____________________________________________________


    ::_______ ------ ______________________________________

        call a unsetPackage Fnv1a128.1.0.0

        echo ^<?xml version="1.0" encoding="utf-8"?^>>%config%
        echo ^<packages^>>>%config%
        echo   ^<package id="Fnv1a128" version="1.0.0" sha1="cccccccccccccccccccccccccccccccccccccccc"/^>>>%config%
        echo ^</packages^>>>%config%

        call a startTest "/p:ngconfig=`%config%`" 1 || goto x
            call a msgOrFailAt 1 "Fnv1a128/1.0.0 ... " || goto x
            call a msgOrFailAt 2 "[x]" || goto x
            call a sha1At 2 sha1Fnv1a128
            call a checkFsBaseNo "Fnv1a128.1.0.0/Fnv1a128.nuspec" || goto x
        call a completeTest
    ::_____________________________________________________


    ::_______ ------ ______________________________________

        echo ^<?xml version="1.0" encoding="utf-8"?^>>%config%
        echo ^<packages^>>>%config%
        echo   ^<package id="Fnv1a128" version="1.0.0" sha1="!sha1Fnv1a128!"/^>>>%config%
        echo ^</packages^>>>%config%

        call a startTest "/p:ngconfig=`%config%`" || goto x
            call a msgOrFailAt 1 "Fnv1a128/1.0.0 ... " || goto x
            call a msgOrFailAt 2 "!sha1Fnv1a128! ... !sha1Fnv1a128!" || goto x
            call a checkFsBase "Fnv1a128.1.0.0" "Fnv1a128.nuspec" || goto x
        call a completeTest
    ::_____________________________________________________


    ::_______ ------ ______________________________________

        call a unsetNupkg "%basePkgDir%Huid.nupkg"

        call a startTest "Huid?cccccccccccccccccccccccccccccccccccccccc:Huid.nupkg /t:grab" 1 || goto x
            call a msgOrFailAt 1 "Huid ... " || goto x
            call a msgOrFailAt 2 "[x]" || goto x
            call a checkFsNupkg "%basePkgDir%Huid.nupkg" || goto x
        call a completeTest
    ::_____________________________________________________


:::::::::::::
call :cleanup

:::::::::::::::::: :::::::::::::: :::::::::::::::::::::::::
::
:x
endlocal & set /a %1=%gcount% & set /a %2=%failedTotal%
if !failedTotal! EQU 0 exit /B 0
exit /B 1

:cleanup
    call a unsetPackage
    call a unsetFile %config%
    call a unsetDir %artefactsDirName%
exit /B 0