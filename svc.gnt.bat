::! GetNuTool /svc helper
::! Copyright (c) 2015  Denis Kuzmin <x-3F@outlook.com> github/3F
::! Copyright (c) GetNuTool contributors https://github.com/3F/GetNuTool/graphs/contributors
::! Licensed under the MIT License (MIT).
::! See accompanying License.txt file or visit https://github.com/3F/GetNuTool

@echo off & echo Incomplete script. Compile it first using build.bat: github.com/3F/GetNuTool >&2 & exit /B 1

set "dpnx0=%~dpnx0"
set args=%*   ::&:

:: PARSER NOTE: keep \r\n because `&` requires enableDelayedExpansion
set esc=%args:!= L %  ::&:
set esc=%esc:^= T %   ::&:
setlocal enableDelayedExpansion

:: https://github.com/3F/hMSBuild/issues/7
set "E_CARET=^"
set "esc=!esc:%%=%%%%!"
set "esc=!esc:&=%%E_CARET%%&!"

:: - - -
:: -

set "core=gnt.bat"

set "debug="
set "keyBoot="
set "keyEmbed="
set "keyName="
set "keyNoColor="
set "keySha1Get="
set "keySha1Cmp="
set "keyPkgAsPath="

set /a ERROR_SUCCESS=0
set /a ERROR_FAILED=1
set /a ERROR_FILE_NOT_FOUND=2
set /a ERROR_PATH_NOT_FOUND=3
set /a ERROR_INVALID_DATA=12
set /a ERROR_CALL_NOT_IMPLEMENTED=120

:: Current exit code for endpoint
set /a EXIT_CODE=0
set "ERR_MSG="

:: - - -
:: Initialization of user arguments

if not defined args (
    goto usage
)

:: /? will cause problems for the call commands below, so we just escape this via supported alternative:
set esc=!esc:/?=/h!

:: process arguments through hMSBuild
call :inita arg esc amax
goto commands

:usage

echo.
echo [SVC] GetNuTool $app.version$
echo Copyright (c) 2016-2025  Denis Kuzmin ^<x-3F@outlook.com^> github/3F
echo.
echo Usage: %~n0 [keys]
echo  *quotes inside other quotes can be used as " `...` "
echo.
echo Keys to %~n0
echo ____________
echo.
echo. -embed "..."      - Generate a new gnt.bat with predefined package access.
echo. -boot "..."       - Optional boot command for embeded package.
echo. -name {package}   - Optional name for the result.
echo.
echo. -sha1-get {package}           - Get sha1 for a package.
echo. -sha1-cmp {package} {sha1}    - Compare for sha1 equality for a package:
echo.                                 OK/FAIL (ErrorLevel = 12)
echo.
echo. -config {*}
echo.   * new               - Generate a new packages.config
echo.
echo. -core {*}
echo.   * syntax            - Help command for core.
echo.
echo. -package-as-path      - Use as path (local/remote) to package file.
echo. -debug                - To show additional information.
echo. -no-color             - Disable coloring of some messages like from -sha1-get etc.
echo. -version              - Displays full version number.
echo. -version-short        - Displays short version number.
echo. -help                 - Displays this help. Aliases: -help -h /h -? /?
echo.
echo Examples
echo ________
echo.
echo %~n0 -embed *DllExport
echo %~n0 -embed vsSolutionBuildEvent -boot packages\vsSolutionBuildEvent\GUI
echo %~n0 -embed vsSolutionBuildEvent -boot packages\vsSolutionBuildEvent\GUI -name vssbe
echo %~n0 -embed "+`Conari;DllExport`" -name unmanaged
echo %~n0 -embed "~/p:use=?" -name help
echo %~n0 -sha1-get LX4Cnh/1.1
echo %~n0 -sha1-cmp Fnv1a128 eead8f5c1fdff2abd4da7d799fbbe694d392c792
echo %~n0 -sha1-get "path to\LX4Cnh.nupkg" -package-as-path
echo.
echo To check the modifications of the GetNuTool itself:
echo %~n0 -sha1-cmp gnt.bat {sha1} -package-as-path
echo.          ^|^| if ^^!ErrorLevel^^! EQU 12 ( ... gnt.bat is Modified )

goto endpoint

:: - - -
:commands

set /a idx=0

