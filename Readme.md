# [GetNuTool](https://github.com/3F/GetNuTool)

Embeddable Package Manager (+core in .bat);
🕊 Lightweight tool to Create or Distribute using basic shell scripts (does not require *powershell* or *dotnet-cli*);
*NuGet* / *Chocolatey* client;

```r
Copyright (c) 2015-2025  Denis Kuzmin <x-3F@outlook.com> github/3F
```

[ 「 ❤ 」 ](https://3F.github.io/fund) [![License](https://img.shields.io/badge/License-MIT-74A5C2.svg)](https://github.com/3F/GetNuTool/blob/master/License.txt)
[![Build status](https://ci.appveyor.com/api/projects/status/gw8tij2230gwkqs6/branch/master?svg=true)](https://ci.appveyor.com/project/3Fs/getnutool-github/branch/master)
[![release](https://img.shields.io/github/release/3F/GetNuTool.svg)](https://github.com/3F/GetNuTool/releases/latest)


```bash
gnt Fnv1a128                                  # Get Fnv1a128 package
gnt +DllExport                                # Install DllExport package
gnt *DllExport                                # Install and Run DllExport.bat
gnt ~hMSBuild                                 # Touch hMSBuild
gnt /t:pack /p:ngin="bin\DllExport"           # Create new DllExport package
gnt "Conari;regXwild"                         # Get Conari & regXwild packages
msbuild gnt.core /p:ngpackages=LuNari/1.6.0   # Use msbuild to get LuNari 1.6.0 
gnt Huid/1.0.0:src.zip /t:grab                # Grab Huid 1.0 as zip without unpacking
gnt /p:ngconfig="dir\packages.config"         # Use specified packages.config
set ngpackages=Conari & gnt                   # shell scripts
gnt /p:ngpackages=putty.portable/0.69         # chocolatey
    /p:ngserver="https://chocolatey.org/api/v2/package/"
```

**[Download](https://github.com/3F/GetNuTool/releases/latest)** all editions: *Core, Minified, Executable, C# version for .NET, ...*

Official Direct Links:

* (Windows) Latest stable compiled batch-script [ [gnt.bat](https://3F.github.io/GetNuTool/releases/latest/gnt/) ] `https://3F.github.io/GetNuTool/releases/latest/gnt/`


### Projects based entirely on GetNuTool

* [netfx4sdk](https://github.com/3F/netfx4sdk) - Developer Pack (SDK). NETFX 4: Visual Studio 2022+ / MSBuild 17+ / or other modern tools;
* [hMSBuild](https://github.com/3F/hMSBuild) - Compiled text-based embeddable pure batch-scripts for searching modern MSBuild instances;
* [.NET DllExport Manager](https://github.com/3F/DllExport/wiki/DllExport-Manager) - Part of the DllExport tool that provides its completely independent management and distribution beyond the NuGet ecosystem. Relies on [MvsSln](https://github.com/3F/MvsSln) as well;


## Why GetNuTool

```bash
> gnt                                      # via single shell script
> msbuild gnt.core                         # via MSBuild engine
[NuGet gnt.raw("/t:pack /p:ngin=7z.Libs")] # via SobaScript
new GetNuTool()                            # .NET(netfx 4.0+, .NET 5+, .NET Core, Mono) C#
```

Lightweight Portable and completely Embeddable (+core in .bat) package tool to create or distribute everything from anything.

Back in those days it was originally developed as an alternative to solution level limitations, i.e. [github.com/NuGet/Home/issues/1521](https://github.com/NuGet/Home/issues/1521). In attempt to provide a tool to easily maintain projects, libraries, and other related build processes; For all projects at once at the solution level and of course for each separately if necessary.

For example, it was designed to be more friendly to such NuGet packages:
* [vsSolutionBuildEvent](https://www.nuget.org/packages/vsSolutionBuildEvent) (before, aka [vsSBE.CI.MSBuild](https://www.nuget.org/packages/vsSBE.CI.MSBuild/))
* [7z.Libs](https://www.nuget.org/packages/7z.Libs/)
* [DllExport](https://github.com/3F/DllExport)
* [ILAsm](https://www.nuget.org/packages/ILAsm/)

However! GetNuTool has more powerful ways even for standard NuGet packages providing a wider range of use cases.

* [Conari](https://github.com/3F/Conari), [Fnv1a128](https://github.com/3F/Fnv1a128), [MvsSln](https://github.com/3F/MvsSln), [regXwild](https://github.com/3F/regXwild), ...

### Key Features

* Install *.nupkg* packages from remote NuGet (or like: chocolatey, ...) servers.
* Grab or Install any *zipped* packages from direct sources (local, remote http, https, ftp, ...).
* Controlled unpacking of all received packages. Modes: `get` or `grab` or `install` or `touch`
* Hash values control using [`sha1`](https://en.wikipedia.org/wiki/SHA-1) for receiving every package if used unsecured channels (~windows xp) etc.
* Creating new NuGet packages *.nupkg* from *.nuspec*.
* Two supported formats: xml *packages.config* (+extra: output, sha1) and inline records.
* Inline records and packages.config are fully compatible between, and config has backward compatibility with original packages.config
* Configurable custom folders for every receiving.
* Request to the server only if the package is not installed.
* Supports proxy with custom credential.
* Default settings are overridden through an environment variables: default .config files, NuGet server, etc.
* The ability to create *one click* ~8 KB .bat wrappers for any packages. Try for example [vsSolutionBuildEvent.bat](https://github.com/3F/GetNuTool/blob/master/demo/vsSolutionBuildEvent.bat)
* Easy integration into any scripts such as pure batch-script [netfx4sdk](https://github.com/3F/netfx4sdk), [DllExport](https://github.com/3F/DllExport/wiki/DllExport-Manager), [hMSBuild](https://github.com/3F/hMSBuild)
* C# projects support via GetNuTool.cs
* *.pkg.install.bat* and *.pkg.install.sh* support for *install*, *run*, *touch* modes and additionally via `+` (plus), `*` (asterisk), `~` (tilde) i.e. `gnt +...`, `gnt *...`, `gnt ~...` respectively.

Note:

* Dependencies are not considered.
* Doesn't manage projects or solutions files. You need [MvsSln](https://github.com/3F/MvsSln) or anything else together with.
* NuGet events *(Init.ps1, Install.ps1, Uninstall.ps1) from /tools* will not be launched automatically.
    * To use events (from Visual Studio, MSBuild, NuGet, etc.), you can with [vsSolutionBuildEvent](https://github.com/3F/vsSolutionBuildEvent), or [vsCommandEvent](https://github.com/3F/vsCommandEvent), or configure it like [DllExport](https://github.com/3F/DllExport) project, or command it manually.

## tModes and Commands

### `get`

For receiving packages or zipped files from local or remote source, then installing / extracting.

The `get` is used by default but you can also specify `/t:get`

Property   | Description                                                   | Default values
-----------|---------------------------------------------------------------|-----------------
ngconfig   | Define *.config* files.                                       | 1.9+ `packages.config;.tools\packages.config`
ngserver   | Define server.                                                | 1.0+ `https://www.nuget.org/api/v2/package/`
ngpackages | List of packages. Disables *ngconfig* if specified.           | 
ngpath     | Common path for all packages.                                 | 1.0+ `packages`
wpath      | *1.4+*  To change working directory.                          | 1.4+ *(The absolute path of the directory where the GetNuTool is located)*
proxycfg   | *1.6.2+* To configure connection via proxy.                   | 
ssl3       | *1.9+* Do **not** drop legacy ssl3, tls1.0, tls1.1 if `true`. | 
break      | *1.9+* Disable the break on first package error if `no`       | 


#### Package List Format

Attribute | Description                                  | Example
----------|----------------------------------------------|------------------------------
id        | Identifier of package.                       | `Conari`
version   | *(Optional)* Package version.                | `1.5.0` or `1.5-beta2` or `1.5-RC` etc.
output    | *(Optional)* Where to store package data.    | `../tests/case1`
sha1      | *(Optional)* Expected sha1 for this package. | `eead8f5c1fdff2abd4da7d799fbbe694d392c792`

**Note:** 

* As of version 1.2+, attributes are now case sensitive. Please use lowercase for `id`, `version`, `output`, `sha1`.
* It will link to the **latest** available version if `version` attribute is not defined.
* `output` attribute is relative to `ngpath`. You can also use absolute path.
* `sha1` activates security check before every install / extracting. It useful when connection is not secure like on windows xp with obsolete ciphers. But please note: some servers (like official NuGet) may repackage .nupkg for some purposes, such as adding *.signature.p7s* etc. This of course changes sha1 hash value that you need to check.
* `id` allows only `a-z` `A-Z` `0-9` `.` `-` `_` symbols without whitespaces.

##### *ngpackages*

```ps
id[/version][?sha1][:path];id2[/version][?sha1][:path];...
```

delimiters:

* `;` 1.6+ `Name1;Name2;Name3`
* `|` 1.0-1.9 `Name1|Name2|Name3`

```ps
/p:ngpackages=Name1
/p:ngpackages="Name1;Name2"
```

##### *packages.config*
    
```xml
<?xml version="1.0" encoding="utf-8"?>
<packages>
  <package id="Name1" version="1.5.0" />
  <package id="Name2" output="path" />
  <package id="Name3" version="2.2-RC" sha1="eead8f5c1fdff2abd4da7d799fbbe694d392c792" />
</packages>
```

```ps
/p:ngconfig=".nuget/packages.config"
/p:ngconfig="debug.config;release.config;..."
```

#### Proxy Format

```ps
[usr[:pwd]@]host[:port]
```

```ps
/p:proxycfg="example.com:4321"
```

### `grab`

1.9+

Grabs data without unpacking. The available parameters are similar to the `get` above.

For example:

```bat
gnt Huid/1.0.0:src.nupkg /t:grab
```

```bat
gnt :../netfx4sdk.cmd /t:grab /p:ngserver=https://server/netfx4sdk.cmd
```

```bat
msbuild gnt.core /t:grab /p:ngpackages=Fnv1a128:src.nupkg
```

```bat
gnt Huid/1.0.0?24ecda9a4fb8920067df31788d3dea708996ab08:src.nupkg /t:grab
```

### `pack`

Creates the new *.nupkg* packages using [*.nuspec*](https://learn.microsoft.com/en-us/nuget/reference/nuspec) specification.
Can also be found in the package folder after using `get`.

Property | Description                                                     | Default values
---------|-----------------------------------------------------------------|----------------------
ngin     | Path to directory where *.nuspec* to create package from it.    |
ngout    | Optional path to save the final `.nupkg` package in other place.|
wpath    | *1.4+*  To change working directory.                            | 1.4+ *(The absolute path of the directory where the GetNuTool is located)*

```bat
gnt /t:pack /p:ngin=path\to\dir
gnt /t:pack /p:ngin="path to\dir";ngout=..\dst.nupkg
```

### `touch` & `install` & `run`

1.10+

*GetNuTool* automatically invokes *.pkg.install.bat* (or *.pkg.install.sh* depending on the environment) in activated `install` or `run` or `touch` modes if the package provides support for this. Note: Once per clean install (it won't trigger for cached or already unpacked packages).

The available options are the same as for the `get` mode described above.

The `install` mode can be activated in different ways,

```bat
gnt +DllExport
```

```bat
gnt +"DllExport;Conari"
```

or using `/t:install`

```bat
msbuild gnt.core /t:install /p:ngpackages=DllExport
```

```csharp
net.r_eg.GetNuTool gnt = new();
gnt.Run(ngpackages: "Conari;DllExport", tmode: "install");
```

The `run` mode is similar to the *install* described above but using `*` instead of `+`,

```bat
gnt *DllExport
```

```bat
gnt *"DllExport;Conari"
```

and `/t:run`

```bat
msbuild gnt.core /t:run /p:ngpackages=DllExport
```

```csharp
gnt.Run(ngpackages: "Conari;DllExport", tmode: "run");
```

The `touch` mode extends the *install* mode and allows to work with package and its contents in a one-time or temporary execution. Once processing is complete, the package and its contents will be deleted.

To activate this mode, you can define `~` (tilde) in arguments:

```bat
gnt ~hMSBuild
```

or using `/t:touch`

```bat
msbuild gnt.core /t:touch /p:ngpackages=hMSBuild
```

```csharp
gnt.Run(ngpackages: "hMSBuild", tmode: "touch");
```

You can also control the mode options via `/p:use=...`

```bat
gnt ~GetNuTool /p:use=help.cmd
```

#### .pkg.install.bat (.pkg.install.sh)

*.pkg.install.\** are text files which can optionally be located in the root directory of the package and support the following optional arguments:

Arguments                             |   #   | alternative in bat | alternative in bash | Example
--------------------------------------|-------|--------------------|---------------------|----------
Version of the arguments format       | `%~1` | -        | -                  | 1
Activated tMode                       | `%~2` | -        | -                  | `install` or `run` or `touch`
Full path to the working directory    | `%~3` | `%cd%`   | `$PWD`             | D:\projects\obj\
Full path to the package              | `%~4` | `%~dp0`  | `$(dirname "$0")`  | D:\projects\obj\packages\DllExport\

Accessible environment variables:

Environment variable | Description               | Example
---------------------|---------------------------|----------
`GetNuTool`          | GetNuTool version         | 1.9.0.58814+bb83b59
`debug`              | Activated debug mode      | true
`use`                | Mode options              | help.cmd

*.pkg.install.\** can be used for any purposes related to the installation process, for example, providing License.txt

```bat
copy /Y/V "%~dp0\License.txt" "%cd%\"
```

or updating the version number for the directory up to the received 

```bat
set /p _version=<"%~4\.version"
ren "%~4" MyPackage.%_version%
```

or to start setting up or updating something automatically.

Additionally `touch` mode allows to wrap or deliver anything, for example:

1. Add *.pkg.install.bat*

```bat
@echo off
if not "%~2"=="touch" exit /B0
if "%use%"=="help" (
    echo.
    echo In the Beginning the World ...
    exit /B0
)
```

2. Generate package:

> gnt /t:pack /p:ngin=D:\prg\MyPackage

3. Upload to the server you want.
4. In the end, your workflow will contain nothing but the result after `gnt ~MyPackage /p:use=help`

```
> gnt ~MyPackage /p:use=help /p:info=no;logo=no

In the Beginning the World ...
```

For a real example, see the following *.pkg.install.bat* from *DllExport* package (1.8.2+)

```bat
@echo off
copy /Y/V "%~dp0\DllExport.bat" "%cd%\">nul || exit /B1
if "%~2"=="touch" exit /B0

    set /p _version=<"%~dp0\.version"
    set /p _rel=<"%~dp0\.release.version"
    if defined _rel set _version=%_version%-%_rel%

set "dst=%~dp0\..\DllExport.%_version%"
if exist "%dst%" rmdir /S/Q "%dst%"

::`ren` must be processed as a single command along with the called program due to line-by-line processing by the cmd processor after loss of src
ren "%~dp0" DllExport.%_version% && if "%~2"=="run" ("%cd%\DllExport.bat") else echo.exit/B0>"%dst%\.cmd"&"%dst%\.cmd"
```

Logic follows the instructions from [here](https://github.com/3F/DllExport/wiki/Quick-start):
1. Copy *DllExport.bat* into solution folder.
1. Don't do anything else if activated `touch` mode (i.e. `gnt ~DllExport`). Otherwise:
    1. Associate the latest received package (i.e. `gnt +DllExport`) with a specific version (as if it were like `gnt +DllExport/1.8.2-RC` etc.)
    1. Run Wizard if activated `run` mode (i.e. `gnt *DllExport`).

In the end, ~8 KB of the *gnt.bat* now helps to achieve the same result in a fully automated way.

## Global Properties

Property | Value
---------|-------------
debug    | `true` to add extra info in stream.
logo     | `no` to hide logo when processing starts.
info     | `no` to hide information about receiving packages etc.

For example:

```bat
gnt /t:pack /p:ngin=packages\LX4Cnh /p:debug=true
```

```bat
set debug=true & gnt /p:ngpackages="Conari;LX4cn;Fnv1a128";break=no
```

## Extra Editions

### Compiled. SobaScript component

GetNuTool now is part of [NuGetComponent](https://3F.github.io/web.vsSBE/doc/Scripts/SBE-Scripts/Components/NuGetComponent/)

```java
#[NuGet gnt.raw("/t:pack /p:ngin=D:\7z.Libs")]
```

### C# GetNuTool.cs

GetNuTool.cs includes a fully compatible *gnt.core* inside.

Add GetNuTool.cs to your project (.NET Framework 4.0+, .NET 5+, Mono, .NET Core, .NET Standard), then command like:

```csharp
var gnt = new net.r_eg.GetNuTool();
gnt.Run(ngpackages: "Conari;regXwild");
...
gnt.Run(ngpackages: "Fnv1a128");
```

### Batch (.bat) version

~8 KB `gnt.bat` includes a fully compatible *gnt.core* inside.

#### gnt.bat extra arguments

 First key to gnt.bat | Description                                                                   | Example
----------------------|-------------------------------------------------------------------------------|----------------
  ...                 | 1.9+ alias to `ngpackages=...`                                                | `gnt Conari`, `gnt "regXwild;Fnv1a128"`
 `-unpack`            | 1.6+ To generate minified gnt.core from gnt.bat.                              | `gnt -unpack`
 ~~`-msbuild`~~ path  | 1.6 - 1.8 To use specific msbuild. Removed in 1.9. Override engine instead    | `gnt -msbuild "D:\MSBuild\bin\amd64\msbuild" /p:ngpackages=Conari`
`+` | 1.10+ Activate *install* mode. Automatic call `.pkg.install.*` for supported packages. `tMode == install` | `gnt +DllExport`, `gnt +"DllExport;Conari"`
`*` | 1.10+ Activate *run* mode. Automatic call `.pkg.install.*` for supported packages. `tMode == run`         | `gnt *DllExport`, `gnt *"DllExport;Conari"`

Other keys to gnt.bat               | Description                        | Example
------------------------------------|------------------------------------|---------
`/help` `-help` `/h` `-h` `/?` `-?` | 1.9 Reserved; 1.10+ Help command;  | `gnt /help`

#### Override engine

Since the `-msbuild` key was removed in 1.9 as obsolete, you have following ways to override engine search:

Either create `msb.gnt.cmd` in the directory from which the call *gnt.bat* is planned; with the following content, for example:

```bat
@echo msbuild.exe
```

Or place a full version of [hMSBuild.bat](https://github.com/3F/hMSBuild) (~19 KB) tool instead of *msb.gnt.cmd* stub.


Or **-unpack** command:

```bat
gnt -unpack & msbuild.exe gnt.core {args}
```

Or use the same `msb.gnt.cmd` as environment variable:

```bat
set msb.gnt.cmd=msbuild.exe & gnt {args}
```

## Examples

```bat
gnt vsSolutionBuildEvent/1.16.1:../SDK & SDK\GUI
```

```bat
gnt Conari
gnt /p:ngpackages=Conari
msbuild gnt.core /p:ngpackages=Conari
```

```bat
gnt "Conari;regXwild;MvsSln"
gnt /p:ngpackages="Conari;regXwild;MvsSln"
```

```bat
gnt Fnv1a128
gnt /t:pack /p:ngin=packages/Fnv1a128
```

```bat
gnt LX4Cnh? /p:logo=no;info=no
 ... 65f7d7f5d29a16a91f1c0a8ae01ef65d5868c2cf[x]
```

```bat
gnt LX4Cnh?65f7d7f5d29a16a91f1c0a8ae01ef65d5868c2cf
```

```bat
msbuild gnt.core /p:ngconfig=".nuget/packages.config";ngpath="../packages"
```

```bat
gnt Conari /p:proxycfg="guest:1234@10.0.2.15:7428"
```

```bat
set ngpackages=Conari & call gnt || echo Failed
```

```bat
gnt "7z.Libs;vsSolutionBuildEvent/1.16.1:../packages/SDK"
```

Direct link to a remote package via https:

```bat
gnt :DllExport /p:ngserver=https://server/DllExport.1.7.4.nupkg
```

Direct link to a local package that will be stored at the top level next to the *gnt*

```bat
gnt : /p:ngserver=D:/local_dir/vsSolutionBuildEvent.SDK10.nupkg /p:ngpath=SDK10
```

```bat
gnt "Conari;Fnv1a12;LX4Cnh" /p:break=no /p:debug=true

Conari use D:\prg\projects\GetNuTool\GetNuTool\bin\Release\packages\Conari
Fnv1a12 ... The remote server returned an error: (404) Not Found.
LX4Cnh ... D:\prg\projects\GetNuTool\GetNuTool\bin\Release\packages\LX4Cnh
- /.version
- /build-info.txt
- /lib/net40/LX4Cnh.dll
- /lib/net40/LX4Cnh.xml
- /lib/net5.0/LX4Cnh.dll
- /lib/net5.0/LX4Cnh.xml
- /License.txt
- /LX4Cnh.nuspec
- /Readme.md
- /tools/gnt.bat
- /tools/hMSBuild.bat
...
```

```bat
gnt Huid/1.0.0:src.zip /t:grab
```

See also examples from [tests/](tests/keysAndLogicTests.bat)

### Build and Use from source

```bat
git clone https://github.com/3F/GetNuTool.git src
cd src & build & bin\Release\gnt Conari
```

### .sha1 official distribution

*GetNuTool* releases are now accompanied by a *.sha1* file in the official distribution; At the same time, commits from which releases are published are signed with the committer's verified signature (GPG).

Make sure you are using official, unmodified, safe versions.

Note: *.sha1* file is a text list of published files with checksums in the format: 

`40-hexadecimal-digits` `<space>` `file`

```
eead8f5c1fdff2abd4da7d799fbbe694d392c792 path\file
...
```

## Contributing

[*GetNuTool*](https://github.com/3F/GetNuTool) is waiting for your awesome contributions!