# [GetNuTool](https://github.com/3F/GetNuTool)

Embeddable Package Manager. NuGet / Chocolatey Client. And the lightweight portable tool for work with packages. *(pure implementation **without** powershell or dotnet-cli)*

[![Build status](https://ci.appveyor.com/api/projects/status/gw8tij2230gwkqs6/branch/master?svg=true)](https://ci.appveyor.com/project/3Fs/getnutool-github/branch/master)
[![release](https://img.shields.io/github/release/3F/GetNuTool.svg)](https://github.com/3F/GetNuTool/releases/latest) 
[![License](https://img.shields.io/badge/License-MIT-74A5C2.svg)](https://github.com/3F/GetNuTool/blob/master/LICENSE)

```bash
> gnt                                           # Executable versions via single shell script
> msbuild gnt.core                              # Full & Compact versions to execute via MSBuild
[NuGet gnt.raw("/t:pack /p:ngin=7z.Libs")]      # Compiled versions via SobaScript
```

🛩 try it

```bash
gnt Fnv1a128                                    # Get `Fnv1a128` package
gnt /t:pack /p:ngin="bin\DllExport"             # Create new DllExport package
gnt "Conari;regXwild"                           # Get `Conari` & `regXwild` packages
msbuild gnt.core /p:ngpackages="LuNari/1.6.0"   # Get `LuNari` package v1.6.0
gnt /p:ngconfig="packages.config"               # Use `packages.config`
set ngpackages=Conari & gnt                     # shell scripts
gnt /p:ngpackages="putty.portable/0.69"         # chocolatey
    /p:ngserver="https://chocolatey.org/api/v2/package/"
```

**Download:** [/releases](https://github.com/3F/GetNuTool/releases) [ **[latest stable](https://github.com/3F/GetNuTool/releases/latest)** ] - *Full version, Minified version, Compiled variant, Executable version*

* (Windows) Latest stable compiled batch-script [ [gnt.bat](https://3F.github.io/GetNuTool/releases/latest/gnt/) ]

* CI builds: [`/artifacts` page](https://ci.appveyor.com/project/3Fs/getnutool-github/history) ( [old CI](https://ci.appveyor.com/project/3Fs/getnutool/history) ) or find as `Pre-release` with mark `🎲 Nightly build` on [GitHub Releases](https://github.com/3F/GetNuTool/releases) page.


### Projects on GetNuTool core

* [hMSBuild](https://github.com/3F/hMSBuild) - Compiled text-based embeddable pure batch-scripts for searching of available MSBuild tools. VS2017+, VS2015, VS2013, VS2010, other versions from .NET Framework. Contains gnt.core for work with NuGet packages and more...
* [.NET DllExport Manager](https://github.com/3F/DllExport/wiki/DllExport-Manager) - *It was based on GetNuTool core that's Cross-Platform Embeddable Package Manager that requires only MSBuild. Finally it just aggregates calling to Wizard that was based on [MvsSln](https://github.com/3F/MvsSln).*

### Demo use

* [GetNuTool v1.5 `get` & `pack` commands in use](https://ci.appveyor.com/project/3Fs/vssolutionbuildevent/build/build-178)

## License

Licensed under the [MIT License (MIT)](https://github.com/3F/GetNuTool/blob/master/LICENSE)

```
Copyright (c) 2015-2024  Denis Kuzmin <x-3F@outlook.com> github/3F
```

GetNuTool contributors: https://github.com/3F/GetNuTool/graphs/contributors

[ [ ❤ ](https://3F.github.io/fund) ]

We're waiting for your awesome contributions!

## Why GetNuTool

It was initially developed to provide tool for servicing projects, libraries, and other related build processes as the tool for all projects at once ([solution-level](https://github.com/NuGet/Home/issues/1521)) and for each separately.

* Best examples:
    * [vsSBE.CI.MSBuild](https://www.nuget.org/packages/vsSBE.CI.MSBuild/)
    * [7z.Libs](https://www.nuget.org/packages/7z.Libs/)
    * [ILAsm](https://www.nuget.org/packages/ILAsm/)

But! You can also consider it like a more lightweight but still powerful nuget client for receiving packages or for creating new. Seriously, we already use it for many projects like:

* [Conari](https://github.com/3F/Conari)
* [DllExport](https://github.com/3F/DllExport)
* [MvsSln](https://github.com/3F/MvsSln)
* [vsSolutionBuildEvent](https://github.com/3F/vsSolutionBuildEvent)
* [LuNari](https://github.com/3F/LuNari)
* [vsCommandEvent](https://github.com/3F/vsCommandEvent)
* [regXwild](https://github.com/3F/regXwild)
* ...

*Because it easy, open, and free.*

#### Restoring packages inside Visual Studio IDE

GetNuTool can't use events from Visual Studio **by default**. However, it can be combined with other tool for complex work with **lot of events** of VS IDE & MSBuild:

* [https://github.com/3F/vsSolutionBuildEvent](https://github.com/3F/vsSolutionBuildEvent)

Thus, you can use this as you want, for example, automatically getting tool above for complex scripting in MSBuild & Visual Studio as unified engine and so on.

### Main features

* Getting the all selected `.nupkg` packages from any NuGet server (+Chocolatey) from user list with formats below.
    * Two formats: list from `.config` files or direct from string.
* Extracting the all data from `.nupkg` into path by default or specific for each package.
    * +Custom naming for each package with ignoring for already downloaded packages.
* Dependencies are not considered! get it manually as other packages above.
* [NuGet events](http://docs.nuget.org/create/Creating-and-Publishing-a-Package#automatically-running-powershell-scripts-during-package-installation-and-removal) *(Init.ps1, Install.ps1, Uninstall.ps1)* currently are not considered. Call it manually from `/tools`.
* Creating new (packing) NuGet packages as `.nupkg` by using `.nuspec`
* Wrapping of any package in one executable file, for example:
    * vsSolutionBuildEvent **in one click** ~9 Kb: **[get-vsSBE.1.14.0.bat](https://github.com/3F/vsSolutionBuildEvent/releases/download/1.14/get-vsSBE.1.14.0.bat)**
* With our `.packer` can be easily embedded inside of any scripts, such for pure batch-script [hMSBuild](https://github.com/3F/hMSBuild)
* A lot of versions for your comfortable work - Full version, Minified version, Compiled variant, Executable version.
* ...

## Commands

### `get` 

The `get` command is used by default. For getting & extracting packages. You can also use it as `/t:get`

Settings:

Property   | Description                                                             | Default values
-----------|-------------------------------------------------------------------------|-----------------
ngconfig   | Where to look the packages.config files.                                | v1.6+ `packages.config`, v1.0 - v1.5: `.nuget\packages.config`
ngserver   | NuGet server.                                                           | v1.0+ `https://www.nuget.org/api/v2/package/`
ngpackages | List of packages. Use it first if defined, otherwise find via ngconfig  | v1.0+ *empty*
ngpath     | Common path for all packages.                                           | v1.0+ `packages`
wpath      |`v1.4+` To define working directory.                                     | v1.4+ *The absolute path of the directory where the GetNuTool is located.*
proxycfg   | `v1.6.2+` To configure connection via proxy.                            | v1.6.2+ *empty*. Format: [usr[:pwd]@]host[:port]
ssl3       | `1.9+` Do not drop legacy ssl3 + tls1.0 + tls1.1 if `true`              | 1.9+ *false*, only modern tls1.2, tls1.3+
break      | `1.9+` Disable the break on first package error if `no`                 | 1.9+ empty

Fo example:

```bat
set ngpackages=Conari & call gnt
```

```bat
gnt /p:ngpackages="Conari;regXwild;MvsSln"
```

```bash
msbuild gnt.core /p:ngpath="special-packages/new"
```
```bash
msbuild gnt.core /p:ngconfig=".nuget/packages.config" /p:ngpath="../packages"
```
```bash
gnt /p:ngpackages=Conari /p:proxycfg="guest:1234@10.0.2.15:7428"
```

A direct link to a remote package via https:

```bash
gnt /p:ngpackages=:vsSolutionBuildEvent /p:ngserver=https://server/vsSolutionBuildEvent.SDK10.nupkg
```

A direct link to a local package that will be stored at the top level next to the *gnt*

```bash
gnt /p:ngserver=D:/local_dir/vsSolutionBuildEvent.SDK10.nupkg /p:ngpackages=: /p:ngpath=SDK10
```

```bat
gnt /p:ngpackages="Conari;LX4cn;Fnv1a128" /p:break=no /p:debug=true

Conari use D:\prg\projects\GetNuTool\GetNuTool\packages\Conari
LX4cn ... The remote server returned an error: (404) Not Found.
Fnv1a128 ... D:\prg\projects\GetNuTool\GetNuTool\packages\Fnv1a128
- /.version
- /build-info.txt
- /changelog.txt
- /Fnv1a128.nuspec
- /lib/net40/Fnv1a128.dll
- /lib/net40/Fnv1a128.xml
- /lib/net472/Fnv1a128.dll
- /lib/net472/Fnv1a128.xml
- /lib/net5.0/Fnv1a128.dll
- /lib/net5.0/Fnv1a128.xml
- /lib/netcoreapp2.1/Fnv1a128.dll
- /lib/netcoreapp2.1/Fnv1a128.xml
- /lib/netstandard2.0/Fnv1a128.dll
- /lib/netstandard2.0/Fnv1a128.xml
...
```

#### Format of packages list

```
id[/version][:output]|id2[/version][:output]|...
```

Attribute | Description                                 | Example
----------|---------------------------------------------|------------------------------
id        | Identifier of package.                      | [Conari](https://www.nuget.org/packages/Conari)
version   | **(Optional)** Version of package.          | `1.3.0` or `1.3-beta2` or `1.3-RC` etc
output    | **(Optional)** Path to write package data.  | `../tests/ConariForTest`

Multiple packages via delimiters:

* `;`
    * `id1;id2;id3` Optional, starting from 1.7+. Means usage as an delimiter **only when** the `|` is not found.
* `|`
    * `id1:dir;name|id2` Package **id1** into directory **dir;name** and package **id2** in `ngpath` path.

To use via arguments: 

```bash
/p:ngpackages="id[/version][:output]"
```

```bash
/p:ngpackages="id[/version][:output];id2[/version][:output];..."
```

To use via packages.config:
    
```xml

<packages>
  <package id="ident" version="1.2.0" />
  <package id="ident.second" version="15.0" output="path" />
</packages>
```
**Note:** Attributes for v1.2+ are case sensitive now. Use lowercase for `id`, `version`, `output` ...

#### Format of ngconfig

```bash
/p:ngconfig=".nuget/packages.config"
```

Multiple config files via delimiters:

* `;` - v1.6+ (Optional, starting from 1.7+. Means usage as an delimiter **only when** the `|` is not found.)
* `|` - v1.0+ 

```bash
/p:ngconfig="debug.config;release.config;..."
/p:ngconfig=".nuget/packages.config|project1/packages.config|project2/packages.config|..."
```

### `grab`

`1.9+`

Grabs data without unpacking. The available parameters are similar to the `get` command above.

For example:

```bat
gnt /t:grab /p:ngserver=https://server/netfx4sdk.cmd;ngpackages=:../netfx4sdk.cmd
```

```bat
gnt /t:grab /p:ngpackages=Fnv1a128:src.nupkg
```

### `pack`

The `pack` command. For creating the new .nupkg packages by .nuspec specification. Use it as `/t:pack`

Settings:

Property | Description
---------|------------
ngin     | To select path to directory for packing with `.nuspec` file.
ngout    | Optional path to output the final `.nupkg` package.
wpath    |`v1.4+` To define working directory.

```bash
> msbuild gnt.core /t:pack /p:ngin="path to .nuspec"
> msbuild gnt.core /t:pack /p:ngin="path to .nuspec" /p:ngout="path for .nupkg"
```

## Global Properties

Property | Value
---------|-------------
debug    | `true` to add extra info in stream.
logo     | `no` to hide logo when processing starts.

For example:

```bat
gnt /t:pack /p:ngin=packages\LX4Cnh /p:debug=true
```

```bat
set debug=true & gnt /p:ngpackages="Conari;LX4cn;Fnv1a128" /p:break=no
```

## Examples

*note: `v1.4+` also provides executable variant of GetNuTool.*

```bash
> gnt /p:ngpackages="Conari" 
> msbuild gnt.core /p:ngpackages="DllExport" 
```

```bash
> msbuild gnt.core
> msbuild gnt.core /p:ngpackages="7z.Libs/16.04.0;vsSolutionBuildEvent/1.14.0:../packages/CI.MSBuild"
```

```bash
> msbuild gnt.core /t:pack /p:ngin="app\LuNari"
> msbuild gnt.core /t:pack /p:ngin="D:\tmp\7z.Libs" /p:ngout="newdir/"
```

#### Path to MSBuild Tools

*If you need, try [hMSBuild](https://github.com/3F/hMSBuild) and have fun.*

## Compact & Minified versions

To build this version you can use our compressor from [here](https://github.com/3F/GetNuTool/tree/master/minified). 

Currently minified version ~4 Kb for `get` command and ~4 Kb for `pack` command, i.e. ~8 Kb in total.

```bash
> compress
```

```bash
> msbuild .compressor
> msbuild .compressor /p:core="path to core" /p:output="output file"
```

## Compiled variant

The GetNuTool now is part of [NuGetComponent](http://vssbe.r-eg.net/doc/Scripts/SBE-Scripts/Components/NuGetComponent/) ([SBE-Scripts](http://vssbe.r-eg.net/doc/Scripts/SBE-Scripts/))

```java
#[NuGet gnt.raw("/t:pack /p:ngin=\"D:\7z.Libs\"")]
...
```

## Executable version

The `gnt.bat` is already contains `gnt.core` logic. It stored **inside script**.

To build this version you should use our packer from [here](https://github.com/3F/GetNuTool/tree/master/embedded).

```bash
> packing
```

```bash
> msbuild embedded/.packer /p:core="path to minified core" /p:output="output file"
```

Now, you can use it simply:

```bash
> gnt ...
> gnt /p:ngpackages="Conari"
```

**note:** you do not need the `gnt.core` or something else ! the final script provides all of what you need as non-binary tool ~9 Kb.

### Additional arguments

 First key to gnt     | Description                                                                             | Example
----------------------|-----------------------------------------------------------------------------------------|----------------
 `-unpack`            | `1.6+` To generate minified version from executable.                                    | `gnt -unpack`
 ~~`-msbuild`~~ path  | `1.6` - `1.8` To use specific msbuild if needed. Removed in 1.9, use *hMSBuild* instead | `gnt -msbuild "D:\MSBuild\bin\amd64\msbuild" /p:ngpackages=Conari`

### Override engine

Since the `-msbuild` key was removed in 1.9 as obsolete, you have following ways to override engine search:

Either create `engine.cmd` in the directory from which the call *gnt.bat* is planned; with the following content, for example:

```bat
@echo msbuild.exe
```

Or place a full version of [hMSBuild.bat](https://github.com/3F/hMSBuild) (~19 KB) tool instead of *engine.cmd* stub.


Or -unpack command:

```bat
gnt -unpack & msbuild.exe gnt.core {args}
```

Or `engine` environment variable:

```bat
set engine=msbuild.exe & gnt {args}
```