:loopargs
set key=!arg[%idx%]!

    :: The help command

    if [!key!]==[-help] ( goto usage ) else if [!key!]==[-h] ( goto usage ) else if [!key!]==[-?] ( goto usage ) else if [!key!]==[/h] ( goto usage )

    :: Available keys

    if [!key!]==[-debug] (

        set debug=true

        goto continue
    ) else if [!key!]==[-boot] ( set /a "idx+=1" & call :eval arg[!idx!] v

        set keyBoot=!v!

        goto continue
    ) else if [!key!]==[-embed] ( set /a "idx+=1" & call :eval arg[!idx!] v

        set keyEmbed=!v!

        goto continue
    ) else if [!key!]==[-name] ( set /a "idx+=1" & call :eval arg[!idx!] v

        set keyName=!v!

        goto continue
    ) else if [!key!]==[-config] ( set /a "idx+=1" & call :eval arg[!idx!] v

        goto NotImplemented

    ) else if [!key!]==[-core] ( set /a "idx+=1" & call :eval arg[!idx!] v

        if /I "!v!"=="syntax" goto SyntaxCore

        set ERR_MSG=Unknown -core !v!
        set /a EXIT_CODE=%ERROR_FAILED%
        goto endpoint

    ) else if [!key!]==[-sha1-get] ( set /a "idx+=1" & call :eval arg[!idx!] v

        set keySha1Get=!v!

        goto continue
    ) else if [!key!]==[-sha1-cmp] ( set /a "idx+=1" & call :eval arg[!idx!] v

        set keySha1Cmp=!v!
        set /a "idx+=1" & call :eval arg[!idx!] cmpSha1

        goto continue
    ) else if [!key!]==[-package-as-path] (

        set "keyPkgAsPath=1"
        goto continue

    ) else if [!key!]==[-no-color] (

        set "keyNoColor=1"
        goto continue

    ) else if [!key!]==[-version-short] (

        echo $core.version$
        goto endpoint

    ) else if [!key!]==[-version] (

        echo $app.version$
        goto endpoint

    ) else (
        echo Incorrect key: !key!
        set /a EXIT_CODE=%ERROR_FAILED%
        goto endpoint
    )

:continue
set /a "idx+=1" & if %idx% LSS !amax! goto loopargs

:: - - -:: - - -:: - - -
:main

if defined keyEmbed (

    if not defined keyName set keyName=!keyEmbed!
    if not defined keyBoot set keyBoot=exit/B0
    (call :validFileName keyName && call :trimAliases keyName) || set keyName=PACKED

    call :dbgprint "embed:" keyName keyEmbed
    set dst=!keyName!.bat

    echo @call :GetNuTool !keyEmbed!^|^|^(echo Please contact support^>^&2^&exit/B1^)>!dst!

    (if defined keyBoot (
        call :dbgprint "boot:" keyBoot
        echo if "%%~1"=="" !keyBoot!>>!dst!
    ))

    echo :GetNuTool>>!dst!

    copy /Y/B !dst!+!core! !dst! 2>nul>nul || (type !core!>>!dst!)>nul || (
        set /a EXIT_CODE=%ERROR_FAILED%
        goto endpoint
    )

    echo Completed as a !dst!

) else if defined keySha1Get (

    call :getSha1 "!keySha1Get!" rSha1 || goto endpoint

    call :cprint 70 "!rSha1!"

) else if defined keySha1Cmp (

    (if not defined cmpSha1 (
        set ERR_MSG=Provide a sha1 value to verify, for example: LX4Cnh 65f7d7f5d29a16a91f1c0a8ae01ef65d5868c2cf
        set /a EXIT_CODE=%ERROR_FAILED%
        goto endpoint
    ))

    call :getSha1 "!keySha1Cmp!" rSha1 || goto endpoint

    if "!rSha1!"=="Error" (
        call :returnError
    ) else if /I "!rSha1!"=="!cmpSha1!" (
        call :returnOk
    ) else (
        set /a EXIT_CODE=%ERROR_INVALID_DATA%
        call :returnFail
    )
)

::- - -

:endpoint

    (if !EXIT_CODE! NEQ 0 if !EXIT_CODE! NEQ %ERROR_INVALID_DATA% (

        if not defined ERR_MSG (
            echo Something went wrong. Use `-debug` key for details.>&2
        ) else echo !ERR_MSG!>&2

    ))

