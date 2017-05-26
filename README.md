# [GetNuTool](https://github.com/3F/GetNuTool)

The lightweight NuGet Client as a portable & embeddable tool for work with NuGet packages via basic MSBuild 
(it does not require any additional extensions).

[![Build status](https://ci.appveyor.com/api/projects/status/rv65lbks5frc4k52/branch/master?svg=true)](https://ci.appveyor.com/project/3Fs/getnutool/branch/master) [![release-src](https://img.shields.io/github/release/3F/GetNuTool.svg)](https://github.com/3F/GetNuTool/releases/latest) [![License](https://img.shields.io/badge/License-MIT-74A5C2.svg)](https://github.com/3F/GetNuTool/blob/master/LICENSE)

```bash
> gnt                                           # Executable version - full logic inside single script
> msbuild gnt.core                              # Full & Compact versions to execute via MSBuild
[NuGet gnt.raw("/t:pack /p:ngin=\"7z.Libs\"")]  # Compiled variant via vssbe
```

[just try](https://github.com/3F/GetNuTool/releases/download/v1.6/gnt.bat) this:
```bash
gnt /p:ngpackages="Conari;regXwild"             # To get `Conari` & `regXwild` packages
gnt /t:pack /p:ngin="bin\DllExport"             # To create new NuGet package from `bin\DllExport` .nuspec
gnt /p:ngpackages="LunaRoad/1.4.1"              # To get `LunaRoad` package v1.4.1
msbuild gnt.core /p:ngconfig="packages.config"  # Use `packages.config`
gnt /p:ngserver="https://chocolatey.org/api/v2/package/" /p:ngpackages="putty.portable/0.69"
```

**Download:** [/releases](https://github.com/3F/GetNuTool/releases) [ **[latest](https://github.com/3F/GetNuTool/releases/latest)** ] - *Full version, Minified version, Compiled variant, Executable version*

* Demo: [GetNuTool v1.5 `get` & `pack` commands in use](https://ci.appveyor.com/project/3Fs/vssolutionbuildevent/build/build-178)

## Projects that based on GetNuTool core

* [hMSBuild](https://github.com/3F/hMSBuild) - A lightweight tool (compiled batch file ~19 Kb that can be embedded inside any scripts or other batch files) - an easy helper for searching of available MSBuild tools. https://github.com/3F/hMSBuild

## License

The [MIT License (MIT)](https://github.com/3F/GetNuTool/blob/master/LICENSE)

```
Copyright (c) 2015-2017 Denis Kuzmin <entry.reg@gmail.com>
```

[![Donate](https://www.paypalobjects.com/en_US/i/btn/btn_donate_SM.gif)](https://www.paypal.com/cgi-bin/webscr?cmd=_donations&business=entry%2ereg%40gmail%2ecom&lc=US&item_name=3F%2dOpenSource%20%5b%20github%2ecom%2f3F&currency_code=USD&bn=PP%2dDonationsBF%3abtn_donate_SM%2egif%3aNonHosted)


## Why GetNuTool ?

Primarily this to providing tools and service of your projects, libraries, the build processes, debugging, etc. For all that should be used as a tool for all projects ([solution-level](https://github.com/NuGet/Home/issues/1521)) or for each.

* The best examples:
    * [vsSBE.CI.MSBuild](https://www.nuget.org/packages/vsSBE.CI.MSBuild/)
    * [7z.Libs](https://www.nuget.org/packages/7z.Libs/)
    * [ILAsm](https://www.nuget.org/packages/ILAsm/)

**But!** How about to consider it like a more lightweight & powerful nuget client for getting packages or for new packaging. No, seriously, we already use it for many projects like:

* [Conari](https://github.com/3F/Conari)
* [DllExport](https://github.com/3F/DllExport)
* [vsSolutionBuildEvent](https://github.com/3F/vsSolutionBuildEvent)
* [LunaRoad](https://github.com/3F/LunaRoad)
* [vsCommandEvent](https://github.com/3F/vsCommandEvent)
* [regXwild](https://github.com/3F/regXwild)
* ...

*Because it easy, and works well.*

#### Restoring packages inside Visual Studio IDE

The GetNuTool can't use events from Visual Studio **by default**. However, it can be combined with other our tool for complex work with **lot of events** of VS IDE & MSBuild:

* [vsSolutionBuildEvent](https://visualstudiogallery.msdn.microsoft.com/0d1dbfd7-ed8a-40af-ae39-281bfeca2334/) - https://github.com/3F/vsSolutionBuildEvent

So you can use this as you want, for example, automatically getting tool above for complex scripting in MSBuild & Visual Studio as unified engine., etc.

### Main features

* Getting the all selected `.nupkg` packages from any NuGet server (+Chocolatey) from user list with formats below.
    * Two formats: list from `.config` files or direct from string.
* Extracting the all data from `.nupkg` into path by default or specific for each package.
    * +Custom naming for each package with ignoring for already downloaded packages.
* Dependencies are not considered! get it manually as other packages above.
* [NuGet events](http://docs.nuget.org/create/Creating-and-Publishing-a-Package#automatically-running-powershell-scripts-during-package-installation-and-removal) *(Init.ps1, Install.ps1, Uninstall.ps1)* currently are not considered. Call it manually from `/tools`.
* Creating new (packing) NuGet packages as `.nupkg` by using `.nuspec`
* Wrapping of any package in one executable file, for example:
    * CI.MSBuild **in one click** ~10 Kb: **[get.CIM.bat](https://github.com/3F/vsSolutionBuildEvent/releases/download/release_v0.12.10/get.CIM.bat)**
* With our `.packer` can be easy embedded inside of any scripts, like [hMSBuild](https://github.com/3F/hMSBuild)
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

Samples:

```bash
> msbuild gnt.core /p:ngpath="special-packages/new"
```
```bash
> msbuild gnt.core /p:ngconfig=".nuget/packages.config" /p:ngpath="../packages"
```

#### Format of packages list

Attribute | Description
----------|-------------
id        | Identifier of package.
version   | Version of package.
output    | Optional path for getting package.

Property: 

```bash
/p:ngpackages="id[/version][:output]"
```

```bash
/p:ngpackages="id[/version][:output];id2[/version][:output];..."
```

packages.config:
    
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

multiple:

* `;` - v1.6+ 
* `|` - v1.0+ (*obsolete and can be removed in new versions*)

```bash
/p:ngconfig="debug.config;release.config;..."
/p:ngconfig=".nuget/packages.config|project1/packages.config|project2/packages.config|..."
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

## Properties

Property | Values                   | Description
---------|--------------------------|------------
debug    | false (by default), true | `v1.3+` To display additional information from selected command.

## Examples

*note: `v1.4+` also provides executable variant of GetNuTool.*

```bash
> gnt /p:ngpackages="Conari" 
> msbuild gnt.core /p:ngpackages="DllExport" 
```

```bash
> msbuild gnt.core
> msbuild gnt.core /p:ngpackages="7z.Libs/16.04.0;vsSBE.CI.MSBuild/1.6.12010:../packages/CI.MSBuild"
```

```bash
> msbuild gnt.core /t:pack /p:ngin="app\LunaRoad"
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

**note:** you do not need the `gnt.core` or something else ! the final script provides all of what you need as non-binary tool ~10 Kb.

### Additional arguments

key             | Description                                             | Sample
----------------|---------------------------------------------------------|----------------
`-unpack`       | To generate minified version from executable. `v1.6+`   | `gnt -unpack`
`-msbuild` path | To use specific msbuild if needed. `v1.6+`              | `gnt -msbuild "D:\MSBuild\bin\amd64\msbuild" /p:ngpackages="Conari"`