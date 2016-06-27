# GetNuTool

The lightweight non-binary tool for work with NuGet packages via basic MSBuild Tools (without additional extensions etc.)

```bash
> gnt
> msbuild.exe gnt.core
```

**Download:** [/releases](https://github.com/3F/GetNuTool/releases) ( [latest](https://github.com/3F/GetNuTool/releases/latest) )

* Available: *Full version, Compact version, Compiled variant, Executable version*

Demo project: [![](https://img.shields.io/badge/build143-passing-brightgreen.svg?style=flat)](https://ci.appveyor.com/project/3Fs/vssolutionbuildevent/build/build-143) [GetNuTool v1.3 `get` & `pack` commands in use](https://ci.appveyor.com/project/3Fs/vssolutionbuildevent/build/build-143)

## License

The [MIT License (MIT)](https://github.com/3F/GetNuTool/blob/master/LICENSE)

## Main features

* Getting the all selected `.nupkg` packages from NuGet server from user list with formats below.
    * Two formats: list from `.config` files or direct from string.
* Extracting the all data from `.nupkg` into path by default or specific for each package.
    * +Custom naming for each package with ignoring for already downloaded packages.
* Dependencies are not considered! get it manually as other packages above.
* [NuGet events](http://docs.nuget.org/create/Creating-and-Publishing-a-Package#automatically-running-powershell-scripts-during-package-installation-and-removal) *(Init.ps1, Install.ps1, Uninstall.ps1)* currently are not considered. Call it manually from `/tools`.
* Packing packages as `.nupkg` by using `.nuspec`

### For what 

Mainly, it's not for adding libraries for your projects (see standard nuget clients). This to providing tools for additional maintenance of your projects and libraries, building processes, debugging, and similar. For all that should be used as a tool for all projects (solution-level) or for each.

#### Restoring packages inside Visual Studio IDE

The GetNuTool can't use events from Visual Studio **by default**. However, it can be combined with other our tool for complex work with **a lot of events** of VS IDE & MSBuild:

* [vsSolutionBuildEvent](http://vssbe.r-eg.net) - [0d1dbfd7-ed8a-40af-ae39-281bfeca2334](https://visualstudiogallery.msdn.microsoft.com/0d1dbfd7-ed8a-40af-ae39-281bfeca2334/)

So you can use this as you want, for example, automatically getting tool above for work with complex scripts with MSBuild Tool and Visual Studio as unified engine., etc.

## Commands

### `get` 

The `get` command is used by default. For getting & extracting packages. You can also use it as `/t:get`

Settings:

Property   | Description
-----------|------------
ngconfig   | Where to look the packages.config files.
ngserver   | NuGet server.
ngpackages | List of packages. Uses first if defined, otherwise find packages.config
ngpath     | Common path for all packages.
wpath      |`v1.4+` To define working directory.

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
**Note:** Attributes for v1.2+ is now are case sensitive. Use lowercase for `id`, `version`, `output` ...

#### Format of ngconfig

```bash
/p:ngconfig=".nuget/packages.config"
```
multiple:
```bash
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
> gnt /p:ngpackages="DllExport" 
> msbuild gnt.core /p:ngpackages="DllExport" 
```

```bash
> msbuild gnt.core
> msbuild gnt.core /p:ngpackages="7z.Libs/15.12.0;vsSBE.CI.MSBuild/1.5.1:../packages/CI.MSBuild"
```

```bash
> msbuild gnt.core /t:pack /p:ngin="D:\tmp\7z.Libs"
> msbuild gnt.core /t:pack /p:ngin="D:\tmp\7z.Libs" /p:ngout="newdir/"
```

#### Paths to MSBuild Tools

Use our MSBuild searcher - [msbuild](https://github.com/3F/GetNuTool/blob/master/msbuild.bat) for more convenience.

*but, just a note where to find the msbuild tool by default:*

* All available versions on your machine: `HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\MSBuild\ToolsVersions`

for example:
```bash

"C:\Program Files (x86)\MSBuild\14.0\bin\msbuild.exe"
"C:\Program Files (x86)\MSBuild\12.0\bin\msbuild.exe"
C:\Windows\Microsoft.NET\Framework\v4.0.30319\msbuild.exe
C:\Windows\Microsoft.NET\Framework64\v4.0.30319\msbuild.exe
```

+GAC_32, GAC_64, ...

## Compact version

To build manually this version, you should use our compressor from [here](https://github.com/3F/GetNuTool/tree/master/compact) if needed. 

Currently compact version ~4 Kb for `get` command and ~4 Kb for `pack` command, i.e. ~8 Kb in total.

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

To build manually this version, you should use our packer from [here](https://github.com/3F/GetNuTool/tree/master/wrapper) if needed.

```bash
> packing
```

```bash
> msbuild wrapper/.packer /p:core="path to compact core" /p:output="output file"
```

Then you can use simply:

```bash
> gnt /p:ngpackages="vsSBE.CI.MSBuild"
```
**note:** you do not need the `gnt.core` or something else ! the final script provides all of what you need as non-binary tool ~10 Kb.