exit /B !EXIT_CODE!

:SyntaxCore
echo  Package List Format:
echo      id[/version][?sha1][:path];id2[/version][?sha1][:path];...
echo.
echo  packages.config:
echo      ^<package id="" version="" /^>
echo      ^<package id="" version="" sha1="" output="" /^>
echo.
echo  First keys to gnt.bat:
echo    -unpack   - To generate minified gnt.core.
echo.
echo  tModes        aliases
echo    /t:get        (...)
echo    /t:pack
echo    /t:grab
echo    /t:install   (+...)
echo    /t:run       (*...)
echo    /t:touch     (~...)
echo.
echo  Aliases to itself `gnt ~` (+, *, ~)
echo    Examples:
echo     gnt ~
echo     gnt ~^& svc.gnt -sha1-get LX4Cnh/1.1
echo     gnt ~/p:use=doc
echo     gnt +/p:use=version
echo.
echo  /t:get
echo    ngpackages - List of packages.
echo    ngpath     - Common path for all packages.
echo    proxycfg   - To configure connection via proxy.
echo    ngconfig   - Define .config files.
echo    ngserver   - Define server.
echo    ssl3       - Do not drop legacy ssl3, tls1.0, tls1.1 if: true
echo    wpath      - To change working directory.
echo    break      - Disable the break on first package error if: no
echo.
echo    Proxy Format:
echo      [usr[:pwd]@]host[:port]
echo.
echo  /t:pack
echo    ngin       - Path to directory where .nuspec to create package.
echo    ngout      - Optional path to save the final .nupkg package.
echo    wpath      - To change working directory.
echo.
echo    Examples:
echo      gnt /t:pack /p:ngin=path\to\dir
echo      gnt /t:pack /p:ngin="path to\dir";ngout=..\dst.nupkg
echo.
echo  /t:install
echo.
echo    Examples:
echo      gnt +DllExport
echo      gnt +"DllExport;Conari"
echo.
echo  /t:run
echo.
echo    Examples:
echo      gnt *DllExport
echo      gnt *"DllExport;Conari"
echo.
echo  Global Properties
echo    * debug = true to add extra info in stream.
echo    * logo  = no to hide logo when processing starts.
echo.
echo    Examples:
echo      gnt /t:pack /p:ngin=packages\LX4Cnh /p:debug=true
echo      set debug=true ^& gnt /p:ngpackages="Conari;LX4cn;Fnv1a128";break=no
echo.
echo  To override the engine:
echo     Examples:
echo       gnt -unpack ^& msbuild.exe gnt.core {args}
echo       echo.@echo  msbuild.exe^> hMSBuild.cmd
echo       hMSBuild.bat ( https://github.com/3F/hMSBuild )
echo.
echo  Build from src:
echo    git clone https://github.com/3F/GetNuTool.git src
echo    cd src ^& build ^& bin\Release\gnt Conari
echo.
echo  Examples:
echo      gnt vsSolutionBuildEvent/1.16.1:../SDK ^& SDK\GUI
echo      gnt "Conari;regXwild;MvsSln"
echo      gnt Conari
echo      gnt /p:ngpackages=Conari
echo      msbuild gnt.core /p:ngpackages=Conari
echo      gnt /p:ngpackages="Conari;regXwild;MvsSln"
echo      gnt /t:pack /p:ngin=packages/Fnv1a128
echo      gnt LX4Cnh? /p:logo=no;info=no
echo      gnt LX4Cnh?65f7d7f5d29a16a91f1c0a8ae01ef65d5868c2cf
echo      msbuild gnt.core /p:ngconfig=".nuget/packages.config";ngpath="../packages"
echo      gnt Conari /p:proxycfg="guest:1234@10.0.2.15:7428"
echo      set ngpackages=Conari ^& call gnt ^|^| echo  Failed
echo      gnt "7z.Libs;vsSolutionBuildEvent/1.16.1:../packages/SDK"
echo      gnt :DllExport /p:ngserver=https://server/DllExport.1.7.4.nupkg
echo      gnt : /p:ngserver=D:/local_dir/vsSolutionBuildEvent.SDK10.nupkg /p:ngpath=SDK10
echo      gnt "Conari;Fnv1a12;LX4Cnh" /p:break=no /p:debug=true
echo      gnt Huid/1.0.0:src.zip /t:grab
echo.
echo    More: https://github.com/3F/GetNuTool/blob/master/tests/keysAndLogicTests.bat
echo.
echo  Documentation:
echo    * https://github.com/3F/GetNuTool
echo    * doc\documentation.html
echo    * gnt ~/p:use=documentation
exit /B 0


:getSha1
    ::   (1) - Input GetNuTool's raw line.
    ::  &(2) - SHA1 or "Error".
    :: !!1   - Error code 1 if &(1) is not defined.

    set v=%1

    (if not defined v (
        set ERR_MSG=Specify the package name, for example: Fnv1a128
        set /a EXIT_CODE=%ERROR_FAILED%
        exit /B 1
    ))

    ( if defined keyPkgAsPath (set _sarg=~?: /p:ngserver=!v!) else (
        set _sarg=~!v!?

        call :contains _sarg ";" multi
        if .!multi! EQU .1 (
            set ERR_MSG=Multiple packages are not supported yet for -sha1* keys.
            set /a EXIT_CODE=%ERROR_CALL_NOT_IMPLEMENTED%
            exit /B 1
        )
    ))

    set "_sarg=!_sarg! /p:logo=no;info=no;ngpath=-sha1-core-%random%"
    call :invoke !core! _sarg 2>nul>nul

    call :getMsgAt 1 sha1line
    if "!sha1line:~44,3!"=="[x]" (
        set "%2=!sha1line:~4,40!"
    ) else (
        set "%2=Error"
        (call :dbgprint "Error:" sha1line)
    )
exit /B 0

::
:: ::

:NotImplemented
    echo Not Implemented>&2
exit /B %ERROR_CALL_NOT_IMPLEMENTED%

:returnFail
    call :cprint 60 "FAIL"
exit /B 0

:returnOk
    call :cprint 2F "OK"
exit /B 0

:returnError
    call :cprint 4F "Error"
exit /B 0

:dbgprint {in:str} [{in:uneval}, [{in:uneval}]]
    if defined debug (
        :: NOTE: delayed `dmsg` because symbols like `)`, `(` ... requires protection after expansion. /hMSBuild Y-32
        set "dmsg=%~1" & echo [ %TIME% ] !dmsg! !%2! !%3!
    )
exit /B 0
:: :dbgprint

:: initialize arguments
:inita {in:vname} {in:arguments} {out:index}
    :: Usage: 1- the name for variable; 2- input arguments; 3- max index

    set _ieqargs=!%2!
    set _ieqargs=!_ieqargs:""=!

    :: unfortunately, we also need to protect the equal sign '='
    :_eqp
    for /F "tokens=1* delims==" %%a in ("!_ieqargs!") do (
        if "%%~b"=="" (

            call :nqa %1 !_ieqargs! %3 & exit /B 0

        ) else set _ieqargs=%%a E %%b
    )
    goto _eqp
    :nqa

    set "vname=%~1"
    set /a idx=-1

    :_inita
        :: -
        set /a idx+=1
        set %vname%[!idx!]=%~2
        set %vname%{!idx!}=%2

        :: NOTE1: `shift & ...` may be evaluated incorrectly without {newline} symbols;
        ::         Either shift + {newline} + ... + if %~3 ...; or if %~4 ... shift & ...

        :: NOTE2: %~4 because the next %~3 is reserved for {out:index}
        if "%~4" NEQ "" shift & goto _inita

    set %3=!idx!
exit /B 0

:: evaluate argument
:eval {in:unevaluated} {out:evaluated}
    :: Usage: 1- input; 2- evaluated output

    :: delayed evaluation
    set _vl=!%1!  ::&:

    :: data from %..% below should not contain double quotes, thus we need to protect this:
    (if "!_vl!" NEQ "" (

        set "_vl=%_vl: T =^%"   ::&:
        set "_vl=%_vl: L =^!%"  ::&:
        set _vl=!_vl: E ==!     ::&:

        :: to support extra quotes
        set _vl=!_vl:`="!         ::&:
    ))

    set %2=!_vl!
exit /B 0

:validFileName
    :: &(1) - input name

    set _input=!%~1!

    for /L %%p in (0,1,400) do (
        set "_ch=!_input:~%%p,1!"
        if "!_ch!" EQU "" exit /B0

        if "!_ch!" LSS "." if "!_ch!" NEQ "+" if "!_ch!" NEQ "*" exit /B1
        if "!_ch!" GTR "z" if "!_ch!" NEQ "~" exit /B1

        if "!_ch!" EQU "/" exit /B1
        if "!_ch!" EQU "\" exit /B1
        if "!_ch!" GEQ ":" if "!_ch!" LEQ "?" exit /B1
    )
exit /B 0

:trimAliases
    :: +... *... ~...
    :: &(1) - input/output name

    set _input=!%1!
    set "%1="

    for /L %%p in (0,1,400) do (
        set "_ch=!_input:~%%p,1!"
        if "!_ch!" EQU "" exit /B0
        if "!_ch!" NEQ "+" if "!_ch!" NEQ "*" if "!_ch!" NEQ "~" set "%1=!%1!!_ch!"
    )
exit /B 0

:invoke
    ::  (1) - Command.
    :: &(2) - Input arguments inside "..." via variable.
    :: &[3] - Return code.
    :: !!0+ - Error code from (1)

    set "cmd=%~1 !%2!"

    :: NOTE: Use delayed !cmd! instead of %cmd% inside `for /F` due to
    :: `=` (equal sign, which cannot be escaped as `^=` when runtime evaluation %cmd%)

    call :dbgprint "invoke:" cmd

    set "cmd=!cmd! 2^>^&1 ^&call echo %%^^ERRORLEVEL%%"
    set /a msgIdx=0

    for /F "tokens=*" %%i in ('!cmd!') do 2>nul (
        set /a msgIdx+=1
        set msg[!msgIdx!]=%%i
    )

    if not "%3"=="" set %3=!msg[%msgIdx%]!
exit /B !msg[%msgIdx%]!

:printStream
    if "!msgIdx!"=="" exit /B 1
    for /L %%i in (0,1,!msgIdx!) do echo (%%i) *%~1: !msg[%%i]!
exit /B 0

:cprint
    :: (1) - color attribute via :color call
    :: (2) - Input string.

    if defined keyNoColor (echo %~2)else (call :color %~1 "%~2" & echo.)
exit /B 0

:color
    :: (1) - color attribute, {background} | {foreground}
            :: 0 = Black       8 = Gray
            :: 1 = Blue        9 = Light Blue
            :: 2 = Green       A = Light Green
            :: 3 = Aqua        B = Light Aqua
            :: 4 = Red         C = Light Red
            :: 5 = Purple      D = Light Purple
            :: 6 = Yellow      E = Light Yellow
            :: 7 = White       F = Bright White

    :: (2) - Input string.

    <nul set/P= >"%~2"
    findstr /a:%~1  "%~2" nul
    del "%~2">nul
exit /B 0

:printMsgAt
    ::  (1) - index at msg
    ::  [2] - color attribute via :color call
    ::  [3] - prefixed message at the same line
    :: !!1  - Error code 1 if &(1) is empty or not valid.

    call :getMsgAt %~1 _msgstr || exit /B 1

    if not "%~2"=="" (
        call :cprint %~2 "%~3!_msgstr!"

    ) else echo !_msgstr!
exit /B 0

:getMsgAt
    ::  (1) - index at msg
    :: &(2) - result string
    :: !!1  - Error code 1 if &(1) is empty or not valid.

    if "%~1"=="" exit /B 1
    if %msgIdx% LSS %~1 exit /B 1
    if %~1 LSS 0 exit /B 1

    set %2=!msg[%~1]!
exit /B 0

:contains
    :: &(1) - Input string via variable
    ::  (2) - Substring to check. Use ` instead of " and do NOT use =(equal sign) since it's not protected.
    :: &(3) - Result, 1 if found.

    :: TODO: L-39 protect from `=` like the main module does; or compare in parts using `#`

    set "input=!%~1!"

    if "%~2"=="" if "!input!"=="" set /a %3=1 & exit /B 0
    if "!input!"=="" if not "%~2"=="" set /a %3=0 & exit /B 0

    set "input=!input:"=`!" ::&:
    set "cmp=!input:%~2=!"  ::&:

    if "!cmp!" NEQ "!input!" ( set /a %3=1 ) else set /a %3=0
exit /B 0